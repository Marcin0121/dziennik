import SwiftUI
import PDFKit
import UserNotifications

class ScheduleViewModel: ObservableObject {
    @Published var lessons: [Lesson] = []
    @Published var selectedDay: String = "Poniedziałek"
    private let saveKey = "SavedLessons"

    init() {
        loadData()
    }

    func addLesson(subject: String, hour: String, day: String, lessonNumber: Int, room: String) {
        let newLesson = Lesson(subject: subject, hour: hour, day: day, lessonNumber: lessonNumber, room: room)
        lessons.append(newLesson)
        saveLessons()
    }

    func removeLessons(with ids: [UUID], for day: String) {
        print("Usuwanie lekcji o ID: \(ids) dla dnia: \(day)")
        lessons.removeAll { ids.contains($0.id) && $0.day == day }
        saveLessons()
        print("Aktualna lista lekcji: \(lessons)")
    }

    private func loadData() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let decoded = try? JSONDecoder().decode([Lesson].self, from: data) else {
            return
        }
        lessons = decoded
    }

    private func saveLessons() {
        if let encoded = try? JSONEncoder().encode(lessons) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func extractTextFromPDF(fileURL: URL) -> String? {
        guard let pdfDocument = PDFDocument(url: fileURL) else { return nil }
        let pageCount = pdfDocument.pageCount
        let pdfParser = PDFParser()
        return pdfParser.parse(pdfDocument: pdfDocument, pageCount: pageCount)
    }

    class PDFParser {
        func parse(pdfDocument: PDFDocument, pageCount: Int) -> String? {
            guard pageCount > 0 else { return nil }
            var fullText = ""
            for pageNumber in 0 ..< pageCount {
                guard let page = pdfDocument.page(at: pageNumber) else { continue }
                guard let pageText = page.string else { continue }
                fullText += pageText
            }
            return fullText
        }
    }

    func processExtractedText(text: String) -> [Lesson] {
        var lessons: [Lesson] = []
        let lines = text.components(separatedBy: "\n")
        var currentDay = ""
        var currentTime = ""
        var lessonNumber = 0

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)

            if trimmedLine.lowercased() == "poniedziałek" {
                currentDay = "Poniedziałek"
                currentTime = ""
                lessonNumber = 0
            } else if trimmedLine.lowercased() == "wtorek" {
                currentDay = "Wtorek"
                currentTime = ""
                lessonNumber = 0
            } else if trimmedLine.lowercased() == "środa" {
                currentDay = "Środa"
                currentTime = ""
                lessonNumber = 0
            } else if trimmedLine.lowercased() == "czwartek" {
                currentDay = "Czwartek"
                currentTime = ""
                lessonNumber = 0
            } else if trimmedLine.lowercased() == "piątek" {
                currentDay = "Piątek"
                currentTime = ""
                lessonNumber = 0
            } else if trimmedLine.range(of: "\\d{2}:\\d{2} - \\d{2}:\\d{2}", options: .regularExpression) != nil {
                currentTime = trimmedLine
                lessonNumber += 1
            } else if !currentDay.isEmpty && !currentTime.isEmpty && trimmedLine.range(of: "\\d{2}:\\d{2}", options: .regularExpression) == nil && !trimmedLine.isEmpty {
                let components = trimmedLine.components(separatedBy: "(")
                if components.count >= 2 && trimmedLine.components(separatedBy: " ").count < 3 {
                    let subject = components[0].trimmingCharacters(in: .whitespaces)
                    let room = components[1].components(separatedBy: ")")[0]

                    let lesson = Lesson(subject: "\(subject) (\(room))", hour: currentTime, day: currentDay, lessonNumber: lessonNumber, room: room)
                    lessons.append(lesson)
                } else if components.count < 2 && trimmedLine.components(separatedBy: " ").count >= 2 && trimmedLine.components(separatedBy: " ").filter({ $0.count > 1 }).count >= 2 && trimmedLine.range(of: "\\d", options: .regularExpression) == nil {
                    // Ignoruj wiersze z imieniem i nazwiskiem nauczyciela
                } else if components.count < 2 && trimmedLine.components(separatedBy: " ").count >= 1{
                    let lesson = Lesson(subject: trimmedLine, hour: currentTime, day: currentDay, lessonNumber: lessonNumber, room: "")
                    lessons.append(lesson)
                }
            }
        }
        return lessons
    }

    func importLessonsFromPDF(fileURL: URL) {
        self.lessons.removeAll()
        guard let extractedText = extractTextFromPDF(fileURL: fileURL) else {
            print("Błąd: Nie można wyodrębnić tekstu z pliku PDF.")
            return
        }
        let lessons = processExtractedText(text: extractedText)
        self.lessons.append(contentsOf: lessons)
        saveLessons()
    }

    func dateFrom(day: String, in date: Date) -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let daysToAdd = (daysOfWeek.firstIndex(of: day)! + 2 - weekday + 7) % 7
        return calendar.date(byAdding: .day, value: daysToAdd, to: calendar.startOfDay(for: date))!
    }

    var daysOfWeek: [String] {
        ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek"]
    }

    func isExamMatch(exam: Exam, lesson: Lesson, selectedDay: String) -> Bool {
        let isSameDay = Calendar.current.isDate(
            exam.date,
            inSameDayAs: dateFrom(day: selectedDay, in: exam.date)
        )
        let subjectMatches = exam.subject.contains(lesson.subject.components(separatedBy: " (")[0])
        return isSameDay && subjectMatches
    }

    func scheduleLessonNotification(lesson: Lesson, minutesBefore: Int) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "Zbliża się lekcja: \(lesson.subject)"
                content.body = "Lekcja o \(lesson.hour) w sali \(lesson.room)"
                content.sound = UNNotificationSound.default

                let date = self.dateFrom(day: lesson.day, in: Date())
                let lessonTime = lesson.hour.components(separatedBy: " - ")[0].components(separatedBy: ":")
                if let hour = Int(lessonTime[0]), let minute = Int(lessonTime[1]) {
                    var dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
                    dateComponents.hour = hour
                    dateComponents.minute = minute - minutesBefore

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: lesson.id.uuidString, content: content, trigger: trigger)

                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Błąd powiadomienia: \(error)")
                        }
                    }
                }
            }
        }
    }
}
