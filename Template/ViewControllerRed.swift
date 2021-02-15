
import UIKit

class ViewControllerRed: UIViewController {

    let redView = UIView(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        redView.backgroundColor = .red
        view.addSubview(redView)
        
        let b = UIButton(frame: CGRect(x: 200, y: 350, width: 100, height: 50))
        b.setTitle("Animate", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            let greenvc = ViewControllerGreen()
            greenvc.transitioningDelegate = self
            greenvc.modalPresentationStyle = .custom
            greenvc.modalPresentationCapturesStatusBarAppearance = true
            self.present(greenvc, animated: true, completion: nil)
        }), for: .touchUpInside)
        view.addSubview(b)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NSLog("\(Self.description()) \(#function)")
    }
}

extension ViewControllerRed: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        nil
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        NSLog("\(Self.description()) \(#function)")
        return InteractiveTransitioningControllerGreenToRed()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        NSLog("\(Self.description()) \(#function)")
        return animator as? UIViewControllerInteractiveTransitioning
    }
}
