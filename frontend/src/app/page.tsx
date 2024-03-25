"use client"

import { useEffect, useState } from 'react';
import Link from "next/link";
import axios from 'axios';

/*
axiosかfetchか
型定義する
*/

// あとでmodelsにまとめる
type WalkingRouteType = {
  id: number,
  name: string
}

export default function Home() {
  const [walkingRoutes, setWalkingRoutes] = useState<WalkingRouteType[]>([]);

  const fetchWalkingRoutes = () => {
    // URL、名前解決設定したい
    axios.get('http://127.0.0.1:3002/')
      .then((_res) => {
        console.log(_res.data);
        setWalkingRoutes(_res.data);
      })
      .catch((error) => {
        console.log(error);
      })
  }

  useEffect(() => {
    fetchWalkingRoutes();
  }, [])

  return (
    <>
      <h1>トップページ</h1>
      <Link href='/sample'>サンプルページ</Link>
      <div>
      <Link href='/sample2'>サンプルページ2</Link>
      </div>
      <div>
        {walkingRoutes.map((walkingRoute) => {
          return (
            <li key={walkingRoute.id}>ルート名：{walkingRoute.name}</li>
          )
        })}
      </div>
    </>
  );
}
