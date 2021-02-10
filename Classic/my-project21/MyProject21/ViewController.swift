//
//  ViewController.swift
//  MyProject21
//
//  Created by Viktor Khotimchenko on 2021-02-10.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    var delayTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            if granted {
                print("Yay :)")
            } else {
                print("Nay :(")
            }
        }
    }

    @objc func scheduleLocal() {
        registerCategories()

        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird cathes the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default

        var trigger: UNTimeIntervalNotificationTrigger
        if delayTime != 0 {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayTime), repeats: false)
            content.title = "Very " + content.title.lowercased()
            delayTime = 0
        } else {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        }

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let later = UNNotificationAction(identifier: "later", title: "Remind me later", options: .authenticationRequired)
        let destroy = UNNotificationAction(identifier: "destroy", title: "Push the red button", options: .destructive)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, later, destroy], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("customdata", customData)

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("User swiped to unlock")
            case "show":
                print("show more information")
            case "later":
                print("Later dude")
                delayTime = 60 * 60 * 24
                scheduleLocal()
            case "destroy":
                print("(╯°□°)╯︵ ┻━┻")
            default:
                break
            }
        }

        completionHandler()
    }
}
