import Utils
import UIKit
import Combine
import ComposableArchitecture

extension Portfolio {
    public final class ViewController: Utils.ViewController<State, Action> {
        static let cellIdentifier = "Fund"
        
        private var funds: [Fund.State] = [] { didSet { tableView.reloadData() } }
        private lazy var tableView: UITableView = {
            let view = UITableView()
            view.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
            view.delegate = self
            view.dataSource = self
            return view
        }()
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            viewStore.send(.viewDidLoad)
            dismissed = { [weak self] in self?.viewStore.send(.dismiss) }
            navigationItem.title = "Investments Portfolio"
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
                        
            viewStore.publisher.funds
                .compactMap(/Loading<[Fund.State]>.loaded)
                .sink { [weak self] funds in self?.funds = funds }
                .store(in: &self.cancellables)
        }
    }
}

extension Portfolio.ViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        funds.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Self.cellIdentifier,
            for: indexPath
        )
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = funds[indexPath.row].fund.name |> String.init
        return cell
    }
}

extension Portfolio.ViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        funds[indexPath.row].fund
            |> Portfolio.Route.fund >>> Portfolio.Action.handle
            |> viewStore.send
    }
}
