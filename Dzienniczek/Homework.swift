//
//  Homework.swift
//  Dzienniczek
//
//  Created by Marcin Seńko on 2/28/25.
//

import Foundation

struct Homework: Identifiable, Codable {
    var id = UUID()
    var lessonId: UUID // ID lekcji, do której przypisane jest zadanie
    var description: String
    var dueDate: Date
    var isCompleted: Bool = false
}
