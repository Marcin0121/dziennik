import Foundation

class ExamListViewModel: ObservableObject {
    @Published var exams: [Exam] = [] {
        didSet {
            saveExams()
        }
    }

    init() {
        exams = Self.loadExams()
    }

    private static func loadExams() -> [Exam] {
        guard let data = UserDefaults.standard.data(forKey: "SavedExams"),
              let decoded = try? JSONDecoder().decode([Exam].self, from: data) else {
            return []
        }
        return decoded
    }

    private func saveExams() {
        if let encoded = try? JSONEncoder().encode(exams) {
            UserDefaults.standard.set(encoded, forKey: "SavedExams")
        }
    }
}
