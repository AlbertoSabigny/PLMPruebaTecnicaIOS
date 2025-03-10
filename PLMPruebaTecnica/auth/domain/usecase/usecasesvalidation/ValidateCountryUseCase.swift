protocol ValidateCountryUseCase {
    func execute(countryId: Int, availableCountries: [Country]) -> Bool
}

class ValidateCountryUseCaseImpl: ValidateCountryUseCase {
    func execute(countryId: Int, availableCountries: [Country]) -> Bool {
        return countryId != -1 && availableCountries.contains(where: { $0.id == countryId })
    }
}
