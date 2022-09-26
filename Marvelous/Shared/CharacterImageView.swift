import Foundation
import UIKit

class CharacterImageView: UIView {

    private struct Config {
        static let loadingBackgroundColor = DSM.Color.newBlack.withAlphaComponent(DSM.Opacity._20)
        static let loadingTintColor = DSM.Color.newBlack
        static let loadingImage = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        static let placeholderBackgroundColor = DSM.Color.newBlack.withAlphaComponent(DSM.Opacity._80)
        static let placeholderTintColor = DSM.Color.background
        static let placeholderImage = UIImage(systemName: "person.crop.circle.fill.badge.xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
    }

    var character: Character? {
        didSet {
            guard let character = character else { return }

            if character.shouldShowPlaceholder {
                placeholderImageView.image = Config.placeholderImage
                placeholderImageView.tintColor = Config.placeholderTintColor
                placeholderImageView.backgroundColor = Config.placeholderBackgroundColor
                imageView.image = nil
            } else {
                placeholderImageView.image = Config.loadingImage
                placeholderImageView.tintColor = Config.loadingTintColor
                placeholderImageView.backgroundColor = Config.loadingBackgroundColor
                imageView.image = character.image
            }
        }
    }

    // MARK: Subviews

    private lazy var placeholderImageView = UIImageView(image: Config.placeholderImage)..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = DSM.Color.newBlack
        $0.contentMode = .center
    }

    private lazy var imageView = UIImageView()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(placeholderImageView)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            placeholderImageView.topAnchor.constraint(equalTo: topAnchor),
            placeholderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            placeholderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
