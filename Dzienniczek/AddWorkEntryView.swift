import SwiftUI

struct AddWorkEntryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkScheduleViewModel
    @State private var name = ""
    var selectedDate: Date

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Szczegóły wpisu")) {
                    TextField("Imię", text: $name)
                }
                Button(action: {
                    viewModel.addPerson(name: name)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Dodaj wpis")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Dodaj wpis")
            .navigationBarItems(trailing: Button("Zamknij") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
