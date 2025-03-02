import SwiftUI

struct ContentView: View {
    @StateObject var scheduleViewModel = ScheduleViewModel()
    @StateObject var examViewModel = ExamViewModel()
    @StateObject private var workScheduleViewModel = WorkScheduleViewModel()
    @State private var selectedTab: Tab?
    

    enum Tab {
        case school, work, persons, salary
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                SchoolTabView(scheduleViewModel: scheduleViewModel, examViewModel: examViewModel) // Dodaj examViewModel
                    .navigationTitle("Szkoła")
            }
            .tabItem { Label("Szkoła", systemImage: "book.closed") }
            .tag(Tab.school)

            NavigationView {
                WorkView(viewModel: workScheduleViewModel)
                    .navigationTitle("Praca")
            }
            .tabItem { Label("Praca", systemImage: "briefcase") }
            .tag(Tab.work)

            NavigationView {
                PersonsListView(viewModel: workScheduleViewModel)
                    .navigationTitle("Spis Osób")
            }
            .tabItem { Label("Osoby", systemImage: "person.3") }
            .tag(Tab.persons)

            NavigationView {
                SalaryView(viewModel: workScheduleViewModel)
                    .navigationTitle("Wypłata")
            }
            .tabItem { Label("Wypłata", systemImage: "dollarsign.circle") }
            .tag(Tab.salary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
