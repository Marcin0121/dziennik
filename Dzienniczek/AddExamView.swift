import SwiftUI

struct AddExamView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var examViewModel: ExamViewModel

    @State private var subject: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""
    @State private var type: ExamType = .sprawdzian
    @State private var zakresMaterialu: String = "" // Dodano
    @State private var typSprawdzianu: String = "" // Dodano
    @State private var ocena: Double = 0.0 // Dodano
    @State private var zaliczone: Bool = false // Dodano

    var body: some View {
        Form {
            TextField("Przedmiot", text: $subject)
            DatePicker("Data", selection: $date, displayedComponents: .date)
            TextField("Opis", text: $description)
            Picker("Typ", selection: $type) {
                ForEach(ExamType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            TextField("Zakres materiału", text: $zakresMaterialu) // Użyj zadeklarowanej zmiennej
            TextField("Typ sprawdzianu", text: $typSprawdzianu) // Użyj zadeklarowanej zmiennej
            Stepper("Ocena: \(ocena)", value: $ocena) // Użyj zadeklarowanej zmiennej
            Toggle("Zaliczone", isOn: $zaliczone) // Użyj zadeklarowanej zmiennej

            Button("Dodaj") {
                let newExam = Exam(subject: subject, date: date, description: description, type: type, zakresMaterialu: zakresMaterialu, typSprawdzianu: typSprawdzianu, ocena: ocena, zaliczone: zaliczone)
                examViewModel.addExam(exam: newExam);                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
