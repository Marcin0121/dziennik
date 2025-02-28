import SwiftUI

struct ExamListView: View {
    @ObservedObject var examViewModel: ExamViewModel
    @State private var showingAddExam = false

    var body: some View {
        List {
            ForEach(examViewModel.exams) { exam in
                NavigationLink(destination: EditExamView(exam: binding(for: exam))) {
                    VStack(alignment: .leading) {
                        Text(exam.subject).font(.headline)
                        Text(exam.date, style: .date).font(.subheadline).foregroundColor(.secondary)
                        Text(exam.description).font(.subheadline).foregroundColor(.secondary)
                        Text(exam.type.rawValue).font(.subheadline).foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                }
            }
            .onDelete(perform: deleteExam)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Lista Egzaminów")
        .sheet(isPresented: $showingAddExam) { AddExamView(examViewModel: examViewModel) }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddExam = true }) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func binding(for exam: Exam) -> Binding<Exam> {
        guard let examIndex = examViewModel.exams.firstIndex(where: { $0.id == exam.id }) else {
            fatalError("Can't find exam in array")
        }
        return $examViewModel.exams[examIndex]
    }

    func deleteExam(at offsets: IndexSet) {
        examViewModel.deleteExam(at: offsets)
    }
}
