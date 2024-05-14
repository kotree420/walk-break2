"use client"

import Profile from "../components/Profile";
import axios from "axios";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { UserInfo } from "@/types/userInfo";
import { useRouter } from "next/navigation";
import Link from "next/link";

const Page: React.FC = () => {
  const [userInfo, setUserInfo] = useState<UserInfo>({
    email: '',
    name: '',
    created_at: ''
  });

  const [isLoggedIn, setIsLoggedIn] = useState(false);

  const params = useParams();
  const router = useRouter();

  const loggedIn = () => {
    axios.get(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/user/logged_in?`,{
      withCredentials: true
    })
      .then((response) => {
        response.data.user && setIsLoggedIn(true);
      })
      .catch((error) => {
        console.error(error);
      })
  }

  const getTargetUserData = () => {
    // TODO: withCredentialsオプションは共通設定にする
    axios.get(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/user/${params.id}`,{
      withCredentials: true
    })
      .then((response) => {
        setUserInfo({
          email: response.data.email,
          name: response.data.name,
          created_at: response.data.created_at,
        });
      })
      .catch((error) => {
        console.error(error);
      })
  }

  const clickLogout = () => {
    axios.delete(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/user/logout`,{
      withCredentials: true
    })
      .then(() => {
        setIsLoggedIn(false);
        router.push(`../login`);
      })
      .catch((error) => {
        console.error(error);
      })
  }

  useEffect(() => {
    loggedIn();
  }, [])

  useEffect(() => {
    getTargetUserData()
  }, [])

  return(
    <>
      { isLoggedIn
      ? <button onClick={clickLogout}>ログアウト</button>
      : <Link href="/login">ログイン</Link>
    }
      <h1>プロフィール</h1>
      <p>ユーザー情報</p>
      <Profile email={userInfo.email} name={userInfo.name} created_at={userInfo.created_at} />
    </>
  );
}

export default Page;
