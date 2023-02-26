import Algorithms
import Foundation
import QuoridorEngine
import WasmCallableKit

func buildGameMetadata() -> ClassMetadata<Game> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970
    var meta = ClassMetadata<Game>()
    meta.inits.append { _ in
        return Game()
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: FencePoint
        }
        let args = try decoder.decode(Params.self, from: argData)
        let _ = try self.putFence(
            position: args._0
        )
        return Data()
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PawnPoint
        }
        let args = try decoder.decode(Params.self, from: argData)
        let _ = try self.movePawn(
            position: args._0
        )
        return Data()
    }
    meta.methods.append { `self`, _ in
        let _ = self.aiNext()
        return Data()
    }
    meta.methods.append { `self`, _ in
        let ret = try self.currentBoard()
        return try encoder.encode(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: FencePoint
        }
        let args = try decoder.decode(Params.self, from: argData)
        let ret = self.canPutFence(
            position: args._0
        )
        return try encoder.encode(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PawnPoint
        }
        let args = try decoder.decode(Params.self, from: argData)
        let ret = self.canMove(
            position: args._0
        )
        return try encoder.encode(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: FencePoint
        }
        let args = try decoder.decode(Params.self, from: argData)
        let ret = self.existsFence(
            position: args._0
        )
        return try encoder.encode(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PlayerSide
        }
        let args = try decoder.decode(Params.self, from: argData)
        let ret = self.pawnPosition(
            side: args._0
        )
        return try encoder.encode(ret)
    }
    meta.methods.append { `self`, _ in
        let ret = self.winPlayer()
        return try encoder.encode(ret)
    }
    meta.methods.append { `self`, _ in
        let ret = self.currentTurn()
        return try encoder.encode(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PlayerSide
        }
        let args = try decoder.decode(Params.self, from: argData)
        let ret = self.remainingFences(
            side: args._0
        )
        return try encoder.encode(ret)
    }
    return meta
}