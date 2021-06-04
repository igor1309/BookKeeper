import Foundation
import Tagged

/// A `equipment` is also known as `Property, Plant, and Equipment`.
///
/// A equipment is property with a useful life greater than one reporting period,
/// and which exceeds an entity's minimum capitalization limit. A equipment is not purchased
/// with the intent of immediate resale, but rather for productive use within the entity.
/// Also, it is not expected to be fully consumed within one year of its purchase.
/// An inventory item cannot be considered a equipment, since it is purchased
/// with the intent of either reselling it directly or incorporating it into a product
/// that is then sold.
///
/// Fixed assets are initially recorded as assets, and are then subject to the following
/// general types of accounting transactions:
///
///     Periodic depreciation (for tangible assets) or amortization (for intangible assets)
///     Impairment write-downs (if the value of an asset declines below its net book value)
///     Disposition (once assets are disposed of)
///
/// A equipment appears in the financial records at its net book value, which is its original cost,
/// minus accumulated depreciation, minus any impairment charges. Because of ongoing depreciation,
/// the net book value of an asset is always declining. However, it is possible under international
/// financial reporting standards to revalue a equipment, so that its net book value can increase.
#warning("rename to Equipment")
public struct Equipment: Identifiable, Equatable {
    public let id: Tagged<Self, UUID>
    public var name: String
    public let lifetime: Int

    // MARK: should I get category from account group?
    // enum BalanceSheet.Asset.PropertyPlantEquipment has a lots of common with enum 'Category'
    // public let category: BalanceSheet.Asset.PropertyPlantEquipment
    // public let category: Category

    public let initialValue: Double
    public let vatRate: Double

    #warning("make depreciation private")
    public var depreciation: Double = 0
    public var carryingAmount: Double { initialValue - depreciation }

    // MARK: depreciationAmountPerMonth could be a method with potentially different depreciation strategies
    /// https://saldovka.com/provodki/os/amortizatsiya-osnovnyih-sredstv.html
    public var depreciationAmountPerMonth: Double { initialValue / Double(lifetime) / 12 }

    public init(id: UUID = UUID(),
                name: String,
                lifetime: Int,
                value: Double,
                vatRate: Double = 20/100,
                depreciation: Double = 0
    ) {
        self.id = Tagged<Self, UUID>(rawValue: id)
        self.name = name
        self.lifetime = lifetime
        self.initialValue = value
        self.vatRate = vatRate
        self.depreciation = depreciation
    }

    mutating func depreciate() throws {
        guard depreciationAmountPerMonth <= carryingAmount else {
            throw Books.BooksError.depreciationFail
        }

        depreciation += depreciationAmountPerMonth
    }

}

/// The following are examples of general categories of equipment:
///
///     Buildings
///     Computer equipment
///     Computer software
///     Furniture and fixtures
///     Intangible assets
///     Land
///     Leasehold improvements
///     Machinery
///     Vehicles
///
extension Equipment {
    public enum Category {
        case buildings
        case computerEquipment
        case computerSoftware
        case furnitureFixtures
        case intangibleAssets
        case land
        case leaseholdImprovements
        case machinery
        case vehicles
    }

}
