import SwiftUI

class ExamListViewModel: ObservableObject {
    @Published var exams: [Exam] = []
    private let saveKey = "SavedExams"

    init() {
        loadData()
    }

    func addExam(exam: Exam) {
        exams.append(exam)
        saveData()
    }

    func removeExam(at offsets: IndexSet) {
        exams.remove(atOffsets: offsets)
        saveData()
    }

    func updateExam(exam: Exam) {
        if let index = exams.firstIndex(where: { $0.id == exam.id }) {
            exams[index] = exam
            saveData()
        }
    }

    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Exam].self, from: data) {
                exams = decoded
                return
            }
        }
        exams = []
    }

    private func saveData() {
        if let encoded = try? JSONEncoder().encode(exams) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
