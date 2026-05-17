import SwiftUI

struct SQLQueryEditorView: View {
    @Binding var queryText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SQLクエリ")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.headerBrown)

            TextEditor(text: $queryText)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.editorText)
                .background(Color.editorBackground)
                .cornerRadius(4)
                .frame(minHeight: 150)
                .scrollContentBackground(.hidden)
        }
        .padding(12)
        .background(Color.appBackground)
        .border(Color.borderColor, width: 1)
        .cornerRadius(4)
    }
}

#Preview {
    @State var queryText = "SELECT * FROM coffees WHERE price < 500"
    return SQLQueryEditorView(queryText: $queryText)
        .padding()
}
