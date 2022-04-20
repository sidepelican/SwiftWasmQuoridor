import Foundation

private let emptyReturnData = Data("{}".utf8)

private struct putFenceArguments: Decodable {
    var _0: GameID
    var _1: FencePoint
}

private struct movePawnArguments: Decodable {
    var _0: GameID
    var _1: PawnPoint
}

private struct aiNextArguments: Decodable {
    var _0: GameID
}

private struct currentBoardArguments: Decodable {
    var _0: GameID
}

private struct deleteGameArguments: Decodable {
    var _0: GameID
}

private func makeFunctionList<T: WasmExports>(wasmExports: T.Type) -> [(Data) throws -> Data] {
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var ret: [(Data) throws -> Data] = []
    ret.append { (arg: Data) in
        
        let b = T.newGame(

        )
        return try encoder.encode(b)
    }
    ret.append { (arg: Data) in
        let a = try decoder.decode(putFenceArguments.self, from: arg)
        try T.putFence(
            game: a._0,
            position: a._1
        )
        return emptyReturnData
    }
    ret.append { (arg: Data) in
        let a = try decoder.decode(movePawnArguments.self, from: arg)
        try T.movePawn(
            game: a._0,
            command: a._1
        )
        return emptyReturnData
    }
    ret.append { (arg: Data) in
        let a = try decoder.decode(aiNextArguments.self, from: arg)
        try T.aiNext(
            game: a._0
        )
        return emptyReturnData
    }
    ret.append { (arg: Data) in
        let a = try decoder.decode(currentBoardArguments.self, from: arg)
        let b = try T.currentBoard(
            game: a._0
        )
        return try encoder.encode(b)
    }
    ret.append { (arg: Data) in
        let a = try decoder.decode(deleteGameArguments.self, from: arg)
        T.deleteGame(
            game: a._0
        )
        return emptyReturnData
    }
    return ret
}

extension WasmExports {
    static var functionList: [(Data) throws -> Data] {
        makeFunctionList(wasmExports: Self.self)
    }
}