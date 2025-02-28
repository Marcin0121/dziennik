import Foundation

struct Lesson: Identifiable, Codable {
    let id = UUID()
    var subject: String
    var hour: String
    var day: String
    var lessonNumber: Int // Dodano numer lekcji
}
