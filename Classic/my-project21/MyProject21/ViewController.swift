//
//  ViewController.swift
//  MyProject21
//
//  Created by Viktor Khotimchenko on 2021-02-10.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay :)")
            } else {
                print("Nay :(")
            }
        }
    }

    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird cathes the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.sound = .default

        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
}

