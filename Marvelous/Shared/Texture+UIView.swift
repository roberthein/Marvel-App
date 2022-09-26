import Foundation
import UIKit

extension UIView {

    func setTexture(_ texture: TextureType) {
        if let textureView = textureView {
            textureView.texture = texture
        } else {
            addTexture(texture: texture)
        }

        textureView?.startAnimation()
    }

    func removeTexture() {
        textureView?.removeFromSuperview()
    }

    var textureView: TextureView? {
        subviews.compactMap { $0 as? TextureView }.first
    }

    private func addTexture(texture: TextureType) {
        let textureView = TextureView(texture: texture)..{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(textureView)

        NSLayoutConstraint.activate([
            textureView.topAnchor.constraint(equalTo: topAnchor),
            textureView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textureView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textureView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        layoutIfNeeded()
    }
}
