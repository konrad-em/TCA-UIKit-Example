import ComposableArchitecture
import UIKit
import Utils
import Pockets
import Investments
import Combine

public typealias Store = ComposableArchitecture.Store<State, Action>

public struct State: Equatable {
    var pockets: Pockets.State?
    var investmentsPortfolio: Investments.Portfolio.State?
 
    public init() { }
}

public enum Action: Equatable {
    case pockets(action: Pockets.Action)
    case investmentsPortfolio(action: Investments.Portfolio.Action)
    case handle(Route)
}

public struct Environment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.mainQueue = mainQueue
    }
}

public let reducer: Reducer<State, Action, Environment> = .combine(
    
    Pockets.reducer.optional().pullback(
        state: \.pockets,
        action: /Action.pockets,
        environment: { _ in Pockets.Environment() }
    ),
    
    Investments.Portfolio.reducer.optional().pullback(
        state: \.investmentsPortfolio,
        action: /Action.investmentsPortfolio,
        environment: Investments.Portfolio.Environment.init
    ),
    
    Reducer<State, Action, Environment> { state, action, environment in
        switch action {
    
        // Pockets
            
        case .handle(.pockets):
            state.pockets = Pockets.State()
            return .none
            
        case .pockets(.dismiss):
            state.pockets = nil
            return .none
        
        // Investments
        
        case .handle(.investments):
            state.investmentsPortfolio = Investments.Portfolio.State()
            return .none
        
        case .investmentsPortfolio(.dismiss):
            state.investmentsPortfolio = nil
            return .none
            
        default:
            return .none
        }
    }
)
