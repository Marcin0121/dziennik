import Foundation

struct Entry: Identifiable, Codable {
    var id = UUID()
    var subject: String
    var date: Date
    var note: String
}

extension Array where Element == Entry {
    static func odczytajZPliku(nazwaPliku: String) -> [Entry]? {
        let dokumentyURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let plikURL = dokumentyURL.appendingPathComponent(nazwaPliku)

        if !FileManager.default.fileExists(atPath: plikURL.path) {
            let emptyArray: [Entry] = []
            emptyArray.zapiszDoPliku(nazwaPliku: nazwaPliku)
            return []
        }

        do {
            let dane = try Data(contentsOf: plikURL)
            let lista = try JSONDecoder().decode([Entry].self, from: dane)
            print("Dane odczytane z pliku: \(nazwaPliku)")
            return lista
        } catch {
            print("Błąd odczytu danych: \(error)")
            return nil
        }
    }
    func zapiszDoPliku(nazwaPliku: String) {
        let dokumentyURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let plikURL = dokumentyURL.appendingPathComponent(nazwaPliku)

        do {
            let dane = try JSONEncoder().encode(self)
            try dane.write(to: plikURL)
            print("Dane zapisane do pliku: \(nazwaPliku)")
        } catch {
            print("Błąd zapisu danych: \(error)")
        }
    }
}
