import { SwiftRuntime, globalRuntime } from "./SwiftRuntime.gen.js";
import {
    Board,
    FencePoint,
    PawnPoint,
    PlayerSide
} from "./Types.gen.js";

export class Game {
    #runtime: SwiftRuntime;
    #id: number;

    constructor(runtime?: SwiftRuntime) {
        this.#runtime = runtime ?? globalRuntime;
        this.#id = this.#runtime.classInit(0, 0, {});
        this.#runtime.autorelease(this, this.#id);
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

    canPutFence(position: FencePoint): boolean {
        return this.#runtime.classSend(this.#id, 4, {
            _0: position
        }) as boolean;
    }

    canMove(position: PawnPoint): boolean {
        return this.#runtime.classSend(this.#id, 5, {
            _0: position
        }) as boolean;
    }

    existsFence(position: FencePoint): boolean {
        return this.#runtime.classSend(this.#id, 6, {
            _0: position
        }) as boolean;
    }

    pawnPosition(side: PlayerSide): PawnPoint {
        return this.#runtime.classSend(this.#id, 7, {
            _0: side
        }) as PawnPoint;
    }

    winPlayer(): PlayerSide | null {
        return this.#runtime.classSend(this.#id, 8, {}) as PlayerSide | null as PlayerSide | null;
    }

    currentTurn(): PlayerSide {
        return this.#runtime.classSend(this.#id, 9, {}) as PlayerSide;
    }

    remainingFences(side: PlayerSide): number {
        return this.#runtime.classSend(this.#id, 10, {
            _0: side
        }) as number;
    }
}
