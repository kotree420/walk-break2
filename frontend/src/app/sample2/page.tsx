"use client"

import { usePathname } from "next/navigation";
import Link from "next/link";

const Sample2: React.FC = () => {
  const pathName = usePathname();

  return (
    <>
      <h1>サンプルページ2</h1>
      <p>current_path → { pathName }</p>
      <Link href="/">トップページ</Link>
    </>
  );
}

export default Sample2;
