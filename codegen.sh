#!/bin/sh -ex

ROOT=`pwd`

swift package resolve
cd .build/checkouts/WasmCallableKit/Codegen
swift run Codegen "$ROOT/Sources/WasmLib/WasmExports.swift" --swift_out "$ROOT/Sources/WasmLib/Gen" --ts_out "$ROOT/src/Gen"
