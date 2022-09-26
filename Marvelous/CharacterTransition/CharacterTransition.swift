import Foundation
import UIKit

class CharacterTransition: NSObject {

    // MARK: Operation

    enum TransitionOperation {
        case present
        case dismiss
    }

    private var operation: TransitionOperation = .present
    private var verticalOffset: CGFloat = 0

    // MARK: Initialization

    let presenting: UIViewController & CharacterPresenting

    required init(from presenting: UIViewController & CharacterPresenting) {
        self.presenting = presenting
        super.init()
    }

    // MARK: Presentation

    private func presentTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromContainingView = presenting.containingView,
              let fromSharedView = presenting.sharedView,
              let toViewController = transitionContext.viewController(forKey: .to) as? CharacterPresentable,
              let toSharedView = toViewController.sharedView,
              let toView = transitionContext.view(forKey: .to)
        else { return }

        toView.layoutIfNeeded()

        transitionContext.containerView.addSubview(toView)

        let toOrigin = transitionContext.containerView.convert(
            toSharedView.frame.origin,
            to: transitionContext.containerView
        )

        let originFrame = CGRect(
            origin: fromContainingView.convert(fromSharedView.frame.origin, to: transitionContext.containerView),
            size: fromSharedView.frame.size
        )

        let destinationFrame = toView.frame

        verticalOffset = toOrigin.y
        toView.clipsToBounds = false
        toView.frame = originFrame
        toView.frame.origin.y -= verticalOffset
        toView.layoutIfNeeded()

        fromSharedView.alpha = 0

        let translation = CGPoint(
            x: destinationFrame.origin.x - originFrame.origin.x,
            y: destinationFrame.origin.y - originFrame.origin.y
        )

        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            dampingRatio: 0.8
        )..{
            $0.addAnimations { [weak self] in
                guard let self = self else { return }
                toView..{
                    $0.transform = CGAffineTransform(translationX: translation.x, y: translation.y + self.verticalOffset)
                    $0.frame.size = destinationFrame.size
                    $0.layoutIfNeeded()
                }
            }

            $0.addCompletion { _ in
                toView..{
                    $0.transform = .identity
                    $0.frame = destinationFrame
                }

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

        toViewController.animateAlongPresentation(animator: animator, origin: originFrame, destination: destinationFrame)
        animator.startAnimation()
    }

    // MARK: Dismissal

    private func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? CharacterPresentable,
              let fromView = transitionContext.view(forKey: .from),
              let toContainingView = presenting.containingView,
              let toSharedView = presenting.sharedView
        else { return }

        transitionContext.containerView.addSubview(fromView)

        let destinationFrame = CGRect(
            origin: toContainingView.convert(toSharedView.frame.origin, to: transitionContext.containerView),
            size: toSharedView.frame.size
        )

        let translation = CGPoint(
            x: destinationFrame.origin.x - fromView.frame.origin.x,
            y: destinationFrame.origin.y + fromView.frame.origin.y
        )

        toSharedView.alpha = 0

        let originalTransform = toSharedView.transform
        toSharedView.transform = toSharedView.transform.translatedBy(x: (translation.x / 3) * -1, y: (translation.y / 2) * -1)

        let animator = UIViewPropertyAnimator(
            duration: transitionDuration(using: transitionContext),
            dampingRatio: 0.8
        )..{
            $0.addAnimations { [weak self] in
                guard let self = self else { return }

                toSharedView.transform = originalTransform
                toSharedView.alpha = 1

                fromView.transform = CGAffineTransform(translationX: translation.x, y: translation.y - self.verticalOffset)
                fromView.frame.size = destinationFrame.size
                fromView.layoutIfNeeded()
            }

            $0.addCompletion { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

        fromViewController.animateAlongDismissal(animator: animator, destination: destinationFrame)
        animator.startAnimation()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension CharacterTransition: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        operation = .present
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        operation = .dismiss
        return self
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension CharacterTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .present:
            presentTransition(transitionContext)
        case .dismiss:
            dismissTransition(transitionContext)
        }
    }
}
