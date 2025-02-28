import SwiftUI

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkScheduleViewModel
    @State private var name = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Szczegóły osoby")) {
                    TextField("Imię", text: $name)
                }
                Button(action: {
                    viewModel.addPerson(name: name)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Dodaj osobę")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Dodaj osobę")
            .navigationBarItems(trailing: Button("Zamknij") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
