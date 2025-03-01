import SwiftUI

struct SchoolTabView: View {
    @ObservedObject var scheduleViewModel: ScheduleViewModel
    @ObservedObject var examViewModel: ExamViewModel

    init(scheduleViewModel: ScheduleViewModel, examViewModel: ExamViewModel) {
        self.scheduleViewModel = scheduleViewModel
        self.examViewModel = examViewModel
    }

    var body: some View {
        TabView {
            ScheduleView(viewModel: scheduleViewModel) 
                .tabItem {
                    Label("Plan", systemImage: "calendar")
                }

            ExamListView(examViewModel: examViewModel)
                .tabItem {
                    Label("Egzaminy", systemImage: "doc.text.magnifyingglass")
                }
        }
    }
}
