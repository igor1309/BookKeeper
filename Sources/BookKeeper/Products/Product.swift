import Foundation
import Tagged

protocol Product: Hashable, Identifiable {
    var id: Tagged<Self, UUID> { get }
    var inventory: InventoryAccount { get set }
}
