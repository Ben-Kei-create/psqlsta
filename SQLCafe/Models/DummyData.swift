import Foundation

// MARK: - Dummy Query Results (for legacy support)
let dummyQueryResult = QueryResult(
    success: true,
    rows: [
        ["name": "アメリカーノ", "price": "400"],
        ["name": "カプチーノ", "price": "450"],
        ["name": "ラテ", "price": "480"]
    ],
    columns: ["name", "price"],
    errorMessage: nil,
    executionTime: 0.045
)
