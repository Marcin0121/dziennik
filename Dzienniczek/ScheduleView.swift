import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel

    var body: some View {
        VStack {
            Picker("Wybierz dzień", selection: $viewModel.selectedDay) {
                ForEach(viewModel.daysOfWeek, id: \.self) { day in
                    Text(day)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                ForEach(viewModel.lessons.filter { $0.day == viewModel.selectedDay }.sorted { $0.lessonNumber < $1.lessonNumber }) { lesson in
                    VStack(alignment: .leading) {
                        Text(lesson.subject)
                            .font(.headline)
                        Text(lesson.hour)
                            .font(.subheadline)
                        Text("Sala: \(lesson.room)")
                            .font(.subheadline)
                    }
                }
                .onDelete(perform: deleteLessons)
            }
            .listStyle(PlainListStyle())

            HStack {
                Spacer()
                Button("Dodaj lekcję") {
                    viewModel.addLesson(subject: "Nowa lekcja", hour: "10:00 - 11:00", day: viewModel.selectedDay, lessonNumber: viewModel.lessons.filter { $0.day == viewModel.selectedDay }.count + 1, room: "101")
                }
                .padding()
                Spacer()
            }
            .padding(.bottom)

            HStack {
                Spacer()
                Button("Importuj") {
                    if let fileURL = Bundle.main.url(forResource: "Plan zajęć", withExtension: "pdf") {
                        viewModel.importLessonsFromPDF(fileURL: fileURL)
                    }
                }
                .font(.caption)
                .padding(8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                Spacer()
            }
            .padding(.bottom)
        }
        .navigationTitle("Plan lekcji")
    }

    func deleteLessons(at offsets: IndexSet) {
        let lessonsToDelete = offsets.map { viewModel.lessons.filter { $0.day == viewModel.selectedDay }.sorted { $0.lessonNumber < $1.lessonNumber }[$0].id }
        viewModel.removeLessons(with: lessonsToDelete, for: viewModel.selectedDay)
    }
}
