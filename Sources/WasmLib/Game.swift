import Algorithms
import Foundation
import QuoridorEngine

public final class Game {
    private let agent: GameAgent
    private let wasmPlayer = WasmController()
    private let aiPlayer: MonteCarloPlayerWrapper

    private var gameState: GameState {
        agent.currentState
    }

    public init() {
        let agent = GameAgent()
        self.agent = agent
        let ai = MonteCarloPlayerWrapper(playerID: "M", agent: agent)
        aiPlayer = ai
        agent.setup(player1: ai, player2: wasmPlayer, firstPlayerIsOne: Bool.random())
        agent.start()
    }

    public func putFence(position: FencePoint) throws {
        if let error = wasmPlayer.putFence(
            p: position.asEngine,
            o: position.orientation.asEngine
        ) {
            throw error
        }
    }

    public func movePawn(position: PawnPoint) throws {
        if let error = wasmPlayer.movePawn(p: position.asEngine) {
            throw error
        }
    }

    public func aiNext() {
        _ = aiPlayer.next()
    }

    public func currentBoard() throws -> Board {
        let humanPawn = gameState.board.pawn(ofID: wasmPlayer.playerID)
        let aiPawn = gameState.board.pawn(ofID: aiPlayer.playerID)

        var winner: PlayerSide? {
            if gameState.isWin(for: wasmPlayer.playerID) {
                return .human
            } else if gameState.isWin(for: aiPlayer.playerID) {
                return .ai
            } else {
                return nil
            }
        }

        return Board(
            currentTurn: gameState.currentPlayer == wasmPlayer.playerID ? .human : .ai,
            winner: winner,
            humanPawn: .init(side: .human,
                             point: .init(x: Int(humanPawn.point.x), y: Int(humanPawn.point.y)),
                             fencesLeft: humanPawn.fencesLeft),
            aiPawn: .init(side: .ai,
                          point: .init(x: Int(aiPawn.point.x), y: Int(aiPawn.point.y)),
                          fencesLeft: aiPawn.fencesLeft),
            hFences: product(Int32(0)..<8, Int32(0)..<8).map { i, j in
                let (x, y) = (i + 1, j + 1)
                return FenceInfo(exists: gameState.board.fenceMap[x, y]?.orientation == .horizontal,
                                 canPut: gameState.board.canAddFence(at: .init(x: x, y: y), orientation: .horizontal))
            },
            vFences: product(Int32(0)..<8, Int32(0)..<8).map { i, j in
                let (x, y) = (i + 1, j + 1)
                return FenceInfo(exists: gameState.board.fenceMap[x, y]?.orientation == .vertical,
                                 canPut: gameState.board.canAddFence(at: .init(x: x, y: y), orientation: .vertical))
            },
            canMoves: product(Int32(0)..<9, Int32(0)..<9).map { x, y in
                gameState.board.canMovePawn(
                    ofID: wasmPlayer.playerID,
                    to: .init(x: x, y: y)
                )
            }
        )
    }

    // MARK :- legacy functions get states in small pieces

    public func canPutFence(position: FencePoint) -> Bool {
        gameState.board.canAddFence(at: position.asEngine, orientation: position.orientation.asEngine)
    }

    public func canMove(position: PawnPoint) -> Bool {
        gameState.board.canMovePawn(
            ofID: wasmPlayer.playerID,
            to: position.asEngine
        )
    }

    public func existsFence(position: FencePoint) -> Bool {
        gameState.board.fenceMap[numericCast(position.x), numericCast(position.y)]?.orientation == position.orientation.asEngine
    }

    public func pawnPosition(side: PlayerSide) -> PawnPoint {
        let pawn: QuoridorEngine.Pawn
        switch side {
        case .human:
            pawn = gameState.board.pawn(ofID: wasmPlayer.playerID)
        case .ai:
            pawn = gameState.board.pawn(ofID: aiPlayer.playerID)
        }
        return .init(x: numericCast(pawn.point.x), y: numericCast(pawn.point.y))
    }

    public func winPlayer() -> PlayerSide? {
        if gameState.isWin(for: wasmPlayer.playerID) {
            return .human
        } else if gameState.isWin(for: aiPlayer.playerID) {
            return .ai
        } else {
            return nil
        }
    }

    public func currentTurn() -> PlayerSide {
        gameState.currentPlayer == wasmPlayer.playerID ? .human : .ai
    }

    public func remainingFences(side: PlayerSide) -> Int {
        let pawn: QuoridorEngine.Pawn
        switch side {
        case .human:
            pawn = gameState.board.pawn(ofID: wasmPlayer.playerID)
        case .ai:
            pawn = gameState.board.pawn(ofID: aiPlayer.playerID)
        }
        return pawn.fencesLeft
    }
}

extension FencePoint {
    var asEngine: QuoridorEngine.FencePoint {
        return .init(x: Int32(x), y: Int32(y))
    }
}

extension FenceOrientation {
    var asEngine: QuoridorEngine.Fence.Orientation {
        switch self {
        case .horizontal:
            return .horizontal
        case .vertical:
            return .vertical
        }
    }
}

extension PawnPoint {
    var asEngine: QuoridorEngine.PawnPoint {
        return .init(x: Int32(x), y: Int32(y))
    }
}
