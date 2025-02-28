import SwiftUI

struct SalaryView: View {
    @ObservedObject var viewModel: WorkScheduleViewModel
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
    let hourlyRate = 30.50
    @State private var differences: [UUID: Double] = [:]

    var body: some View {
        VStack {
            Text("Wypłata")
                .font(.largeTitle)
                .padding()

            Picker("Miesiąc", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(DateFormatter().monthSymbols[month - 1])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            ScrollView {
                VStack {
                    ForEach(viewModel.persons) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Użytkownik: \(user.name)")
                                    .font(.headline)
                                Text("Przepracowane godziny: \(calculateTotalHours(for: user), specifier: "%.2f")")
                                    .font(.subheadline)
                                Text("Wypłata: \(calculateSalary(for: user), specifier: "%.2f") zł")
                                    .font(.title)
                                    .foregroundColor(.green)
                            }
                            TextField("Dyferencja", value: Binding(
                                get: { differences[user.id] ?? 0 },
                                set: { differences[user.id] = $0 }
                            ), formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding()
            }

            Spacer()
        }
        .padding()
    }

    private func calculateTotalHours(for person: Person) -> Double {
        let calendar = Calendar.current
        let components = DateComponents(year: calendar.component(.year, from: Date()), month: selectedMonth)
        guard let firstDayOfMonth = calendar.date(from: components) else { return 0 }

        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        var totalHours: Double = 0

        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth),
               let hoursString = person.workHours[date.dateFormatted()],
               let (startTime, endTime) = parseTimeRange(hoursString),
               let hours = calculateWorkHours(from: startTime, to: endTime) {
                totalHours += hours
            }
        }
        return totalHours
    }

    private func calculateSalary(for person: Person) -> Double {
        let baseSalary = calculateTotalHours(for: person) * hourlyRate
        let difference = differences[person.id] ?? 0
        return baseSalary - difference
    }

    private func parseTimeRange(_ timeRange: String) -> (String, String)? {
        let components = timeRange.components(separatedBy: "-")
        if components.count == 2 {
            return (components[0], components[1])
        }
        return nil
    }

    private func calculateWorkHours(from startTime: String, to endTime: String) -> Double? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        guard let startDate = formatter.date(from: startTime),
              let endDate = formatter.date(from: endTime) else {
            return nil
        }

        let timeInterval = endDate.timeIntervalSince(startDate)
        let hours = timeInterval / 3600.0 // Konwersja sekund na godziny
        return hours
    }
}
