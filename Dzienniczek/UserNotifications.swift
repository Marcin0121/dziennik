//
//  UserNotifications.swift
//  Dzienniczek
//
//  Created by Marcin Seńko on 2/28/25.
//


import UserNotifications

func scheduleLessonNotification(lesson: Lesson, minutesBefore: Int) {
    let content = UNMutableNotificationContent()
    content.title = "Zbliża się lekcja: \(lesson.subject)"
    content.body = "Lekcja rozpoczyna się o \(lesson.hour) w sali \(lesson.room)"
    content.sound = UNNotificationSound.default

    let calendar = Calendar.current
    var dateComponents = calendar.dateComponents([.weekday, .hour, .minute], from: dateFrom(day: lesson.day, in: Date()))

    let lessonHourComponents = lesson.hour.components(separatedBy: " - ")[0].components(separatedBy: ":")
    if let hour = Int(lessonHourComponents[0]), let minute = Int(lessonHourComponents[1]) {
        dateComponents.hour = hour
        dateComponents.minute = minute - minutesBefore
    }

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let request = UNNotificationRequest(identifier: lesson.id.uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Błąd planowania powiadomienia: \(error)")
        }
    }
}