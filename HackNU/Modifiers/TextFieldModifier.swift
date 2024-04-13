import SwiftUI

struct TextFieldModifier: ViewModifier {
    var textFieldHeight: CGFloat = 45
    var strokeColor: Color = Color(uiColor: .systemGray5)
    func body(content: Content) -> some View {
        content
            .font(Font.custom("", size: GlobalConstants.fontSize))
            .padding()
            .frame(height: textFieldHeight)
            .overlay(RoundedRectangle(
                cornerRadius: GlobalConstants.textFieldCornerRadius
            ).stroke(strokeColor, lineWidth: Constants.textFieldBorderLineWidth))
            .clipShape(RoundedRectangle(cornerRadius: GlobalConstants.textFieldCornerRadius))
    }
}

private struct Constants {
    static let textFieldBorderLineWidth: CGFloat =  3
}
