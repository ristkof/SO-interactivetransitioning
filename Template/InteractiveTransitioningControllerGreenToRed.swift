
import UIKit

class InteractiveTransitioningControllerGreenToRed: NSObject, UIGestureRecognizerDelegate, UIViewControllerInteractiveTransitioning, UIViewControllerAnimatedTransitioning
{
    private var transitionContext: UIViewControllerContextTransitioning?
    private var animator: UIViewPropertyAnimator?
    
    deinit {
        NSLog("\(Self.description()) \(#function)")
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        NSLog("\(Self.description()) \(#function)")
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
        do {}   // nothing to do here
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        NSLog("\(Self.description()) \(#function)")
        self.transitionContext = transitionContext
        let greenVC = transitionContext.viewController(forKey: .from) as! ViewControllerGreen
        let redNC = transitionContext.viewController(forKey: .to) as! UINavigationController
        let redVC = redNC.viewControllers.compactMap { $0 as? ViewControllerRed }.first!
        let v = greenVC.greenView
        transitionContext.containerView.addSubview(v)
        v.constraints.forEach { $0.isActive = false }
        v.translatesAutoresizingMaskIntoConstraints = true
        animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut) {
            v.frame = redVC.redView.frame
            v.backgroundColor = redVC.redView.backgroundColor
        }
        animator!.addCompletion { position in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            v.removeFromSuperview()
        }
        animator!.startAnimation()
        return animator!
    }

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        NSLog("\(Self.description()) \(#function)")
        do {}   // nothing to do here
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        NSLog("\(Self.description()) \(#function)")
        // I do not understand why this would be necessary, but it is:
        let redNC = transitionContext!.viewController(forKey: .to) as! UINavigationController
        redNC.setNeedsStatusBarAppearanceUpdate()
    }
}
