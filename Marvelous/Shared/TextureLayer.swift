import UIKit

class TextureLayer: CAReplicatorLayer {

    var texture: TextureType? {
        didSet {
            imageLayer.contents = texture?.image?.cgImage
        }
    }

    struct Config {
        static let imageSize: CGSize = .square(size: 20)
    }

    // MARK: Sublayers

    private lazy var imageLayer = CALayer()..{
        $0.frame.size = Config.imageSize
        $0.contents = UIImage(named: "pattern_1")
    }

    private lazy var verticalReplicatorLayer = CAReplicatorLayer()..{
        $0.addSublayer(imageLayer)

        $0.instanceTransform = CATransform3DMakeTranslation(
            Config.imageSize.width, 0, 0
        )
    }

    // MARK: Initialization

    override init() {
        super.init()

        addSublayer(verticalReplicatorLayer)

        instanceTransform = CATransform3DMakeTranslation(
            0, Config.imageSize.height, 0
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    // MARK: Layout

    override func layoutSublayers() {
        super.layoutSublayers()

        let horizontalInstanceCount = Int(ceil(frame.width / Config.imageSize.width))
        let verticalInstanceCount = Int(ceil(frame.height / Config.imageSize.height))
        verticalReplicatorLayer.instanceCount = horizontalInstanceCount + 1
        instanceCount = verticalInstanceCount + 1
    }

    // MARK: Animation

    func stopAnimation() {
        imageLayer.removeAllAnimations()
    }

    func startAnimation() {
        let duration: CFTimeInterval = 2

        imageLayer.add(
            CABasicAnimation(keyPath: "transform.translation.x")..{
                $0.duration = duration
                $0.fromValue = -Config.imageSize.width
                $0.toValue = 0
                $0.autoreverses = false
                $0.repeatCount = .infinity
            },
            forKey: "translation.x"
        )

        imageLayer.add(
            CABasicAnimation(keyPath: "transform.translation.y")..{
                $0.duration = duration
                $0.fromValue = -Config.imageSize.height
                $0.toValue = 0
                $0.autoreverses = false
                $0.repeatCount = .infinity
            },
            forKey: "translation.y"
        )
    }
}
