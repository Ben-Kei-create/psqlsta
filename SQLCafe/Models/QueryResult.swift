import Foundation

struct QueryResult: Identifiable {
    let id: UUID = UUID()
    let success: Bool
    let rows: [[String: String]]
    let columns: [String]
    let errorMessage: String?
    let executionTime: Double
}
