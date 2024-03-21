"use client"

import { useState } from "react";

/*
型定義をする要素
・コンポーネント
・state
・関数
*/

const useSample = () => {
  const [ state, setState ] = useState(0);

  const sampleFunc = () => {
    setState((prev) => ++prev)
  }

  return {
    state,
    sampleFunc
  }
}

export default useSample;
