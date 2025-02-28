import SwiftUI

struct EditLessonView: View {
    @Binding var lesson: Lesson
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            TextField("Przedmiot", text: $lesson.subject)
            TextField("Godzina", text: $lesson.hour)
            TextField("Sala", text: $lesson.room) // Dodano pole sala
            Button("Zapisz zmiany") {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
