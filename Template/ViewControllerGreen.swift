
import UIKit

class ViewControllerGreen: UIViewController {
    let greenView = UIView(frame: CGRect(x: 200, y: 300, width: 100, height: 50))

    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        greenView.backgroundColor = .green
        view.addSubview(greenView)

        let b = UIButton(frame: CGRect(x: 200, y: 400, width: 100, height: 50))
        b.setTitle("Animate Back", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        view.addSubview(b)

        super.viewDidLoad()
    }

    override var prefersStatusBarHidden: Bool { true }
}
