import SwiftUI

struct WorkView: View {
    @ObservedObject var viewModel: WorkScheduleViewModel
    @State private var selectedDay = "Poniedziałek"
    @State private var currentWeek: Date = Date()
    @State private var selectedPerson: Person?
    @State private var showingAddHours = false

    let daysOfWeek = ["Poniedziałek", "Wtorek", "Środa", "Czwartek", "Piątek", "Sobota", "Niedziela"]

    var body: some View {
        VStack {
            HStack {
                Button(action: { currentWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeek) ?? Date() }) {
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
                Button(action: { currentWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeek) ?? Date() }) {
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
                ForEach(viewModel.persons) { person in
                    if let workHours = viewModel.workHours(for: person, on: viewModel.dateFrom(day: selectedDay, in: currentWeek)) {
                        HStack {
                            Text(person.name)
                                .font(.custom("HelveticaNeue-Bold", size: 16))
                                .foregroundColor(person.name == "Marcin" ? .red : .primary)
                            Spacer()
                            Text(workHours)
                                .font(.custom("HelveticaNeue-Regular", size: 16))
                            Button(action: {
                                selectedPerson = person
                                showingAddHours = true
                            }) {
                                Image(systemName: "plus.circle")
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Grafik Pracy")
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showingAddHours) {
            AddHoursView(viewModel: viewModel, person: $selectedPerson, date: viewModel.dateFrom(day: selectedDay, in: currentWeek))
        }
    }

    struct AddHoursView: View {
        @ObservedObject var viewModel: WorkScheduleViewModel
        @Binding var person: Person?
        let date: Date?
        @State private var startTime = ""
        @State private var endTime = ""
        @Environment(\.presentationMode) var presentationMode

        var body: some View {
            VStack {
                Text("Dodaj godziny pracy")
                    .font(.title)
                    .padding()
                TextField("Początek (HH:mm)", text: $startTime)
                    .padding()
                TextField("Koniec (HH:mm)", text: $endTime)
                    .padding()
                Button(action: {
                    if let person = person, let date = date, let hours = viewModel.calculateWorkHours(from: startTime, to: endTime) {
                        viewModel.setWorkHours("\(startTime)-\(endTime)", for: person, on: date)
                        viewModel.scheduleNotification(for: person, on: date)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Dodaj")
                }
                .padding()
            }
        }
    }
}
