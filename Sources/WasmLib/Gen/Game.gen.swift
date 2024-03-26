import Algorithms
import QuoridorEngine
import WasmCallableKit

func buildGameMetadata() -> ClassMetadata<Game> {
    var meta = ClassMetadata<Game>()
    meta.inits.append { _ in
        return Game()
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: FencePoint
        }
        let args = try WasmCallableKit.decodeJSON(Params.self, from: argData)
        let _ = try self.putFence(
            position: args._0
        )
        return []
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PawnPoint
        }
        let args = try WasmCallableKit.decodeJSON(Params.self, from: argData)
        let _ = try self.movePawn(
            position: args._0
        )
        return []
    }
    meta.methods.append { `self`, _ in
        let _ = self.aiNext()
        return []
    }
    meta.methods.append { `self`, _ in
        let ret = try self.currentBoard()
        return try WasmCallableKit.encodeJSON(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: FencePoint
        }
        let args = try WasmCallableKit.decodeJSON(Params.self, from: argData)
        let ret = self.canPutFence(
            position: args._0
        )
        return try WasmCallableKit.encodeJSON(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PawnPoint
        }
        let args = try WasmCallableKit.decodeJSON(Params.self, from: argData)
        let ret = self.canMove(
            position: args._0
        )
        return try WasmCallableKit.encodeJSON(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: FencePoint
        }
        let args = try WasmCallableKit.decodeJSON(Params.self, from: argData)
        let ret = self.existsFence(
            position: args._0
        )
        return try WasmCallableKit.encodeJSON(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PlayerSide
        }
        let args = try WasmCallableKit.decodeJSON(Params.self, from: argData)
        let ret = self.pawnPosition(
            side: args._0
        )
        return try WasmCallableKit.encodeJSON(ret)
    }
    meta.methods.append { `self`, _ in
        let ret = self.winPlayer()
        return try WasmCallableKit.encodeJSON(ret)
    }
    meta.methods.append { `self`, _ in
        let ret = self.currentTurn()
        return try WasmCallableKit.encodeJSON(ret)
    }
    meta.methods.append { `self`, argData in
        struct Params: Decodable {
            var _0: PlayerSide
        }
        let args = try WasmCallableKit.decodeJSON(Params.self, from: argData)
        let ret = self.remainingFences(
            side: args._0
        )
        return try WasmCallableKit.encodeJSON(ret)
    }
    return meta
}