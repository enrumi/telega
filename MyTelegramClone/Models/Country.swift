import Foundation
struct Country {
    let code: String        // +7
    let countryCode: String // RU
    let mask: String        // XXX XXX XXXX
    let name: String        // Russia
    var displayName: String {
        return "\(name) (+\(code))"
    }
}
class CountryManager {
    static let shared = CountryManager()
    private(set) var countries: [Country] = []
    private init() {
        loadCountries()
    }
    private func loadCountries() {
        guard let path = Bundle.main.path(forResource: "PhoneCountries", ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            countries = getDefaultCountries()
            return
        }
        let lines = content.components(separatedBy: .newlines)
        countries = lines.compactMap { line in
            let parts = line.components(separatedBy: ";")
            guard parts.count >= 4 else { return nil }
            return Country(
                code: parts[0],
                countryCode: parts[1],
                mask: parts[2],
                name: parts[3]
            )
        }
        if countries.isEmpty {
            countries = getDefaultCountries()
        }
    }
    private func getDefaultCountries() -> [Country] {
        return [
            Country(code: "7", countryCode: "RU", mask: "XXX XXX XXXX", name: "Russia"),
            Country(code: "1", countryCode: "US", mask: "XXX XXX XXXX", name: "United States"),
            Country(code: "44", countryCode: "GB", mask: "XXXX XXXXXX", name: "United Kingdom"),
            Country(code: "49", countryCode: "DE", mask: "XXX XXXXXXXX", name: "Germany"),
            Country(code: "33", countryCode: "FR", mask: "X XX XX XX XX", name: "France"),
            Country(code: "39", countryCode: "IT", mask: "XXX XXX XXXX", name: "Italy"),
            Country(code: "34", countryCode: "ES", mask: "XXX XXX XXX", name: "Spain"),
            Country(code: "380", countryCode: "UA", mask: "XX XXX XXXX", name: "Ukraine"),
            Country(code: "375", countryCode: "BY", mask: "XX XXX XXXX", name: "Belarus"),
            Country(code: "77", countryCode: "KZ", mask: "XXX XXX XXXX", name: "Kazakhstan"),
            Country(code: "998", countryCode: "UZ", mask: "XX XXX XXXX", name: "Uzbekistan"),
            Country(code: "86", countryCode: "CN", mask: "XXX XXXX XXXX", name: "China"),
            Country(code: "81", countryCode: "JP", mask: "XX XXXX XXXX", name: "Japan"),
            Country(code: "82", countryCode: "KR", mask: "XX XXXX XXXX", name: "South Korea"),
            Country(code: "91", countryCode: "IN", mask: "XXXXX XXXXX", name: "India"),
            Country(code: "90", countryCode: "TR", mask: "XXX XXX XXXX", name: "Turkey"),
            Country(code: "48", countryCode: "PL", mask: "XX XXX XXXX", name: "Poland"),
            Country(code: "420", countryCode: "CZ", mask: "XXX XXX XXX", name: "Czech Republic"),
        ]
    }
    func findCountry(byCode code: String) -> Country? {
        let sortedCountries = countries.sorted { $0.code.count > $1.code.count }
        return sortedCountries.first { code.hasPrefix($0.code) }
    }
    func searchCountries(query: String) -> [Country] {
        guard !query.isEmpty else { return countries }
        let lowercaseQuery = query.lowercased()
        return countries.filter {
            $0.name.lowercased().contains(lowercaseQuery) ||
            $0.code.contains(query) ||
            $0.countryCode.lowercased().contains(lowercaseQuery)
        }
    }
}
