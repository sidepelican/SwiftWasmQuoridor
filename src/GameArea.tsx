import { ChangeEventHandler, ReactNode, useCallback, useEffect, useState } from "react";
import { Board } from "./Board";
import { LegacyBoard } from "./LegacyBoard";
import { Game } from "./Gen/Game.gen";
import { useWasmExports } from "./WasmContext";

export const GameArea: React.FC<{}> = () => {
  const wasmReady = useWasmExports() != null;

  const [useLegacy, setUseLegacy] = useState(false);
  const onChangeUseLegacy: ChangeEventHandler<HTMLInputElement> = (e) => {
    setUseLegacy(e.currentTarget.checked);
  };

  const [game, setGame] = useState<Game | null>(null);
  const onReset = () => {
    setGame(null);
  };

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
    if (useLegacy) {
      content = <LegacyBoard game={game}/>
    } else {
      content = <Board game={game} />
    }
  }

  return <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-end" }}>
    {content}
    <div style={{ display: "flex", flexDirection: "row", alignItems: "flex-end" }}>
      <input type="checkbox" id="use_legacy" onChange={onChangeUseLegacy}/>
      <label htmlFor="use_legacy" style={{ whiteSpace: "nowrap" }}>Use Legacy</label>
      <button style={{ 
          width: "fit-content",
          marginLeft: "1rem",
          marginRight: "6rem",
        }}
        onClick={onReset}
      >
        Reset
      </button>
    </div>
  </div>
}
