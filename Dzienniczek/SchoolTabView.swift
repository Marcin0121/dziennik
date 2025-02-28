import SwiftUI

struct SchoolTabView: View {
    @ObservedObject var examViewModel: ExamListViewModel
    @ObservedObject var scheduleViewModel: ScheduleViewModel

    var body: some View {
        TabView {
            ExamListView(viewModel: examViewModel)
                .tabItem {
                    Label("Egzaminy", systemImage: "list.bullet")
                }
            ScheduleView(viewModel: scheduleViewModel, examViewModel: examViewModel) // Dodano examViewModel
                .tabItem {
                    Label("Plan Lekcji", systemImage: "calendar")
                }
        }
    }
}
