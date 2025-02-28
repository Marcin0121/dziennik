import SwiftUI

struct PersonsListView: View {
    @ObservedObject var viewModel: WorkScheduleViewModel
    @State private var showingAddPerson = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.persons) { person in
                        NavigationLink(destination: PersonDetailView(person: person, viewModel: viewModel, isEditing: true)) {
                            Text(person.name)
                                .font(.custom("HelveticaNeue-Bold", size: 16))
                                .foregroundColor(person.name == "Marcin" ? .red : .primary)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.removePerson(at: indexSet)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Spis Osób")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPerson.toggle()
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(viewModel: viewModel)
            }
        }
    }
}
