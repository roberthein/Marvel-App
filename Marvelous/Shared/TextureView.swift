import UIKit

class TextureView: UIView {

    var texture: TextureType? {
        didSet {
            textureLayer?.texture = texture
        }
    }

    override class var layerClass: AnyClass {
        TextureLayer.self
    }

    private var textureLayer: TextureLayer? {
        layer as? TextureLayer
    }

    // MARK: Initialization

    init(texture: TextureType) {
        super.init(frame: .zero)

        textureLayer?.texture = texture

        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Notifications

    override func layoutSubviews() {
        super.layoutSubviews()

        textureLayer?.frame = frame
    }

    @objc private func didEnterBackground(_ notification: Notification) {
        textureLayer?.stopAnimation()
    }

    @objc private func willEnterForeground(_ notification: Notification) {
        textureLayer?.startAnimation()
    }

    // MARK: Animation

    func startAnimation() {
        textureLayer?.startAnimation()
    }
}
