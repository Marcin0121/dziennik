//
//  AddHomeworkView.swift
//  Dzienniczek
//
//  Created by Marcin Seńko on 2/28/25.
//


import SwiftUI

struct AddHomeworkView: View {
    @Binding var homework: Homework

    var body: some View {
        Form {
            DatePicker("Termin oddania", selection: $homework.dueDate)
            TextField("Opis zadania", text: $homework.description)
            Toggle("Wykonane", isOn: $homework.isCompleted)
        }
    }
}