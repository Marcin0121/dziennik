import SwiftUI

struct PersonDetailView: View {
    @ObservedObject var person: Person
    @ObservedObject var viewModel: WorkScheduleViewModel
    var isEditing: Bool
    @State private var selectedDay = "Poniedziałek"
    @State private var currentWeek: Date = Date()
    let daysOfWeek = ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela"]
    @State private var startTime = ""
    @State private var endTime = ""

    var body: some View {
        VStack {
            HStack {
                Button(action: { currentWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeek)! }) {
                    Image(systemName: "arrow.left")
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .clipShape(Circle())
                }
                Spacer()
                Text("Tydzień \(viewModel.weekRange(for: currentWeek))")
                    .font(.custom("HelveticaNeue-Bold", size: 18))
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                Spacer()
                Button(action: { currentWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeek)! }) {
                    Image(systemName: "arrow.right")
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding()
            Picker("Wybierz dzień", selection: $selectedDay) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.custom("HelveticaNeue-Medium", size: 16))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            List {
                let date = viewModel.dateFrom(day: selectedDay, in: currentWeek)
                VStack(alignment: .leading) {
                    Text(viewModel.dayOfWeekShort(date) + " " + viewModel.dateFormatted(date))
                        .font(.custom("HelveticaNeue-Bold", size: 18))
                    if isEditing {
                        VStack {
                            TextField("Początek (HH:mm)", text: $startTime)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Koniec (HH:mm)", text: $endTime)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                viewModel.setWorkHours("\(startTime)-\(endTime)", for: person, on: date)
                            }) {
                                Text("Zapisz")
                            }
                        }
                    } else {
                        Text(viewModel.workHours(for: person, on: date) ?? "")
                            .font(.custom("HelveticaNeue-Regular", size: 16))
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle(person.name)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarItems(trailing: Button("Zamknij") {
            viewModel.savePersons()
        })
    }
}
