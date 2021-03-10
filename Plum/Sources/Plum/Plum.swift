import ComposableArchitecture
import Home
import LostMoney
import Cashback
import Utils
import UIKit

typealias Store = ComposableArchitecture.Store<State, Action>

struct State: Equatable {
    var home: Home.State
    var lostMoney: LostMoney.State
    var cashback: Cashback.State
    
    var route: Route?
}

enum Action: Equatable {
    case home(action: Home.Action)
    case lostMoney(action: LostMoney.Action)
    case cashback(action: Cashback.Action)
    case handle(Route)
}

struct Environment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
}

let reducer: Reducer<State, Action, Environment> = .combine(

    Home.reducer.pullback(
        state: \.home,
        action: /Action.home,
        environment: Home.Environment.init
    ),
    
    LostMoney.reducer.pullback(
        state: \.lostMoney,
        action: /Action.lostMoney,
        environment: LostMoney.Environment.init
    ),
    
    Cashback.reducer.pullback(
        state: \.cashback,
        action: /Action.cashback,
        environment: Cashback.Environment.init
    ),
    
    Reducer<State, Action, Environment> { state, action, environment in
        switch action {
    
        case .handle(.home):
            state.route = .home
            return .none
            
        case .handle(.lostMoney):
            state.route = .lostMoney
            return .none
            
        case .handle(.cashback):
            state.route = .cashback
            return .none
                    
        default:
            return .none
        }
    }
)
