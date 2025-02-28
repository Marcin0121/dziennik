import SwiftUI

struct ExamListView: View {
    @ObservedObject var viewModel: ExamListViewModel
    @State private var showingAddExam = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.exams) { exam in
                    VStack(alignment: .leading) {
                        Text(exam.subject)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(exam.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(exam.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(exam.type.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                }
                .onDelete(perform: deleteExam)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Lista Egzaminów")
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddExam = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddExam) {
                AddExamView(viewModel: viewModel)
            }
        }
    }

    func deleteExam(at offsets: IndexSet) {
        viewModel.exams.remove(atOffsets: offsets)
    }
}
