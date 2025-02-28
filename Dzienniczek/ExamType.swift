enum ExamType: String, CaseIterable, Codable, Identifiable {
    case sprawdzian = "Sprawdzian"
    case kartkowka = "Kartkówka"
    case odpowiedz = "Odpowiedź"
    case quiz = "Quiz"
    case mockExam = "Próbny Egzamin"
    case oralExam = "Egzamin Ustny"
    case test = "Test"

    var id: String { self.rawValue }
}
