import UIKit

class CharacterViewCell: UICollectionViewCell, Reusable {

    var character: Character? {
        didSet {
            characterImageView.character = character
        }
    }

    private(set) lazy var characterImageView = CharacterImageView()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTexture(.blinds)
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = DSM.Color.background
        contentView.layer.cornerRadius = DSM.CornerRadius.small
        contentView.layer.borderColor = DSM.Color.newBlack.cgColor
        contentView.layer.borderWidth = DSM.BorderWidth.small
        contentView.clipsToBounds = true

        contentView.addSubview(characterImageView)

        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Reuse

    override func prepareForReuse() {
        super.prepareForReuse()

        characterImageView.textureView?.startAnimation()
    }
}
