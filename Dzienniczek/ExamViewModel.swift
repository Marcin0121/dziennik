//
//  ExamViewModel.swift
//  Dzienniczek
//
//  Created by Marcin Seńko on 2/28/25.
//


import SwiftUI

class ExamViewModel: ObservableObject {
    @Published var exams: [Exam] = []


    init() {
        loadExams()
    }

    func addExam(exam: Exam) {
        exams.append(exam)
        saveExams()
    }

    func updateExam(exam: Exam) {
        if let index = exams.firstIndex(where: { $0.id == exam.id }) {
            exams[index] = exam
            saveExams()
        }
    }

    func deleteExam(at offsets: IndexSet) {
        exams.remove(atOffsets: offsets)
        saveExams()
    }

    private func saveExams() {
        if let encoded = try? JSONEncoder().encode(exams) {
            UserDefaults.standard.set(encoded, forKey: "SavedExams")
        }
    }

    private func loadExams() {
        if let data = UserDefaults.standard.data(forKey: "SavedExams"),
           let decodedExams = try? JSONDecoder().decode([Exam].self, from: data) {
            exams = decodedExams
        }
    }
}
