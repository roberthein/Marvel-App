import Foundation
import UIKit

protocol CharacterPresentable {
    var sharedView: UIView? { get }
    func animateAlongPresentation(animator: UIViewPropertyAnimator, origin: CGRect, destination: CGRect)
    func animateAlongDismissal(animator: UIViewPropertyAnimator, destination: CGRect)
}
