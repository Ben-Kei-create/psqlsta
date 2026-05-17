import SwiftUI

struct NavigationBarView: View {
    let title: String

    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.headerBrown)
            }

            Spacer()

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.headerBrown)

            Spacer()

            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.headerBrown)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.appBackground)
        .border(Color.borderColor, width: 1)
    }
}

#Preview {
    NavigationBarView(title: "Lesson 1: メニューの把握")
}
