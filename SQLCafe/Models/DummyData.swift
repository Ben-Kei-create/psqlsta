import Foundation

// MARK: - Dummy Problems
let dummyProblem1 = Problem(
    title: "Lesson 1: メニューの把握",
    description: "500円以下のコーヒーの name と price を教えて！",
    difficulty: 1
)

// MARK: - Dummy Query Results
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

let dummyTableData = TableData(
    headers: ["name", "price"],
    rows: [
        ["アメリカーノ", "400"],
        ["カプチーノ", "450"],
        ["ラテ", "480"]
    ],
    columnCount: 2,
    rowCount: 3
)
