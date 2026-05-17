import SwiftUI

extension SQLEditorViewModel {
    static let preview: SQLEditorViewModel = {
        let vm = SQLEditorViewModel(problem: .sampleLesson1)
        return vm
    }()

    static let previewWithResult: SQLEditorViewModel = {
        let vm = SQLEditorViewModel(problem: .sampleLesson1)
        vm.queryText = "SELECT name, price FROM coffees WHERE price < 500"
        vm.queryResult = dummyQueryResult
        return vm
    }()

    static let previewLoading: SQLEditorViewModel = {
        let vm = SQLEditorViewModel(problem: .sampleLesson1)
        vm.isExecuting = true
        return vm
    }()
}
