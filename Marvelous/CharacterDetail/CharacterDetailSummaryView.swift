import Foundation
import UIKit

class CharacterDetailSummaryView: UIView {

    var theme: Theme? {
        didSet {
            guard let theme = theme else { return }

            backgroundColor = theme.summaryBackgroundColor
            titleLabel.textColor = theme.summaryTextColor
        }
    }

    var summary: String? {
        didSet {
            titleLabel.text = summary
            isHidden = summary == nil || summary == "" || summary == " "
        }
    }

    // MARK: Subviews

    private lazy var titleLabel = UILabel()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = DSM.Font.summary
        $0.numberOfLines = 0
        $0.textColor = DSM.Color.newBlack
        $0.textAlignment = .left
        $0.isUserInteractionEnabled = false
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderColor = DSM.Color.newBlack.cgColor
        layer.borderWidth = DSM.BorderWidth.hairline

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: DSM.Spacing._10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSM.Spacing._10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -DSM.Spacing._10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSM.Spacing._10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
