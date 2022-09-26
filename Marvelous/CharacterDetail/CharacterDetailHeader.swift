import UIKit

public final class CharacterDetailHeader: UITableViewHeaderFooterView, Reusable {

    var character: Character? {
        didSet {
            characterImageView.character = character
            nameLabel.text = character?.name.uppercased()
            summaryView.summary = character?.description
        }
    }

    var theme: Theme? {
        didSet {
            guard let theme = theme else { return }

            background.backgroundColor = theme.backgroundColorPrimary
            background.setTexture(theme.texture)
            nameLabel.textColor = theme.titleColor
            summaryView.theme = theme
        }
    }

    private let factor: CGFloat = .random(in: DSM.Spacing._40 ... DSM.Spacing._80)
    private let isLeadingAligned: Bool = .random()

    private struct Image {
        static let aspectRatio = DSM.AspectRatio.characterImage
        static let width = UIScreen.main.bounds.width / 2
        static let height = width * aspectRatio
        static let size = CGSize(width: width, height: height)
    }

    struct Config {
        static let topOffset = DSM.Spacing._40
        static let bottomOffset = DSM.Spacing._40
        static let totalHeight = Image.size.height + bottomOffset
    }

    struct Summary {
        static let maxWidth = Image.width * 0.85
    }

    private var scalar: CGFloat {
        isLeadingAligned ? -1 : 1
    }

    private var rotationAngle: CGFloat {
        (factor / 10).deg2rad * scalar
    }

    private var centerXOffset: CGFloat {
        factor * scalar
    }

    // MARK: Subviews

    private(set) lazy var background = UIView()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderColor = DSM.Color.newBlack.cgColor
        $0.layer.borderWidth = DSM.BorderWidth.small
        $0.clipsToBounds = true
    }

    private(set) lazy var characterImageView = CharacterImageView()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = DSM.Color.background
        $0.layer.cornerRadius = DSM.CornerRadius.large
        $0.layer.borderColor = DSM.Color.newBlack.cgColor
        $0.layer.borderWidth = DSM.BorderWidth.large
        $0.clipsToBounds = true
        $0.transform = CGAffineTransform(rotationAngle: rotationAngle)
        $0.setTexture(.dots)
    }

    private(set) lazy var nameLabel = TitleLabel(
        strokeColor: DSM.Color.newBlack,
        strokeWidth: DSM.BorderWidth.large
    )..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = DSM.Font.name
        $0.numberOfLines = 3
        $0.textAlignment = isLeadingAligned ? .left : .right
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
        $0.clipsToBounds = false
    }

    private lazy var summaryView = CharacterDetailSummaryView()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Constraints

    private var nameLabelLeadingConstraint: NSLayoutConstraint {
        isLeadingAligned ?
        nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: -DSM.Spacing._40) :
        nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    }

    private var nameLabelTrailingConstraint: NSLayoutConstraint {
        isLeadingAligned ?
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor) :
        nameLabel.trailingAnchor.constraint(equalTo: characterImageView.leadingAnchor, constant: DSM.Spacing._40)
    }

    // MARK: Initialization

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(background)
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(summaryView)

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -DSM.GridSize._200 * 3),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -DSM.Spacing._10),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: DSM.Spacing._10),
            background.bottomAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: -Config.bottomOffset),

            characterImageView.widthAnchor.constraint(equalToConstant: Image.size.width),
            characterImageView.heightAnchor.constraint(equalToConstant: Image.size.height),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Config.topOffset),
            characterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: centerXOffset),

            nameLabel.centerYAnchor.constraint(equalTo: characterImageView.centerYAnchor),
            nameLabelLeadingConstraint,
            nameLabelTrailingConstraint,

            summaryView.centerYAnchor.constraint(equalTo: characterImageView.bottomAnchor),
            summaryView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            summaryView.widthAnchor.constraint(equalToConstant: Summary.maxWidth)
        ])
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
