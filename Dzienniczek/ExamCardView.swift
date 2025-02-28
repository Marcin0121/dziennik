import SwiftUI

struct ExamCardView: View {
    let exam: Exam

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(exam.subject)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(exam.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            Text(exam.description)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
            HStack {
                Text(exam.type.rawValue)
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(exam.typeColor)
                    .clipShape(Capsule())
                Spacer()
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

extension Exam {
    var typeColor: Color {
        switch type {
        case .test:
            return Color.red
        case .quiz:
            return Color.blue
        case .mockExam:
            return Color.purple
        case .oralExam:
            return Color.green
        case .sprawdzian:
            return Color.cyan
        case .kartkowka:
            return Color.indigo
        case .odpowiedz:
            return Color.orange

        }
    }
}
