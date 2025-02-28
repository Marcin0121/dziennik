import SwiftUI

struct EditExamView: View {
    @Binding var exam: Exam

    var body: some View {
        Form {
            TextField("Przedmiot", text: $exam.subject)
            DatePicker("Data", selection: $exam.date, displayedComponents: .date)
            TextField("Opis", text: $exam.description)
            Picker("Typ", selection: $exam.type) {
                ForEach(ExamType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            TextField("Zakres materiału", text: Binding(
                get: { exam.zakresMaterialu ?? "" },
                set: { exam.zakresMaterialu = $0 }
            ))
            TextField("Typ sprawdzianu", text: Binding(
                get: { exam.typSprawdzianu ?? "" },
                set: { exam.typSprawdzianu = $0 }
            ))
            Stepper("Ocena: \(exam.ocena ?? 0.0)", value: Binding(
                get: { exam.ocena ?? 0.0 },
                set: { exam.ocena = $0 }
            ))
            Toggle("Zaliczone", isOn: $exam.zaliczone)
        }
    }
}
