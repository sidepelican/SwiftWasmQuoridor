import { TagRecord } from "./common.gen.js";

export type FenceOrientation = "horizontal" | "vertical";

export type FencePoint = {
    x: number;
    y: number;
    orientation: FenceOrientation;
} & TagRecord<"FencePoint">;

export type PawnPoint = {
    x: number;
    y: number;
} & TagRecord<"PawnPoint">;

export type PlayerSide = "ai" | "human";

export type Pawn = {
    side: PlayerSide;
    point: PawnPoint;
    fencesLeft: number;
} & TagRecord<"Pawn">;

export type FenceInfo = {
    exists: boolean;
    canPut: boolean;
} & TagRecord<"FenceInfo">;

export type Board = {
    currentTurn: PlayerSide;
    winner?: PlayerSide;
    humanPawn: Pawn;
    aiPawn: Pawn;
    hFences: FenceInfo[];
    vFences: FenceInfo[];
    canMoves: boolean[];
} & TagRecord<"Board">;
