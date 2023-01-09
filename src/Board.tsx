import React, { useCallback, useEffect, useState } from 'react';
import './Board.css';
import { Game } from './Gen/Game.gen';
import { FenceOrientation } from './Gen/WasmExports.gen';

const possibleFences: { x: number, y: number, o: FenceOrientation }[] =
  [...Array(8)].flatMap((_, i) => {
    const x = i + 1;
    return [...Array(8)].flatMap((_, i) => {
      const y = i + 1;
      return [
        { x: x, y: y, o: "horizontal" },
        { x: x, y: y, o: "vertical" },
      ]
    });
  });

export const Board: React.VFC<{
  game: Game,
}> = ({ game }) => {
  const [, setCount] = useState(0);
  const step = useCallback(() => {
    setCount(v => v + 1);
  }, []);

  const board = game.currentBoard();

  const aiTurn = board.currentTurn === "ai";
  useEffect(() => {
    if (aiTurn) {
      setTimeout(() => {
        game.aiNext();
        step();
      }, 50);
    }
  }, [aiTurn, game, step]);

  const cpuPos = board.aiPawn.point;
  const playerPos = board.humanPawn.point;
  const cpuFencesLeft = board.aiPawn.fencesLeft;
  const playerFencesLeft = board.humanPawn.fencesLeft;
  const cpuWin = board.winner === "ai";
  const playerWin = board.winner === "human";

  return <div className="Board" style={{ position: "relative" }}>
    <div style={{
      display: "flex", flexDirection: "column",
      position: "absolute", top: "65px", left: "15px",
    }}>
      {[...Array(9)].map((_, y) =>
        <div style={{ display: "flex", flexDirection: "row" }} key={y}>
          {[...Array(9)].map((_, x) => {
            const canMove = board.canMoves[x * 9 + y];
            let onClick = undefined;
            if (canMove) {
              onClick = () => { game.movePawn({ x, y }); step(); };
            }
            return <Tile key={x} canMove={canMove} onClick={onClick} />;
          })}
        </div>
      )}
    </div>
    <div>
      <Pawn isPlayer={false} top={cpuPos.y * 50 + 65} left={Math.floor(cpuPos.x) * 50 + 15} />
      <Pawn isPlayer={true} top={playerPos.y * 50 + 65} left={Math.floor(playerPos.x) * 50 + 15} />
    </div>
    <div>
      {possibleFences.map(({ x, y, o }) => {
        let placed: boolean;
        let canPlace: boolean;
        let top, left: number;
        switch (o) {
          case "horizontal":
            placed = board.hFences[(x-1) * 8 + (y-1)].exists;
            canPlace = board.hFences[(x-1) * 8 + (y-1)].canPut;
            left = (x - 1) * 50;
            top = y * 50;
            break;
          case "vertical":
            placed = board.vFences[(x-1) * 8 + (y-1)].exists;
            canPlace = board.vFences[(x-1) * 8 + (y-1)].canPut;
            left = x * 50 - 10;
            top = (y - 1) * 50 + 10;
            break;
        }
        top += 60; left += 20;
        let onClick = undefined;
        if (canPlace) {
          onClick = () => { game.putFence({ x, y, orientation: o}); step(); };
        }
        return <Fence key={`${x}_${y}_${o}`} orientation={o} canPlace={canPlace} placed={placed} top={top} left={left} onClick={onClick} />;
      })}
    </div>
    <div>
      {[...Array(cpuFencesLeft)].map((_, i) => {
        return <MiniFence key={i} top={10} left={i * 15 + 10} />;
      })}
      {[...Array(playerFencesLeft)].map((_, i) => {
        return <MiniFence key={i} top={540} left={i * 15 + 10} />;
      })}
    </div>
    <div style={{ position: "absolute", top: 0, right: 0 }}>
      {aiTurn && (board.winner == null) ? <p>AI thinking...</p> : null}
      {!aiTurn && (board.winner == null) ? <p>Your turn</p> : null}
    </div>
    <div style={{ position: "absolute", bottom: 0, right: 0 }}>
      {playerWin ? <p>You Win</p> : null}
      {cpuWin ? <p>You Lose</p> : null}
    </div>
  </div>;
}

const Tile: React.VFC<{
  canMove: boolean,
  onClick?: () => void,
}> = (props) => {
  return <div
    className={
      "TileView"
      + (props.canMove ? " canMove" : "")
    }
    onClick={props.onClick}
  />;
}

const Pawn: React.VFC<{
  isPlayer: boolean,
  top: number, left: number
}> = (props) => {
  return <div
    className={
      "PawnView"
      + (props.isPlayer ? " isPlayer" : "")
    }
    style={{
      position: "absolute",
      top: props.top,
      left: props.left,
    }} />;
}

const Fence: React.VFC<{
  orientation: FenceOrientation,
  canPlace: boolean,
  placed: boolean,
  onClick?: () => void,
  top: number, left: number
}> = (props) => {
  return <div
    className={
      `FenceView ${props.orientation}`
      + (props.canPlace ? " canPlace" : "")
      + (props.placed ? " placed" : "")
    }
    style={{
      position: "absolute",
      top: props.top,
      left: props.left,
    }}
    onClick={props.onClick}
  />;
}

const MiniFence: React.VFC<{
  top: number, left: number
}> = (props) => {
  return <div
    className="MiniFenceView"
    style={{
      position: "absolute",
      top: props.top,
      left: props.left,
    }}
  />;
}
