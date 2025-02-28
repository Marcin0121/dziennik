import Foundation

struct Exam: Identifiable, Codable {
    var id = UUID()
    var subject: String
    var date: Date
    var description: String
    var type: ExamType
    var zakresMaterialu: String? // Nowe pole
    var typSprawdzianu: String? // Nowe pole
    var ocena: Double? // Nowe pole
    var zaliczone: Bool = false // Nowe pole
}
