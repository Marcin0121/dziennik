import SwiftUI
import PDFKit

class ScheduleViewModel: ObservableObject {
    @Published var lessons: [Lesson] = [] {
        didSet {
            saveLessons()
        }
    }

    private let saveKey = "SavedLessons"

    init() {
        lessons = Self.loadLessons()
    }

    func addLesson(subject: String, hour: String, day: String, lessonNumber: Int) {
        let newLesson = Lesson(subject: subject, hour: hour, day: day, lessonNumber: lessonNumber)
        lessons.append(newLesson)
    }

    func removeLesson(at offsets: IndexSet, for day: String) {
        lessons.removeAll { lesson in
            offsets.contains(lessons.firstIndex(where: { $0.id == lesson.id })!) && lesson.day == day
        }
    }

    private static func loadLessons() -> [Lesson] {
        guard let data = UserDefaults.standard.data(forKey: "SavedLessons"),
              let decoded = try? JSONDecoder().decode([Lesson].self, from: data) else {
            return []
        }
        return decoded
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
            } else if !currentDay.isEmpty && !currentTime.isEmpty {
                let components = trimmedLine.components(separatedBy: "(")
                if components.count >= 2 {
                    let subject = components[0].trimmingCharacters(in: .whitespaces)
                    let room = components[1].components(separatedBy: ")")[0]
                    let teacher = components.dropFirst().joined(separator: "(").components(separatedBy: ")").dropFirst().joined(separator: ")").trimmingCharacters(in: .whitespaces)

                    let lesson = Lesson(subject: "\(subject) (\(room)) - \(teacher)", hour: currentTime, day: currentDay, lessonNumber: lessonNumber)
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
    }
}


