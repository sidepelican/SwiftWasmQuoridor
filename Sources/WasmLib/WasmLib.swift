import QuoridorEngine
import Foundation

enum WasmInterfaceError: Error {
    case gameNotFound
}

private var games: [GameContext] = []
private func findGame(_ game: GameID) throws -> GameContext {
    guard let game = games.first(where: { $0.id == game }) else {
        throw WasmInterfaceError.gameNotFound
    }
    return game
}

enum WasmLib: WasmExports {
    static func newGame() -> GameID {
        let newGame = GameContext()
        games.append(newGame)
        return newGame.id
    }

    static func putFence(game: GameID, position: FencePoint) throws {
        let currentGame = try findGame(game)
        if let error = currentGame.wasmPlayer.putFence(
            p: position.asEngine,
            o: position.orientation.asEngine
        ) {
            throw error
        }
    }

    static func movePawn(game: GameID, command: PawnPoint) throws {
        let currentGame = try findGame(game)
        if let error = currentGame.wasmPlayer.movePawn(p: command.asEngine) {
            throw error
        }
    }

    static func aiNext(game: GameID) throws {
        let currentGame = try findGame(game)
        _ = currentGame.aiPlayer.next()
    }

    static func currentBoard(game: GameID) throws -> Board {
        let currentGame = try findGame(game)
        let gameState = currentGame.agent.currentState

        let humanPawn = gameState.board.pawn(ofID: currentGame.wasmPlayer.playerID)
        let aiPawn = gameState.board.pawn(ofID: currentGame.aiPlayer.playerID)

        var winner: PlayerSide? {
            if gameState.isWin(for: currentGame.wasmPlayer.playerID) {
                return .human
            } else if gameState.isWin(for: currentGame.aiPlayer.playerID) {
                return .ai
            } else {
                return nil
            }
        }

        return Board(
            currentTurn: gameState.currentPlayer == currentGame.wasmPlayer.playerID ? .human : .ai,
            winner: winner,
            humanPawn: .init(side: .human,
                             point: .init(x: Int(humanPawn.point.x), y: Int(humanPawn.point.y)),
                             fencesLeft: humanPawn.fencesLeft),
            aiPawn: .init(side: .ai,
                          point: .init(x: Int(aiPawn.point.x), y: Int(aiPawn.point.y)),
                          fencesLeft: aiPawn.fencesLeft),
            hFences: (Int32(0)..<8).flatMap { i in
                (Int32(0)..<8).map { j in
                    let (x, y) = (i + 1, j + 1)
                    return FenceInfo(exists: gameState.board.fenceMap[x, y]?.orientation == .horizontal,
                              canPut: gameState.board.canAddFence(at: .init(x: x, y: y), orientation: .horizontal))
                }
            },
            vFences: (Int32(0)..<8).flatMap { i in
                (Int32(0)..<8).map { j in
                    let (x, y) = (i + 1, j + 1)
                    return FenceInfo(exists: gameState.board.fenceMap[x, y]?.orientation == .vertical,
                              canPut: gameState.board.canAddFence(at: .init(x: x, y: y), orientation: .vertical))
                }
            },
            canMoves: (0..<9).flatMap { x in
                (0..<9).map { y in
                    gameState.board.canMovePawn(
                        ofID: currentGame.wasmPlayer.playerID,
                        to: .init(x: x, y: y)
                    )
                }
            }
        )
    }

    static func deleteGame(game: GameID) {
        if let index = games.firstIndex(where: { $0.id == game }) {
            games.remove(at: index)
        }
    }
}

private var globalGameID: Int = 0

struct GameContext {
    let id: GameID
    let agent: GameAgent
    let wasmPlayer = WasmController()
    let aiPlayer: MonteCarloPlayerWrapper

    init() {
        id = GameID(raw: globalGameID)
        globalGameID += 1
        let agent = GameAgent()
        self.agent = agent
        let ai = MonteCarloPlayerWrapper(playerID: "M", agent: agent)
        aiPlayer = ai
        agent.setup(player1: ai, player2: wasmPlayer, firstPlayerIsOne: Bool.random())
        agent.start()
    }
}

extension FencePoint {
    var asEngine: QuoridorEngine.FencePoint {
        return .init(x: Int32(x), y: Int32(y))
    }
}

extension FenceOrientation {
    var asEngine: Fence.Orientation {
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
