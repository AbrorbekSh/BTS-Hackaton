import SwiftUI

public struct ButtonModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .font(Font.custom("", size: GlobalConstants.fontSize))
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.black)
            .background(ColorScheme.lemonYellow)
            .contentShape(Rectangle())
            .overlay(RoundedRectangle(
                cornerRadius: GlobalConstants.buttonCornerRadius)
                .stroke(Color(uiColor: .systemBackground))
            )
            .clipShape(RoundedRectangle(cornerRadius: GlobalConstants.buttonCornerRadius))
    }
}
