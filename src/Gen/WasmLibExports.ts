type PartialSwiftRuntime = {
  callSwiftFunction(functionID: number, argument: any): any
}

export type WasmLibExports = {
  newGame: () => GameID,
  putFence: (game: GameID, position: FencePoint) => void,
  movePawn: (game: GameID, command: PawnPoint) => void,
  aiNext: (game: GameID) => void,
  currentBoard: (game: GameID) => Board,
  deleteGame: (game: GameID) => void,
};

export const bindWasmLib = (swift: PartialSwiftRuntime): WasmLibExports => {
  return {
    newGame: (): GameID => swift.callSwiftFunction(0, {

    }),
    putFence: (game: GameID, position: FencePoint): void => swift.callSwiftFunction(1, {
      _0: game,
      _1: position,
    }),
    movePawn: (game: GameID, command: PawnPoint): void => swift.callSwiftFunction(2, {
      _0: game,
      _1: command,
    }),
    aiNext: (game: GameID): void => swift.callSwiftFunction(3, {
      _0: game,
    }),
    currentBoard: (game: GameID): Board => swift.callSwiftFunction(4, {
      _0: game,
    }),
    deleteGame: (game: GameID): void => swift.callSwiftFunction(5, {
      _0: game,
    }),
  };
};

export type GameID = {
    raw: number;
};

export type FenceOrientation = "horizontal" |
"vertical";

export type FencePoint = {
    x: number;
    y: number;
    orientation: FenceOrientation;
};

export type PawnPoint = {
    x: number;
    y: number;
};

export type PlayerSide = "ai" |
"human";

export type Pawn = {
    side: PlayerSide;
    point: PawnPoint;
    fencesLeft: number;
};

export type FenceInfo = {
    exists: boolean;
    canPut: boolean;
};

export type Board = {
    currentTurn: PlayerSide;
    winner?: PlayerSide;
    humanPawn: Pawn;
    aiPawn: Pawn;
    hFences: FenceInfo[];
    vFences: FenceInfo[];
    canMoves: boolean[];
};