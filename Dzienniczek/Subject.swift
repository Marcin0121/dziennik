import Foundation

struct Subject: Identifiable, Codable {
    var id = UUID()
    var name: String
}

extension Array where Element == Subject {
    static func odczytajZPliku(nazwaPliku: String) -> [Subject]? {
        let dokumentyURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let plikURL = dokumentyURL.appendingPathComponent(nazwaPliku)

        if !FileManager.default.fileExists(atPath: plikURL.path) {
            let emptyArray: [Subject] = []
            emptyArray.zapiszDoPliku(nazwaPliku: nazwaPliku)
            return []
        }

        do {
            let dane = try Data(contentsOf: plikURL)
            let lista = try JSONDecoder().decode([Subject].self, from: dane)
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
