import SwiftUI
import Foundation
import UserNotifications

class WorkScheduleViewModel: ObservableObject {
    @Published var persons: [Person] = [] {
        didSet {
            savePersons()
        }
    }

    private static let saveKey = "SavedPersons"

    init() {
        persons = Self.loadPersons()
    }

    func addPerson(name: String) {
        let newPerson = Person(name: name)
        persons.append(newPerson)
        sortPersons()
    }

    func removePerson(at offsets: IndexSet) {
        persons.remove(atOffsets: offsets)
    }

    func workHours(for person: Person, on date: Date) -> String? {
        if let timeRange = person.workHours[date.dateFormatted()] {
            if let (startTime, endTime) = parseTimeRange(timeRange) {
                if let hours = calculateWorkHours(from: startTime, to: endTime) {
                    return "\(startTime)-\(endTime) (\(String(format: "%.2f", hours)))"
                }
            }
        }
        return nil
    }

    func setWorkHours(_ hours: String, for person: Person, on date: Date) {
        if let index = persons.firstIndex(where: { $0.id == person.id }) {
            persons[index].workHours[date.dateFormatted()] = hours
            sortPersons()
        }
    }

    private func sortPersons() {
        persons.sort { $0.name == "Marcin" ? true : $0.name < $1.name }
    }

    private static func loadPersons() -> [Person] {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Person].self, from: data) else {
            return []
        }
        return decoded
    }

    func savePersons() {
        if let encoded = try? JSONEncoder().encode(persons) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }

    func dayOfWeekShort(_ date: Date) -> String {
        return date.dayOfWeekShort()
    }

    func dateFormatted(_ date: Date) -> String {
        return date.dateFormatted()
    }

    func weekRange(for date: Date) -> String {
        return date.weekRange()
    }

    func dateFrom(day: String, in week: Date) -> Date {
        let startOfWeek = week.startOfWeek
        let dayIndex = ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela"].firstIndex(of: day) ?? 0
        return Calendar.current.date(byAdding: .day, value: dayIndex, to: startOfWeek)!
    }

    func calculateWorkHours(from startTime: String, to endTime: String) -> Double? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let startDate = formatter.date(from: startTime),
              let endDate = formatter.date(from: endTime) else {
            return nil
        }

        let timeInterval = endDate.timeIntervalSince(startDate)
        let hours = timeInterval / 3600.0 // Konwersja sekund na godziny
        return hours
    }

    func scheduleNotification(for person: Person, on date: Date) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { granted, error in
            if granted {
                if let endTimeString = person.workHours[date.dateFormatted()],
                   let endTime = self.parseTime(from: endTimeString) {
                    let notificationTime = endTime.addingTimeInterval(-10 * 60) // 10 minut przed końcem
                    let now = Date()

                    if notificationTime > now {
                        let content = UNMutableNotificationContent()
                        content.title = "Koniec pracy za 10 minut"
                        content.body = "Wypisz się z pracy i uzupełnij ewentualne nadgodziny."
                        content.sound = UNNotificationSound.default

                        let calendar = Calendar.current
                        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: notificationTime)
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                        center.add(request)
                    }
                }
            }
        }
    }

    private func parseTime(from timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: timeString)
    }

    private func parseTimeRange(_ timeRange: String) -> (String, String)? {
        let components = timeRange.components(separatedBy: "-")
        if components.count == 2 {
            return (components[0], components[1])
        }
        return nil
    }
}
