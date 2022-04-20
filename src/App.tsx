import React from 'react';
import './App.css';
import { GameArea } from './GameArea';
export const App: React.VFC<{}> = () => {
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
        Swiftで作ったコリドールのゲームエンジンをWasmビルドしてブラウザで動くようにしたものです。
      </p>
      <p>
        UIはJSです。Swiftではゲームエンジン部分とAIが動いてます。
      </p>
      <hr style={{ marginTop: "3rem" }} />
      <div style={{ textAlign: "end" }}>
        Twitter:
        <a
          className="TwitterLink"
          href="https://twitter.com/iceman5499"
          target="_blank"
          rel="noopener noreferrer"
        >
          @iceman5499
        </a>
      </div>
    </div>
  </div>;
}
