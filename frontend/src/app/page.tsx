"use client"

import { useEffect, useState } from 'react';
import Link from "next/link";
import axios from 'axios';

// TODO:型定義はmodelsにまとめる
type WalkingRouteType = {
  id: number,
  name: string,
  user: {
    id: number,
    name: string
  }
}

export default function Home() {
  const [walkingRoutes, setWalkingRoutes] = useState<WalkingRouteType[]>([]);

  const fetchWalkingRoutes = () => {
    // TODO:ドメインベタ書き修正する
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
      <h2>ルート一覧</h2>
      <div>
        {walkingRoutes.map((walkingRoute) => {
          return (
            <ul key={walkingRoute.id}>
              <li>ユーザー名：{walkingRoute.user.name}</li>
              <li>ルート名：{walkingRoute.name}</li>
            </ul>
          )
        })}
      </div>
    </>
  );
}
