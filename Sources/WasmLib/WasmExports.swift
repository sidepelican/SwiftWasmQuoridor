import Foundation

protocol WasmExports {
    static func newGame() -> GameID
    static func putFence(game: GameID, position: FencePoint) throws
    static func movePawn(game: GameID, command: PawnPoint) throws
    static func aiNext(game: GameID) throws
    static func currentBoard(game: GameID) throws -> Board
    static func deleteGame(game: GameID)
}

struct GameID: Codable, Hashable {
    var raw: Int
}

enum FenceOrientation: String, Codable {
    case horizontal
    case vertical
}

struct FencePoint: Codable {
    var x: Int
    var y: Int
    var orientation: FenceOrientation
}

struct PawnPoint: Codable {
    var x: Int
    var y: Int
}

enum PlayerSide: String, Codable {
    case ai
    case human
}

struct Pawn: Codable {
    var side: PlayerSide
    var point: PawnPoint
    var fencesLeft: Int
}

struct FenceInfo: Codable {
    var exists: Bool
    var canPut: Bool
}

struct Board: Codable {
    var currentTurn: PlayerSide
    var winner: PlayerSide?
    var humanPawn: Pawn
    var aiPawn: Pawn
    var hFences: [FenceInfo]
    var vFences: [FenceInfo]
    var canMoves: [Bool]
}
