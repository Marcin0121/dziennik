import SwiftUI

struct AddLessonView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ScheduleViewModel
    @State private var subject = ""
    @State private var hour = ""
    @State private var lessonNumber = 1 // Dodaj pole do wprowadzania numeru lekcji
    var selectedDay: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Szczegóły lekcji")) {
                    TextField("Przedmiot", text: $subject)
                    TextField("Godzina lekcyjna", text: $hour)
                    Stepper("Numer lekcji: \(lessonNumber)", value: $lessonNumber, in: 1...10) // Dodaj Stepper do wyboru numeru lekcji
                }
                Button(action: {
                    viewModel.addLesson(subject: subject, hour: hour, day: selectedDay, lessonNumber: lessonNumber)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Dodaj lekcję")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Dodaj lekcję")
            .navigationBarItems(trailing: Button("Zamknij") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
