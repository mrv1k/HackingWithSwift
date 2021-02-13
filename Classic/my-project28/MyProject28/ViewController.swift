//
//  ViewController.swift
//  MyProject28
//
//  Created by Viktor Khotimchenko on 2021-02-12.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!

    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .done)
        button.target = self
        button.action = #selector(saveSecretMessage)
        button.isEnabled = false
        button.tintColor = UIColor.clear
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Nothing to see here"

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @IBAction func onAuthenticateTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason) { success, _ in
                    DispatchQueue.main.async {
                        if success {
                            self.unlockSecretMessage()

                            self.doneButton.isEnabled = true
                            self.doneButton.tintColor = nil
                            self.navigationItem.leftBarButtonItem = self.doneButton

                        } else {
                            let ac = UIAlertController(
                                title: "Authentication failed",
                                message: "You could not be verified; please try again.",
                                preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated: true)
                        }
                    }
            }
        } else {
            let ac = UIAlertController(
                title: "Biometry unavailable",
                message: "Your device is not configured for biometric identification.",
                preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset
        secret.scrollRangeToVisible(secret.selectedRange)
    }

    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret"

        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }

    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }

        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"

        self.doneButton.isEnabled = false
        self.doneButton.tintColor = UIColor.clear
    }
}
