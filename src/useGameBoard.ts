import { useSyncExternalStore } from "react";
import { Game } from "./Gen/Game.gen";
import { Board, FencePoint, PawnPoint } from "./Gen/Types.gen";

class ObservableGame extends Game {
  subscribers: (() => void)[] | undefined;

  subscribe(subscriber: () => void): (() => void) {
    this.subscribers = [...(this.subscribers ?? []), subscriber];
    return () => {
      this.subscribers = (this.subscribers ?? []).filter(s => s !== subscriber);
    };
  }

  notify() {
    for (const subscriber of (this.subscribers ?? [])) {
      subscriber();
    }
  }

  cachedBoard: Board | undefined;

  putFence(position: FencePoint): void {
    super.putFence(position);
    this.cachedBoard = super.currentBoard();
    this.notify();
  }

  movePawn(position: PawnPoint): void {
    super.movePawn(position);
    this.cachedBoard = super.currentBoard();
    this.notify();
  }

  aiNext(): void {
    super.aiNext();
    this.cachedBoard = super.currentBoard();
    this.notify();
  }

  currentBoard(): Board {
    if (this.cachedBoard) {
      return this.cachedBoard;
    }
    this.cachedBoard = super.currentBoard();
    return this.cachedBoard;
  }
}

function assumeObservable(game: Game): game is ObservableGame {
  if (!(game instanceof ObservableGame)) {
    Object.setPrototypeOf(game, ObservableGame.prototype);
  }
  return true;
}

export function useGameBoard(game: Game): Board {
  if (!assumeObservable(game)) { throw new Error(); }

  return useSyncExternalStore(
    game.subscribe.bind(game),
    () => game.currentBoard()
  );
}
