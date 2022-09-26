import Foundation
import UIKit

class CharacterDetailTableViewCell: UITableViewCell, Reusable {

    var viewModel: CharacterDetailCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
        }
    }

    var theme: Theme? {
        didSet {
            guard let theme = theme else { return }

            contentView.backgroundColor = theme.comicBackgroundColor
            titleLabel.textColor = theme.comicTextColor
        }
    }

    var isLastItem: Bool = false {
        didSet {
            guard isLastItem != oldValue else { return }
            backgroundBottomConstraint.constant = isLastItem ? 0 : DSM.BorderWidth.hairline
        }
    }

    // MARK: Subviews

    private lazy var background = UIView()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderColor = DSM.Color.newBlack.cgColor
        $0.layer.borderWidth = DSM.BorderWidth.hairline
        $0.setTexture(.blinds)
    }

    private lazy var titleLabel = TitleLabel(
        strokeColor: DSM.Color.newBlack,
        strokeWidth: DSM.BorderWidth.hairline
    )..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = DSM.Font.comic
        $0.numberOfLines = 2
        $0.textColor = DSM.Color.hazyYellow
        $0.textAlignment = .left
        $0.isUserInteractionEnabled = false
    }

    // MARK: Constraints

    private lazy var backgroundBottomConstraint = background.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: DSM.BorderWidth.hairline
    )

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = nil
        isOpaque = false
        backgroundView = UIView()
        selectionStyle = .none

        contentView.clipsToBounds = true

        contentView.addSubview(background)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -DSM.BorderWidth.hairline),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DSM.BorderWidth.hairline),
            backgroundBottomConstraint,

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DSM.Spacing._20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DSM.Spacing._20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
