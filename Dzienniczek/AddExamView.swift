import SwiftUI

struct AddExamView: View {
    @State private var subject: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""
    @State private var type: ExamType = .test
    @ObservedObject var viewModel: ExamListViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Szczegóły egzaminu")) {
                    TextField("Przedmiot", text: $subject)
                    DatePicker("Data", selection: $date, displayedComponents: .date)
                    TextField("Opis", text: $description)
                    Picker("Typ", selection: $type) {
                        ForEach(ExamType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                        }
                    }
                }
                Button("Zapisz") {
                    let newExam = Exam(subject: subject, date: date, description: description, type: type)
                    viewModel.exams.append(newExam)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Dodaj Egzamin", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Anuluj") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
