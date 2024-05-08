"use client"

import { useEffect, useState } from 'react';
import Link from "next/link";
import axios from 'axios';
import { WalkingRouteType } from '../types/models/walkingRouteType'

export default function Home() {
  const [walkingRoutes, setWalkingRoutes] = useState<WalkingRouteType[]>([]);

  const fetchWalkingRoutes = () => {
    axios.get(`${process.env.NEXT_PUBLIC_API_BASE_URL}`)
      .then((_res) => {
        setWalkingRoutes(_res.data);
      })
      .catch((error) => {
        console.error('Error fetching walking routes:', error);
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
