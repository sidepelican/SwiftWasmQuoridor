import Algorithms
import Foundation
import QuoridorEngine

public final class Game {
    private let ctx: GameContext
    public init() {
        ctx = .init()
    }

    public func putFence(position: FencePoint) throws {
        if let error = ctx.wasmPlayer.putFence(
            p: position.asEngine,
            o: position.orientation.asEngine
        ) {
            throw error
        }
    }

    public func movePawn(position: PawnPoint) throws {
        if let error = ctx.wasmPlayer.movePawn(p: position.asEngine) {
            throw error
        }
    }

    public func aiNext() {
        _ = ctx.aiPlayer.next()
    }

    public func currentBoard() throws -> Board {
        let gameState = ctx.agent.currentState

        let humanPawn = gameState.board.pawn(ofID: ctx.wasmPlayer.playerID)
        let aiPawn = gameState.board.pawn(ofID: ctx.aiPlayer.playerID)

        var winner: PlayerSide? {
            if gameState.isWin(for: ctx.wasmPlayer.playerID) {
                return .human
            } else if gameState.isWin(for: ctx.aiPlayer.playerID) {
                return .ai
            } else {
                return nil
            }
        }

        return Board(
            currentTurn: gameState.currentPlayer == ctx.wasmPlayer.playerID ? .human : .ai,
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
                    ofID: ctx.wasmPlayer.playerID,
                    to: .init(x: x, y: y)
                )
            }
        )
    }
}
