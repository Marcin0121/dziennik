import Foundation

struct Lesson: Identifiable, Codable, Equatable {
    var id = UUID()
    var subject: String
    var hour: String
    var day: String
    var lessonNumber: Int
    var room: String // Dodano pole sala
}
