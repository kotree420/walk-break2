"use client"

import styles from './style.module.css'
import { usePathname } from "next/navigation";
import Link from "next/link";

const Sample: React.FC = () => {
  const pathName = usePathname();

  return (
    <>
      <h1>サンプルページ</h1>
      <div className="bg-red-100">tailwindCSSサンプル</div>
      <div className={styles.sample}>current_path → { pathName }</div>
      <Link href="/">トップページ</Link>
    </>
  );
}

export default Sample;
