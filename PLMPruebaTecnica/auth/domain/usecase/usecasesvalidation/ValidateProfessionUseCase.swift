protocol ValidateProfessionUseCase {
    func execute(professionId: Int, availableProfessions: [Profession]) -> Bool
}

class ValidateProfessionUseCaseImpl: ValidateProfessionUseCase {
    func execute(professionId: Int, availableProfessions: [Profession]) -> Bool {
        return professionId != -1 && availableProfessions.contains(where: { $0.id == professionId })
    }
}
