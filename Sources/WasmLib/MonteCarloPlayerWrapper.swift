import QuoridorEngine

final class MonteCarloPlayerWrapper: PlayerController {
    let upstream: MonteCarloPlayer
    init(
        playerID: PlayerID,
        agent: GameAgent
    ) {
        upstream = .init(playerID: playerID, agent: agent)
    }

    private var evaluateAction: ((MutatingAction) -> MutatingAction.Error?)?
    func next() -> Bool {
        if let evaluateAction = evaluateAction {
            upstream.onRequestedTurnAction(evaluateAction: evaluateAction)
            self.evaluateAction = nil
            return true
        }
        return false
    }

    // MARK: - PlayerController

    var playerID: PlayerID {
        upstream.playerID
    }

    func onRequestedTurnAction(evaluateAction: @escaping (MutatingAction) -> MutatingAction.Error?) {
        self.evaluateAction = evaluateAction
    }
}
