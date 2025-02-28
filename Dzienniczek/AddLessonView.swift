import SwiftUI

struct AddLessonView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var subject = ""
    @State private var hour = ""
    @State private var room = "" // Dodano stan dla sali

    var selectedDay: String

    var body: some View {
        Form {
            TextField("Przedmiot", text: $subject)
            TextField("Godzina", text: $hour)
            TextField("Sala", text: $room) // Dodano pole sala
            Button("Dodaj") {
                let lessonNumber = viewModel.lessons.filter { $0.day == selectedDay }.count + 1
                viewModel.addLesson(subject: subject, hour: hour, day: selectedDay, lessonNumber: lessonNumber, room: room) // Dodano salę do funkcji
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
