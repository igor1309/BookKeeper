import SwiftUI

/// Core structure to run book keeping.
public struct Books: Equatable {
    // MARK: Inventory
    public var rawMaterials: [RawMaterial.ID: RawMaterial]
    public var wips: [WorkInProgress.ID: WorkInProgress]
    public var finishedGoods: [FinishedGood.ID: FinishedGood]

    // MARK: World
    public var clients: [Client.ID: Client]
    public var suppliers: [Supplier.ID: Supplier]

    // MARK: Fixed Assets
    // also land, buildings, and vehicles
    public var equipments: [Equipment.ID: Equipment]

    // MARK: General Ledger
    public var ledger: [AccountGroup: Account]

    /// InItialise Books with `variadic parameters` for raw materials, work in progress, finished goods, clients, suppliers, equipment and ledger
    public init(rawMaterials: RawMaterial...,
                wips: WorkInProgress...,
                finishedGoods: FinishedGood...,
                clients: Client...,
                suppliers: Supplier...,
                equipments: Equipment...,
                ledger: [Account] = []
    ) {
        self.init(rawMaterials: rawMaterials.keyedBy(keyPath: \.id),
                  wips: wips.keyedBy(keyPath: \.id),
                  finishedGoods: finishedGoods.keyedBy(keyPath: \.id),
                  clients: clients.keyedBy(keyPath: \.id),
                  suppliers: suppliers.keyedBy(keyPath: \.id),
                  equipments: equipments.keyedBy(keyPath: \.id),
                  ledger: ledger.keyedBy(keyPath: \.group))
    }

    /// InItialise Books with `arrays` for raw materials, work in progress, finished goods, clients, suppliers, equipment and ledger
    public init(rawMaterials: [RawMaterial] = [],
                wips: [WorkInProgress] = [],
                finishedGoods: [FinishedGood] = [],
                clients: [Client] = [],
                suppliers: [Supplier] = [],
                equipments: [Equipment] = [],
                ledger: [Account] = []
    ) {
        self.init(rawMaterials: rawMaterials.keyedBy(keyPath: \.id),
                  wips: wips.keyedBy(keyPath: \.id),
                  finishedGoods: finishedGoods.keyedBy(keyPath: \.id),
                  clients: clients.keyedBy(keyPath: \.id),
                  suppliers: suppliers.keyedBy(keyPath: \.id),
                  equipments: equipments.keyedBy(keyPath: \.id),
                  ledger: ledger.keyedBy(keyPath: \.group))
    }

    #warning("think about making it failable or throwing if it does not balance")
    /// InItialise Books with `dictionaries` for raw materials, work in progress, finished goods, clients, suppliers, equipment and ledger
    internal init(rawMaterials: [RawMaterial.ID: RawMaterial] = [:],
                  wips: [WorkInProgress.ID: WorkInProgress] = [:],
                  finishedGoods: [FinishedGood.ID: FinishedGood] = [:],
                  clients: [Client.ID: Client] = [:],
                  suppliers: [Supplier.ID: Supplier] = [:],
                  equipments: [Equipment.ID: Equipment] = [:],
                  ledger: [AccountGroup: Account] = [:]
    ) {
        self.rawMaterials = rawMaterials
        self.wips = wips
        self.finishedGoods = finishedGoods
        self.clients = clients
        self.suppliers = suppliers
        self.equipments = equipments
        self.ledger = ledger

        // even if it would overwrite data provided by init parameters, update ledger

        // MARK: update ledger with inventory data for raw materials

        if rawMaterials.isEmpty {
            self.ledger[.rawInventory] = nil
        } else {
            let inventoryBalance = rawMaterials.totalBalance(for: \.inventory)
            self.ledger[.rawInventory] = .init(group: .rawInventory, amount: inventoryBalance)
        }

        // MARK: update ledger with inventory data for work in progress

        if wips.isEmpty {
            self.ledger[.wipsInventory] = nil
        } else {
            let inventoryBalance = wips.totalBalance(for: \.inventory)
            self.ledger[.wipsInventory] = .init(group: .wipsInventory, amount: inventoryBalance)
        }

        // MARK: update ledger with inventory data for finished goods

        if finishedGoods.isEmpty {
            self.ledger[.cogs] = nil
            self.ledger[.finishedInventory] = nil
        } else {
            let cogsBalance = finishedGoods.totalBalance(for: \.cogs)
            self.ledger[.cogs] = .init(group: .cogs, amount: cogsBalance)

            let inventoryBalance = finishedGoods.totalBalance(for: \.inventory)
            self.ledger[.finishedInventory] = .init(group: .finishedInventory, amount: inventoryBalance)
        }

        // MARK: update ledger with data for clients

        if clients.isEmpty {
            self.ledger[.receivables] = nil
        } else {
            let receivables = clients.totalBalance(for: \.receivables)
            self.ledger[.receivables] = .init(group: .receivables, amount: receivables)
        }

        // MARK: update ledger with data for suppliers

        if suppliers.isEmpty {
            self.ledger[.payables] = nil
        } else {
            let payables = suppliers.totalBalance(for: \.payables)
            self.ledger[.payables] = .init(group: .payables, amount: payables)
        }

        // MARK: update ledger with data for equipment

        if equipments.isEmpty {
            self.ledger[.equipment] = nil
            self.ledger[.accumulatedDepreciation] = nil
            self.ledger[.depreciationExpenses] = nil
        } else {
            let initialValue = equipments.sum(for: \.initialValue)
            self.ledger[.equipment] = .init(group: .equipment, amount: initialValue)

            let depreciation = equipments.sum(for: \.depreciation)
            self.ledger[.accumulatedDepreciation] = .init(group: .accumulatedDepreciation, amount: depreciation)
            self.ledger[.depreciationExpenses] = .init(group: .depreciationExpenses, amount: depreciation)
        }

    }

}

public extension Books {
    var isEmpty: Bool {
        rawMaterials.isEmpty
            && wips.isEmpty
            && finishedGoods.isEmpty
            && clients.isEmpty
            && suppliers.isEmpty
            && equipments.isEmpty
            && ledger.values.allSatisfy { $0.balance == 0 }
    }

}

extension Books: CustomStringConvertible {
    #warning("finish with this")
    public var description: String {
        let finished = finishedGoods.values.map { "\n\t\($0)" }.joined()
        let clientsStr = clients.values.map { "\n\t\($0)" }.joined()

        return """
        Finished Goods:\(finished)
        Clients:\(clientsStr)
        Revenue: ...
        Tax Liabilities: ...
        """
    }
}
