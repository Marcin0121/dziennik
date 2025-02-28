import SwiftUI

struct ContentView: View {
    @StateObject private var examViewModel = ExamListViewModel()
    @StateObject private var scheduleViewModel = ScheduleViewModel()
    @StateObject private var workScheduleViewModel = WorkScheduleViewModel()
    @State private var selectedTab: Tab?

    enum Tab {
        case school
        case work
        case persons
        case salary
    }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination: SchoolTabView(examViewModel: examViewModel, scheduleViewModel: scheduleViewModel), tag: .school, selection: $selectedTab) {
                    Button(action: { selectedTab = .school }) {
                        HStack {
                            Image(systemName: "book.closed")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            Text("Szkoła")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .padding()
                    }
                }
                NavigationLink(destination: WorkView(viewModel: workScheduleViewModel), tag: .work, selection: $selectedTab) {
                    Button(action: { selectedTab = .work }) {
                        HStack {
                            Image(systemName: "briefcase")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            Text("Praca")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.mint]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .padding()
                    }
                }
                NavigationLink(destination: PersonsListView(viewModel: workScheduleViewModel), tag: .persons, selection: $selectedTab) {
                    Button(action: { selectedTab = .persons }) {
                        HStack {
                            Image(systemName: "person.3")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            Text("Spis Osób")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .padding()
                    }
                }
                NavigationLink(destination: SalaryView(viewModel: workScheduleViewModel), tag: .salary, selection: $selectedTab) {
                    Button(action: { selectedTab = .salary }) {
                        HStack {
                            Image(systemName: "dollarsign.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                            Text("Wypłata")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.pink]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 10, x: 0, y: 5)
                        .padding()
                    }
                }
                Spacer()
            }
            .navigationTitle("Wybierz tryb")
            .background(LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom))
            .edgesIgnoringSafeArea(.all)
        }
    }
}
