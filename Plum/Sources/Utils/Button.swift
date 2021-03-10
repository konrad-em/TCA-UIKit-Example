import UIKit

public class Button: UIButton {
    public init(
        title: String,
        backgroundColor: UIColor,
        action: UIAction
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor.withAlphaComponent(0.5)
        self.layer.cornerRadius = 20
        self.addAction(action, for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
