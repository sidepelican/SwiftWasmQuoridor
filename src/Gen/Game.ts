import { globalRuntime, SwiftRuntime } from "./SwiftRuntime";
import { Board, FencePoint, PawnPoint } from "./WasmLibExports";

export class Game {
  #runtime: SwiftRuntime
  #id: number
  constructor(runtime: SwiftRuntime = globalRuntime) {
    this.#runtime = runtime;
    this.#id = runtime.classInit(0, 0, {});
  }
  
  putFence(position: FencePoint) {
    this.#runtime.classSend(this.#id, 0, position);
  }

  movePawn(position: PawnPoint) {
    this.#runtime.classSend(this.#id, 1, position);
  }

  aiNext() {
    this.#runtime.classSend(this.#id, 2, {});
  }

  currentBoard(): Board {
    return this.#runtime.classSend(this.#id, 3, {}) as Board;
  }

  release() {
    // TODO: 
  }
}
