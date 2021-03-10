import UIKit
import Combine
import Utils
import ComposableArchitecture

final class ViewController: Utils.ViewController<State, Action> {
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [
            Button(
                title: "Pockets",
                backgroundColor: .systemGreen,
                action: .init { [weak self] _ in self?.viewStore.send(.handle(.pockets)) }
            ),
            Button(
                title: "Investments",
                backgroundColor: .systemIndigo,
                action: .init { [weak self] _ in self?.viewStore.send(.handle(.investments)) }
            )
        ]
        .forEach(stackView.addArrangedSubview)
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5)
        ])
    }
    
    override func didMove(toParent parent: UIViewController?) {
        view.backgroundColor = .systemTeal
        tabBarItem = .init(
            title: "Home",
            image: UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate),
            tag: 0
        )
        navigationItem.title = "Home"
    }
}
