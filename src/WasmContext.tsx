import React, { useContext, useEffect, useState } from "react";
import { WASI } from "@wasmer/wasi";
import wasiBindings from "@wasmer/wasi/lib/bindings/browser";
import { WasmFs } from "@wasmer/wasmfs";
import { SwiftRuntime } from "./Gen/SwiftRuntime";
import { bindWasmLib, WasmLibExports } from "./Gen/WasmLibExports";

const wasmFs = new WasmFs();
// @ts-ignore
wasmFs.fs.writeSync = (fd, buffer, _, _, _): number => {
  const text = new TextDecoder("utf-8").decode(buffer);
  if (text !== "\n") {
    switch (fd) {
      case 1:
        console.log(text);
        break;
      case 2:
        console.error(text);
        break;
    }
  }
  return buffer.length;
};

let wasi = new WASI({
  args: [],
  env: {},
  bindings: {
    ...wasiBindings,
    fs: wasmFs.fs
  }
});

const startWasiTask = async () => {
  const swift = new SwiftRuntime();

  let module = await WebAssembly.compileStreaming(fetch("./WasmLib.wasm"));
  let instance = await WebAssembly.instantiate(module, {
    ...wasi.getImports(module),
    ...swift.callableKitImports,
  });
  swift.setInstance(instance);
  wasi.start(instance);

  return bindWasmLib(swift);
};

const WasmContext = React.createContext<WasmLibExports | null>(null);

export const WasmProvider: React.FC<{}> = (props) => {
  const [exports, setExports] = useState<WasmLibExports>();
  useEffect(() => {
    startWasiTask().then(setExports);
  }, []);

  if (exports == null) {
    return <>{props.children}</>;
  }

  return <WasmContext.Provider value={exports}>
    {props.children}
  </WasmContext.Provider>;
};

export const useWasmExports = (): WasmLibExports | null => {
  return useContext(WasmContext);
}
