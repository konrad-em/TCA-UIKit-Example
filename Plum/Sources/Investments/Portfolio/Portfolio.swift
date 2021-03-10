import ComposableArchitecture
import UIKit
import Utils

enum Loading<T: Equatable>: Equatable {
    case loading(previous: T?)
    case loaded(T)
}

public enum Portfolio {
    public typealias Store = ComposableArchitecture.Store<State, Action>

    public struct State: Equatable {
        var route: Route?
        var funds: Loading<[Fund.State]> = .loading(previous: [])
        var selectedFund: Fund.State?

        public init() { }
    }

    public enum Action: Equatable {
        case viewDidLoad
        case didLoad([Fund])
        case handle(Route)
        case dismiss
        case fund(action: Fund.Action)
    }

    public struct Environment {
        let fundsProvider: FundsProvider
        let mainQueue: AnySchedulerOf<DispatchQueue>
        
        public init(
            fundsProvider: FundsProvider,
            mainQueue: AnySchedulerOf<DispatchQueue>
        ) {
            self.fundsProvider = fundsProvider
            self.mainQueue = mainQueue
        }
    }

    public static let reducer: Reducer<State, Action, Environment> = .combine(
        
        Fund.reducer.optional().pullback(
            state: \.selectedFund,
            action: /Action.fund,
            environment: Fund.Environment.init
        ),
        
        Reducer<State, Action, Environment> { state, action, environment in
            switch action {
            
            case .viewDidLoad:
                return environment.fundsProvider.load()
                    .map(Action.didLoad)
                    .receive(on: environment.mainQueue)
                    .eraseToEffect()
                
            case let .didLoad(funds):
                state.funds = funds.map(Fund.State.init) |> Loading<[Fund.State]>.loaded
                return .none
                    
            case let .handle(.fund(fund)):
                state.selectedFund = Fund.State(fund: fund)
                return .none
        
            case .fund(action: .dismiss):
                state.selectedFund = nil
                return .none
            
            default:
                return .none
            }
        }
    )
}
