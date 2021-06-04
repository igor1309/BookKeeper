public extension Books {
    enum BooksError: Error {
        case incorrectOrderType

        case unknownClient
        case unknownSupplier
        case unknownFinishedGood
        case unknownWorkInProgress
        case unknownRawMaterial

        case costOfProductNotDefined
        case incorrectLifetime
        case nonPositiveAmount
        case negativeVAT
        case depreciationFail

        case duplicateName
    }
}
