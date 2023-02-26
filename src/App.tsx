import React from 'react';
import './App.css';
import { GameArea } from './GameArea';

export const App: React.FC<{}> = () => {
  return <div className="App">
    <h1>
      <code>Swift Quoridor!</code>
    </h1>
    <GameArea/>
    <div className="Description">
      <h2>Quoridor（コリドール）</h2>
      <p>
        ターン制のボードゲームで、自分のコマを相手の陣地（一番上または一番下の行）に到達させると勝利です。
        ターンプレイヤーは以下のどちらかを行えます。
      </p>
      <ul>
        <li>コマを前後左右1マスに動かす。移動先に相手のコマがある場合は、飛び越えることができる。</li>
        <li>板を1枚設置する。板はコマの通行を妨害する。コマがゴールできなくなるように板を設置することはできない。</li>
      </ul>
      <h2>これは何？</h2>
      <p>
        Swiftで作ったコリドールのゲームエンジンをブラウザ上で動かすデモアプリです。
        WebAssemblyによって実現されています。
      </p>
      <p>
        UI部分はReact、AIを含むゲームエンジン部分がSwiftで実装されています。
        SwiftとTypeScript間を型安全にブリッジするために
        <a 
          className="Link"
          href="https://github.com/sidepelican/WasmCallableKit"
          target="_blank"
          rel="noopener noreferrer"
        >
          WasmCallableKit
        </a>
        を使用しています。
      </p>
      <pre style={{ margin: "6px" }}>
        <code>
{`// Swiftクラスを生成
const game = new Game(); 
// 型安全なメソッド呼び出し
game.putFence({ x, y, orientation: "horizontal"});
// 盤面情報の取得
const board = game.currentBoard();
const playerPos = board.humanPawn.point;`}
        </code>
      </pre>
      <hr style={{ marginTop: "3rem" }} />
      <div style={{ textAlign: "end" }}>
        GitHub:
        <a
          className="Link"
          href="https://github.com/sidepelican/SwiftWasmQuoridor"
          target="_blank"
          rel="noopener noreferrer"
        >
          SwiftWasmQuoridor
        </a>
      </div>
    </div>
  </div>;
}
