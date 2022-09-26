import UIKit

final class CharactersLayout: UICollectionViewFlowLayout {

    private let config: Config
    private var transforms: [CGAffineTransform] = []

    private static let variations: Int = 20

    private let rotations: [CGFloat] = (0 ... variations)
        .map { _ in CGFloat.random(in: -5 ... 5) }
        .shuffled()

    private let xOffsets: [CGFloat] = (0 ... variations)
        .map { _ in CGFloat.random(in: -DSM.Spacing._20 ... DSM.Spacing._20) }
        .shuffled()

    private let yOffsets: [CGFloat] = (0 ... variations)
        .map { _ in CGFloat.random(in: -DSM.Spacing._20 ... DSM.Spacing._20) }
        .shuffled()

    private let parallaxOffsets: [CGFloat] = (0 ... variations)
        .map { _ in CGFloat.random(in: DSM.Spacing._20 ... DSM.Spacing._40) }
        .shuffled()

    // MARK: Initialization

    init(configuration: Config) {
        self.config = configuration
        super.init()

        minimumInteritemSpacing = configuration.minimumInteritemSpacing
        minimumLineSpacing = configuration.minimumLineSpacing
        scrollDirection = .vertical
        sectionHeadersPinToVisibleBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Preparation

    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else { return }

        let sectionInsets = sectionInset.left + sectionInset.right
        let safeAreaInsets = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        let interitemSpacings = minimumInteritemSpacing * CGFloat(config.numberOfColumns - 1)
        let contentInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let marginsAndInsets = sectionInsets + safeAreaInsets + interitemSpacings + contentInsets
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(config.numberOfColumns))

        itemSize = CGSize(width: itemWidth, height: itemWidth * config.itemAspectRatio)
        headerReferenceSize = CGSize(width: collectionView.bounds.size.width, height: DSM.GridSize._200)
        
        transforms = (0 ..< numberOfItems).map { itemIndex in
            // Deterministic random rotation
            let rotation = rotations[itemIndex % rotations.count]

            // Deterministic random translation
            let translation = CGPoint(
                x: xOffsets[itemIndex % rotations.count],
                y: yOffsets[itemIndex % rotations.count]
            )

            return CGAffineTransform(rotationAngle: rotation.deg2rad)
                .translatedBy(x: translation.x, y: translation.y)
        }
    }

    // MARK: Overrides

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }

        attributes?.forEach {
            let itemIndex = $0.indexPath.item
            guard var transform = transforms[safe: itemIndex] else { return }

            if let collectionView = collectionView,
               let keyWindow = UIApplication.shared.keyWindow
            {
                let maxParallaxOffset = parallaxOffsets[itemIndex % parallaxOffsets.count]
                let itemCenter = collectionView.convert($0.center, to: keyWindow)
                let diff = keyWindow.center.y - itemCenter.y

                let screenRange = keyWindow.bounds.midY ... keyWindow.bounds.maxY
                let targetRange: ClosedRange<CGFloat> = 0 ... 1

                let itemParallax = diff.map(from: screenRange, to: targetRange) * maxParallaxOffset
                transform = transform.translatedBy(x: 0, y: itemParallax)
            }

            $0.transform = transform
        }

        return attributes
    }

    // MARK: Helpers

    var numberOfItems: Int {
        guard let collectionView = collectionView, collectionView.numberOfSections > 0 else {
            return 0
        }

        return collectionView.numberOfItems(inSection: 0)
    }

    var contentOffset: CGPoint {
        collectionView?.contentOffset ?? .zero
    }
}

// MARK: - Configuration

extension CharactersLayout {

    struct Config {
        let minimumInteritemSpacing: CGFloat
        let minimumLineSpacing: CGFloat
        let numberOfColumns: Int
        let itemAspectRatio: CGFloat
    }
}
