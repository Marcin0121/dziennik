import Foundation

struct Exam: Identifiable, Codable {
    let id = UUID()
    var subject: String
    var date: Date
    var description: String
    var type: ExamType
}
