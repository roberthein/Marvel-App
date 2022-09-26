import Foundation
import UIKit

class TitleLabel: UILabel {

    private let strokeColor: UIColor
    private let strokeWidth: CGFloat

    // MARK: Initialization

    init(strokeColor: UIColor, strokeWidth: CGFloat) {
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth

        super.init(frame: .zero)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Overrides

    override func drawText(in rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineJoin(.round)
        context.setLineWidth(strokeWidth * 2)
        context.setTextDrawingMode(.fillStroke)

        let baseTextColor = textColor
        textColor = strokeColor

        let substraction = frameWithoutStroke(rect)
        super.drawText(in: substraction)

        context.setTextDrawingMode(.fill)
        textColor = baseTextColor
        super.drawText(in: substraction)
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        super.textRect(
            forBounds: CGRect(
                origin: bounds.origin,
                size: sizeWithoutStroke(bounds.size)
            ),
            limitedToNumberOfLines: numberOfLines
        )
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        sizeWithStroke(super.sizeThatFits(size))
    }

    override var intrinsicContentSize: CGSize {
        sizeWithStroke(super.intrinsicContentSize)
    }

    // MARK: Helpers

    private func sizeWithStroke(_ size: CGSize) -> CGSize {
        CGSize(
            width: size.width + (strokeWidth * 2),
            height: size.height + (strokeWidth * 2)
        )
    }

    private func sizeWithoutStroke(_ size: CGSize) -> CGSize {
        CGSize(
            width: size.width - (strokeWidth * 2),
            height: size.height - (strokeWidth * 2)
        )
    }

    private func frameWithoutStroke(_ rect: CGRect) -> CGRect {
        rect.inset(
            by: UIEdgeInsets(
                top: strokeWidth,
                left: strokeWidth,
                bottom: strokeWidth,
                right: strokeWidth
            )
        )
    }
}
