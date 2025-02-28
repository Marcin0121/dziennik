import SwiftUI

enum ExamType: String, Codable, CaseIterable {
    case test = "Sprawdzian"
    case quiz = "Kartkówka"
    case mockExam = "Matura próbna"
    case oralExam = "Odpowiedź ustna"

    var color: Color {
        switch self {
        case .test:
            return .red
        case .quiz:
            return .blue
        case .mockExam:
            return .purple
        case .oralExam:
            return .green
        }
    }
}
