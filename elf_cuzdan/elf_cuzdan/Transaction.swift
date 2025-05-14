import Foundation

struct Transaction {
    let type: String  // "Gelir" veya "Gider"
    let category: String
    let amount: Double
    let date: Date
}
