import Foundation
import UIKit

class CharactersSupplementaryView: UICollectionReusableView, Reusable {

    // MARK: Subviews

    private lazy var titleLabel = TitleLabel(
        strokeColor: DSM.Color.newBlack,
        strokeWidth: DSM.BorderWidth.large
    )..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = DSM.Font.title
        $0.numberOfLines = 3
        $0.textColor = DSM.Color.hazyYellow
        $0.text = "marvel".uppercased()
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
    }

    private lazy var subtitleLabel = TitleLabel(
        strokeColor: DSM.Color.newBlack,
        strokeWidth: DSM.BorderWidth.large
    )..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = DSM.Font.subtitle
        $0.numberOfLines = 3
        $0.textColor = DSM.Color.babyBlue
        $0.text = "characters".uppercased()
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
    }

    // MARK: Intialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = false

        addSubview(titleLabel)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor, constant: DSM.Spacing._10),
            subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
