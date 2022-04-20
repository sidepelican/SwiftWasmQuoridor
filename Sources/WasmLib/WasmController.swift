import QuoridorEngine

class WasmController: PlayerController {
    func putFence(p: QuoridorEngine.FencePoint, o: Fence.Orientation) -> MutatingAction.Error? {
        currentAction?(.putFence(p, o))
    }

    func movePawn(p: QuoridorEngine.PawnPoint) -> MutatingAction.Error? {
        currentAction?(.movePawn(p))
    }

    private var currentAction: ((MutatingAction) -> MutatingAction.Error?)?

    // MARK: - PlayerController
    var playerID: PlayerID { "Wasm" }

    func onRequestedTurnAction(evaluateAction: @escaping (MutatingAction) -> MutatingAction.Error?) {
        currentAction = evaluateAction
    }
}
