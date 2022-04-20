import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import { App } from './App';
import { WasmProvider } from './WasmContext';

ReactDOM.render(
  <React.StrictMode>
    <WasmProvider>
      <App />
    </WasmProvider>
  </React.StrictMode>,
  document.getElementById('root')
);
