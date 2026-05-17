import SwiftUI

struct NavigationBarView: View {
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.accentGold)
            }

            Spacer()

            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.headerBrown)
                .lineLimit(1)

            Spacer()

            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.accentGold)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.appBackground)
        .border(Color.accentGold.opacity(0.2), width: 1)
    }
}

#Preview {
    NavigationBarView(title: "Lesson 1: メニューの把握")
}
