import Foundation

class Person: Identifiable, ObservableObject, Codable {
    var id = UUID()
    var name: String
    @Published var workHours: [String: String]

    init(name: String) {
        self.name = name
        self.workHours = [:]
    }

    enum CodingKeys: CodingKey {
        case id, name, workHours
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        workHours = try container.decode([String: String].self, forKey: .workHours)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(workHours, forKey: .workHours)
    }
}
