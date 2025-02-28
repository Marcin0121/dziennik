import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @ObservedObject var examViewModel: ExamListViewModel
    @State private var selectedDay = "Poniedziałek"
    @State private var showingAddLesson = false
    let daysOfWeek = ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek"]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Wybierz dzień", selection: $selectedDay) {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                List {
                    ForEach(viewModel.lessons.filter { $0.day == selectedDay }) { lesson in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(lesson.subject)
                                    .font(.headline)
                                Text(lesson.hour)
                                    .font(.subheadline)
                            }
                            Spacer()
                            if let exam = examViewModel.exams.first(where: { $0.subject.contains(lesson.subject.components(separatedBy: " (")[0]) }) {
                                Text(exam.description)
                                    .font(.subheadline)
                                    .foregroundColor(exam.type.color)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .onDelete { indexSet in
                        viewModel.removeLesson(at: indexSet, for: selectedDay)
                    }
                }
                Button("Importuj plan lekcji") {
                    if let fileURL = Bundle.main.url(forResource: "Plan zajęć", withExtension: "pdf") {
                        viewModel.importLessonsFromPDF(fileURL: fileURL)
                    }
                }
            }
            .navigationTitle("Plan lekcji")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddLesson.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddLesson) {
                AddLessonView(viewModel: viewModel, selectedDay: selectedDay)
            }
        }
    }
}
