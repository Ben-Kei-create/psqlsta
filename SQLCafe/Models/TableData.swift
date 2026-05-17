import Foundation

struct TableData: Identifiable {
    let id: UUID = UUID()
    let headers: [String]
    let rows: [[String]]
    let columnCount: Int
    let rowCount: Int
}
