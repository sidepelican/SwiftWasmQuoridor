import Foundation
import WasmCallableKit

private let emptyReturnData = Data("{}".utf8)

enum GameRuntime {
    static func buildMetadata() -> ClassMetadata<Game> {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        var meta = ClassMetadata<Game>()
        meta.inits.append { argData in
            return Game()
        }
        meta.methods.append { `self`, argData in
            let arg = try decoder.decode(FencePoint.self, from: argData)
            try self.putFence(position: arg)
            return emptyReturnData
        }
        meta.methods.append { `self`, argData in
            let arg = try decoder.decode(PawnPoint.self, from: argData)
            try self.movePawn(position: arg)
            return emptyReturnData
        }
        meta.methods.append { `self`, argData in
            self.aiNext()
            return emptyReturnData
        }
        meta.methods.append { `self`, argData in
            let res = try self.currentBoard()
            return try encoder.encode(res)
        }
        return meta
    }
}
