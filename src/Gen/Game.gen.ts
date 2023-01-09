import { SwiftRuntime, globalRuntime } from "./SwiftRuntime.gen.js";
import { Board, FencePoint, PawnPoint } from "./WasmExports.gen.js";

export class Game {
    #runtime: SwiftRuntime;
    #id: number;

    constructor(runtime?: SwiftRuntime) {
        this.#runtime = runtime ?? globalRuntime;
        this.#id = this.#runtime.classInit(0, 0, {});
    }

    putFence(position: FencePoint): void {
        return this.#runtime.classSend(this.#id, 0, {
            _0: position
        }) as void;
    }

    movePawn(position: PawnPoint): void {
        return this.#runtime.classSend(this.#id, 1, {
            _0: position
        }) as void;
    }

    aiNext(): void {
        return this.#runtime.classSend(this.#id, 2, {}) as void;
    }

    currentBoard(): Board {
        return this.#runtime.classSend(this.#id, 3, {}) as Board;
    }
}
