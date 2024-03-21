"use client"

import Link from "next/link";
import { useRouter } from "next/navigation";

export default function Home() {
  const router = useRouter();

  return (
    <>
      <h1>トップページ</h1>
      <Link href='/sample'>サンプルページ</Link>
      <div>
        <button onClick={() => router.push('/sample2')}>サンプルページ2</button>
      </div>
    </>
  );
}
