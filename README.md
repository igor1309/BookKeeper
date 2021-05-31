# BookKeeper

A description of this package.

* [Account](#account)
    * [Generic Account](#generic-account)
    * [Inventory Account](#inventory-account)
* [Order](#order)
    * [Inventory Order](#inventory-order)
    * [Production Order](#production-order)
    * [Purchase Order](#purchase-order)
    * [Sales Order](#sales-order)
* [Client](#client)
* [Supplier](#supplier)
* [Fixed Asset](#fixed-asset)
* [Product](#product)
    * [Raw Material](#raw-material)
    * [Work in Progress](#work-in-progress)
    * [Finished Good](#finished-good)
* [Books](#books)
    * Business Operations: Book Revenue, Depreciate Fixed Asset, Purchase Raw Material, Receive Cash, Record Finished Goods


## Account
`AccountProtocol` defines basic properties for account, such as `kind` (active/passive/both), `group` (balance sheet/income statement; asset/liability, etc - as defined in `AccountGroup` enum) and account `balance`.

### The `Account` type

The `Account` type describes **generic** account for tracking monetary value, conforms to `AccountProtocol`.

```swift
struct Account<AccountType: AccountTypeProtocol>
```

`AccountTypeProtocol` demands static properties for kind and group.
A bunch of types, conforming to AccountTypeProtocol, are defined as case-less enums with static properties `kind` and `group`, for example `AccountsReceivable`, `Cash`, `COGS`, `Revenue`, etc.

### The `Inventory Account` type

## Order

Types conforming to `OrderProtocol`:

* Inventory Order
* Production Order
* Purchase Order
* Sales Order

## Client

## Supplier

## Fixed Asset

## Product

* Raw Material
* Work in Progress
* Finished Good

## Books

* Business Operations: Book Revenue, Depreciate Fixed Asset, Purchase Raw Material, Receive Cash, Record Finished Goods


## Techniques used

### - Phantom types and type-safe identifiers

Phantom types are used in `struct Account<AccountType>` and type safe identifiers `TBD` to provide type safety.

* [How to use phantom types in Swift – Hacking with Swift+](https://www.hackingwithswift.com/plus/advanced-swift/how-to-use-phantom-types-in-swift)  
* [Phantom types in Swift | Swift by Sundell](https://www.swiftbysundell.com/articles/phantom-types-in-swift/)  
* [Phantom types in Swift | Swift with Majid](https://swiftwithmajid.com/2021/02/18/phantom-types-in-swift/)  
* [Type-Safe File Paths with Phantom Types - Swift Talk - objc.io](https://talk.objc.io/episodes/S01E71-type-safe-file-paths-with-phantom-types)  

Type-safe identifiers - sources:  
* [Point-Free Episode #12: Tagged](https://www.pointfree.co/episodes/ep12-tagged)  
* [Type-safe identifiers in Swift | Swift by Sundell](https://www.swiftbysundell.com/articles/type-safe-identifiers-in-swift/)  
* [Creating type-safe identifiers for your Codable models – Donny Wals](https://www.donnywals.com/creating-type-safe-identifiers-for-your-codable-models/)

Best polished solution is [pointfreeco/swift-tagged: 🏷 A wrapper type for safer, expressive code.](https://github.com/pointfreeco/swift-tagged/) wrapped is Swift Package.
