import Foundation

extension Date {
    var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        components.weekday = calendar.firstWeekday // Ustawia pierwszy dzień tygodnia na podstawie ustawień kalendarza
        return calendar.date(from: components)!
    }

    func dayOfWeekShort() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pl_PL")
        formatter.dateFormat = "EEE"
        return formatter.string(from: self)
    }

    func dateFormatted() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pl_PL")
        formatter.dateFormat = "dd.MM"
        return formatter.string(from: self)
    }

    func weekRange() -> String {
        let startOfWeek = self.startOfWeek
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
        return "\(startOfWeek.dateFormatted()) - \(endOfWeek.dateFormatted())"
    }
}
