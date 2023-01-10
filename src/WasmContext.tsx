import React, { useContext, useEffect, useState } from "react";
import { WASI } from "@wasmer/wasi";
import wasiBindings from "@wasmer/wasi/lib/bindings/browser";
import { WasmFs } from "@wasmer/wasmfs";
import { SwiftRuntime } from "./Gen/SwiftRuntime.gen";
import { bindWasmLib, WasmLibExports } from "./Gen/global.gen";

const wasmFs = new WasmFs();
// @ts-ignore
wasmFs.fs.writeSync = (fd, buffer, _, __, ___): number => {
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

  const { instance } = await WebAssembly.instantiateStreaming(fetch("./WasmLib.wasm"), {
    wasi_snapshot_preview1: wasi.wasiImport,
    ...swift.callableKitImports,
  });
  swift.setInstance(instance);
  const { memory, _initialize, main } = instance.exports as any;
  wasi.setMemory(memory);
  _initialize();
  main();
  
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
