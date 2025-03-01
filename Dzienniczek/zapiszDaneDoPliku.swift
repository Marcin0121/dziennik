import Foundation

// Dodaj funkcje do kodowania i dekodowania danych
extension Array where Element == Entry {
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

    static func odczytajZPliku(nazwaPliku: String) -> [Entry]? {
        let dokumentyURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let plikURL = dokumentyURL.appendingPathComponent(nazwaPliku)

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
    print("Dane zapisane do pliku: \(nazwaPliku)")
}

extension Array where Element == Subject {
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

    static func odczytajZPliku(nazwaPliku: String) -> [Entry]? {
        let dokumentyURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let plikURL = dokumentyURL.appendingPathComponent(nazwaPliku)

        if !FileManager.default.fileExists(atPath: plikURL.path) {
            // Plik nie istnieje, stwórz pusty plik
            let emptyArray: [Entry] = []
            emptyArray.zapiszDoPliku(nazwaPliku: nazwaPliku)
            return [] // Zwróć pustą tablicę
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
}
