protocol ValidateStateUseCase {
    func execute(stateShortName: String, availableStates: [StateModel]) -> Bool
}

class ValidateStateUseCaseImpl: ValidateStateUseCase {
    func execute(stateShortName: String, availableStates: [StateModel]) -> Bool {
        return !stateShortName.isEmpty && availableStates.contains(where: { $0.shortName == stateShortName })
    }
}
