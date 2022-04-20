import { ReactNode, useCallback, useEffect, useState } from "react";
import { Board } from "./Board";
import { GameID } from "./Gen/WasmLibExports";
import { useWasmExports } from "./WasmContext";

export const GameArea: React.VFC<{}> = () => {
  const wasm = useWasmExports();
  const [game, setGame] = useState<GameID | undefined>(undefined);
  const onReset = useCallback(() => {
    if (game != null && wasm != null) {
      wasm.deleteGame(game);
      setGame(undefined);
    }
  }, [game, wasm]);

  useEffect(() => {
    if (game == null && wasm != null) {
      setGame(wasm.newGame());
    }
  }, [game, wasm]);

  let content: ReactNode;
  if (wasm == null) {
    content = <div className="Board" style={{ display: "flex", flexDirection: "column", justifyContent: "center" }}>
      <p>Loading <code>.wasm</code> binary ...</p>
    </div>
  } else if (game == null) {
    content = <div className="Board" style={{ display: "flex", flexDirection: "column", justifyContent: "center" }}>
      <p>Starting game ...</p>
    </div>
  } else {
    content = <Board game={game} wasm={wasm} />
  }

  return <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end" }}>
    {content}
    <button style={{ width: "fit-content" }} onClick={onReset}>
      Reset
    </button>
  </div>
}
