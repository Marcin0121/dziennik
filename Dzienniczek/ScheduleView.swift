import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @ObservedObject var examViewModel: ExamListViewModel
    @State private var showingAddLesson = false

    let daysOfWeek = ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek"]

    var body: some View {
        VStack {
            Picker("Wybierz dzień", selection: $viewModel.selectedDay) {
                ForEach(daysOfWeek, id: \.self) { day in Text(day) }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                ForEach(viewModel.lessons.filter { $0.day == viewModel.selectedDay }) { lesson in
                    
                    NavigationLink(destination: EditLessonView(lesson: binding(for: lesson))) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(lesson.subject).font(.headline)
                                Text(lesson.hour).font(.subheadline)
                                Text("Sala: \(lesson.room)").font(.subheadline)
                            }
                            Spacer()
                            if let exam = examViewModel.exams.first(where: { exam in
                                viewModel.isExamMatch(exam: exam, lesson: lesson, selectedDay: viewModel.selectedDay)
                            }) {
                                Text(exam.description).font(.subheadline).foregroundColor(exam.type.color)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                }
                .onDelete { indexSet in
                    print("Indeksy do usunięcia w onDelete: \(indexSet)")
                    let lessonsToRemove = viewModel.lessons.filter { $0.day == viewModel.selectedDay }
                    print("Lekcje do usunięcia w onDelete: \(lessonsToRemove)")
                    let lessonIdsToRemove = indexSet.map { lessonsToRemove[$0].id }
                    print("ID lekcji do usunięcia: \(lessonIdsToRemove)")
                    viewModel.removeLessons(with: lessonIdsToRemove, for: viewModel.selectedDay)
                }
            }

            
            .padding(.bottom)
        }
        .navigationTitle("Plan lekcji")
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { Button(action: { showingAddLesson.toggle() }) { Image(systemName: "plus") } } }
        .sheet(isPresented: $showingAddLesson) { AddLessonView(viewModel: viewModel, selectedDay: viewModel.selectedDay) }
    }

    private func binding(for lesson: Lesson) -> Binding<Lesson> {
        guard let lessonIndex = viewModel.lessons.firstIndex(where: { $0.id == lesson.id }) else {
            fatalError("Can't find lesson in array")
        }
        return $viewModel.lessons[lessonIndex]
    }
}
