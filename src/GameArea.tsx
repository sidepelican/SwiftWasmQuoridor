import { ReactNode, useCallback, useEffect, useState } from "react";
import { Board } from "./Board";
import { Game } from "./Gen/Game";
import { useWasmExports } from "./WasmContext";

export const GameArea: React.VFC<{}> = () => {
  const wasmReady = useWasmExports() != null;

  const [game, setGame] = useState<Game | null>(null);
  const onReset = useCallback(() => {
    game?.release();
    setGame(null);
  }, [game, wasmReady]);

  useEffect(() => {
    if (game == null && wasmReady) {
      console.log("start new game");
      setGame(new Game());
    }
  }, [game, wasmReady]);

  let content: ReactNode;
  if (!wasmReady) {
    content = <div className="Board" style={{ display: "flex", flexDirection: "column", justifyContent: "center" }}>
      <p>Loading <code>.wasm</code> binary ...</p>
    </div>
  } else if (game == null) {
    content = <div className="Board" style={{ display: "flex", flexDirection: "column", justifyContent: "center" }}>
      <p>Starting game ...</p>
    </div>
  } else {
    content = <Board game={game} />
  }

  return <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end" }}>
    {content}
    <button style={{ width: "fit-content" }} onClick={onReset}>
      Reset
    </button>
  </div>
}
