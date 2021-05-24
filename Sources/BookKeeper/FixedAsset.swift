import Foundation
/// A `fixed asset` is also known as `Property, Plant, and Equipment`.
///
/// A fixed asset is property with a useful life greater than one reporting period,
/// and which exceeds an entity's minimum capitalization limit. A fixed asset is not purchased
/// with the intent of immediate resale, but rather for productive use within the entity.
/// Also, it is not expected to be fully consumed within one year of its purchase.
/// An inventory item cannot be considered a fixed asset, since it is purchased
/// with the intent of either reselling it directly or incorporating it into a product
/// that is then sold.
///
/// Fixed assets are initially recorded as assets, and are then subject to the following general types of accounting transactions:
///
///     Periodic depreciation (for tangible assets) or amortization (for intangible assets)
///     Impairment write-downs (if the value of an asset declines below its net book value)
///     Disposition (once assets are disposed of)
///
/// A fixed asset appears in the financial records at its net book value, which is its original cost,
/// minus accumulated depreciation, minus any impairment charges. Because of ongoing depreciation,
/// the net book value of an asset is always declining. However, it is possible under international
/// financial reporting standards to revalue a fixed asset, so that its net book value can increase.

public struct FixedAsset: Identifiable, Equatable {
    #warning("change id to type safe id")
    /// # Type-safe identifiers
    ///
    /// Sources:
    /// https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/)
    /// https://www.donnywals.com/creating-type-safe-identifiers-for-your-codable-models/
    /// https://www.pointfree.co/episodes/ep12-tagged
    ///
    /// Best polished solution is https://github.com/pointfreeco/swift-tagged/ wrapped is Swift Package.
    ///
    public let id: UUID
    public var name: String
    public let lifetime: Int
    #warning("""
        should I get category from account group?
        enum BalanceSheet.Asset.PropertyPlantEquipment has a lots of common with enum 'Category'
        """)
    // public let category: BalanceSheet.Asset.PropertyPlantEquipment
    // public let category: Category
    public let value: Double
    public var depreciation: Double = 0


    public init(id: UUID = UUID(),
                name: String,
                lifetime: Int,
                value: Double,
                depreciation: Double = 0
    ) {
        self.id = id
        self.name = name
        self.lifetime = lifetime
        self.value = value
        self.depreciation = depreciation
    }

}

/// The following are examples of general categories of fixed assets:
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
extension FixedAsset {
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
