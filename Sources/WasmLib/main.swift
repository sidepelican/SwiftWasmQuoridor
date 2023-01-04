import WasmCallableKit

WasmCallableKit.setFunctionList(WasmLib.functionList)
WasmCallableKit.registerClassMetadata(meta: [
    GameRuntime.buildMetadata(),
])
