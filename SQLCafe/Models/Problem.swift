import Foundation

struct Problem: Identifiable {
    let id: UUID
    let lessonNumber: Int
    let title: String
    let description: String
    let difficulty: Int       // 1-5
    let correctAnswer: [String]
    let blocks: [String]      // 正解ブロック + ダミーブロック（シャッフル用）
    let hint: String
    let resultTableData: TableData

    // MARK: - All Lessons
    static let allLessons: [Problem] = [
        Problem(
            id: UUID(),
            lessonNumber: 1,
            title: "全データを見せて！",
            description: "coffees テーブルのデータを全部取得するSQL文を作ろう！",
            difficulty: 1,
            correctAnswer: ["SELECT", "*", "FROM", "coffees"],
            blocks: ["SELECT", "*", "FROM", "coffees", "WHERE", "price"],
            hint: "テーブルから全てのカラムを取得するには * を使います",
            resultTableData: TableData(
                headers: ["id", "name", "price"],
                rows: [
                    ["1", "アメリカーノ", "400"],
                    ["2", "カプチーノ", "450"],
                    ["3", "ラテ", "480"],
                    ["4", "エスプレッソ", "350"],
                    ["5", "モカ", "520"]
                ],
                columnCount: 3, rowCount: 5
            )
        ),
        Problem(
            id: UUID(),
            lessonNumber: 2,
            title: "名前と値段だけ教えて！",
            description: "coffees テーブルから name と price だけ取得しよう！",
            difficulty: 1,
            correctAnswer: ["SELECT", "name,", "price", "FROM", "coffees"],
            blocks: ["SELECT", "name,", "price", "FROM", "coffees", "WHERE", "*"],
            hint: "特定のカラムだけ取得するには、カラム名をカンマ区切りで指定します",
            resultTableData: TableData(
                headers: ["name", "price"],
                rows: [
                    ["アメリカーノ", "400"],
                    ["カプチーノ", "450"],
                    ["ラテ", "480"],
                    ["エスプレッソ", "350"],
                    ["モカ", "520"]
                ],
                columnCount: 2, rowCount: 5
            )
        ),
        Problem(
            id: UUID(),
            lessonNumber: 3,
            title: "500円以下のコーヒーは？",
            description: "500円以下のコーヒーの name と price を取得しよう！",
            difficulty: 2,
            correctAnswer: ["SELECT", "name,", "price", "FROM", "coffees", "WHERE", "price", "<", "500"],
            blocks: ["SELECT", "name,", "price", "FROM", "coffees", "WHERE", "price", "<", "500", "ORDER", "*"],
            hint: "WHERE 句で条件を指定してフィルタリングできます",
            resultTableData: TableData(
                headers: ["name", "price"],
                rows: [
                    ["アメリカーノ", "400"],
                    ["カプチーノ", "450"],
                    ["ラテ", "480"],
                    ["エスプレッソ", "350"]
                ],
                columnCount: 2, rowCount: 4
            )
        ),
        Problem(
            id: UUID(),
            lessonNumber: 4,
            title: "安い順に並べて！",
            description: "coffees テーブルのデータを price が安い順に並べよう！",
            difficulty: 2,
            correctAnswer: ["SELECT", "*", "FROM", "coffees", "ORDER", "BY", "price", "ASC"],
            blocks: ["SELECT", "*", "FROM", "coffees", "ORDER", "BY", "price", "ASC", "DESC", "WHERE"],
            hint: "ORDER BY を使うと並び替えができます。昇順は ASC です",
            resultTableData: TableData(
                headers: ["id", "name", "price"],
                rows: [
                    ["4", "エスプレッソ", "350"],
                    ["1", "アメリカーノ", "400"],
                    ["2", "カプチーノ", "450"],
                    ["3", "ラテ", "480"],
                    ["5", "モカ", "520"]
                ],
                columnCount: 3, rowCount: 5
            )
        ),
        Problem(
            id: UUID(),
            lessonNumber: 5,
            title: "上位3件だけ見せて！",
            description: "coffees テーブルのデータを3件だけ取得しよう！",
            difficulty: 2,
            correctAnswer: ["SELECT", "*", "FROM", "coffees", "LIMIT", "3"],
            blocks: ["SELECT", "*", "FROM", "coffees", "LIMIT", "3", "WHERE", "ORDER"],
            hint: "LIMIT を使うと取得件数を制限できます",
            resultTableData: TableData(
                headers: ["id", "name", "price"],
                rows: [
                    ["1", "アメリカーノ", "400"],
                    ["2", "カプチーノ", "450"],
                    ["3", "ラテ", "480"]
                ],
                columnCount: 3, rowCount: 3
            )
        )
    ]

    // MARK: - Legacy Support
    static let sampleLesson1 = Problem.allLessons[0]
}
