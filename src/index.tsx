import React from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import { App } from './App';
import { WasmProvider } from './WasmContext';

const root = createRoot(document.getElementById('root')!);
root.render(
  <React.StrictMode>
    <WasmProvider>
      <App />
    </WasmProvider>
  </React.StrictMode>
);
