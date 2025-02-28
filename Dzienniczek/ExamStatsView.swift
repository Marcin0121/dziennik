//
//  ExamStatsView.swift
//  Dzienniczek
//
//  Created by Marcin Seńko on 2/28/25.
//


import SwiftUI
import Charts

struct ExamStatsView: View {
    var exams: [Exam]

    var body: some View {
        Chart(exams) { exam in
            BarMark(x: .value("Przedmiot", exam.subject), y: .value("Ocena", exam.ocena ?? 0))
        }
    }
}