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

public enum FenceOrientation: String, Codable {
    case horizontal
    case vertical
}

public struct FencePoint: Codable {
    public var x: Int
    public var y: Int
    public var orientation: FenceOrientation
}

public struct PawnPoint: Codable {
    public var x: Int
    public var y: Int
}

public enum PlayerSide: String, Codable {
    case ai
    case human
}

public struct Pawn: Codable {
    public var side: PlayerSide
    public var point: PawnPoint
    public var fencesLeft: Int
}

public struct FenceInfo: Codable {
    public var exists: Bool
    public var canPut: Bool
}

public struct Board: Codable {
    public var currentTurn: PlayerSide
    public var winner: PlayerSide?
    public var humanPawn: Pawn
    public var aiPawn: Pawn
    public var hFences: [FenceInfo]
    public var vFences: [FenceInfo]
    public var canMoves: [Bool]
}

