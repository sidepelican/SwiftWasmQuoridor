import WasmCallableKit

extension WasmCallableKit {
    static func install() {
        
        registerClassMetadata(meta: [
            buildGameMetadata(),
        ])
    }
}