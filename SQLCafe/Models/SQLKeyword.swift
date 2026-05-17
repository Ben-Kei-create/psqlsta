import Foundation

struct SQLKeyword: Identifiable {
    let id: UUID = UUID()
    let text: String
    let category: String  // "clause", "operator", "function"
}
