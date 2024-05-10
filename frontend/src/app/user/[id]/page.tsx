"use client"

import axios from "axios";
import { useParams } from "next/navigation";
import { useEffect, useState } from "react";
import { UserInfo } from "@/types/userInfo";
import Profile from "../components/Profile";

const Page: React.FC<{ id: string }> = ({ id }) => {
  // fetchを使ってServer Componentにする
  const [userInfo, setUserInfo] = useState<UserInfo>({
    email: '',
    name: '',
    created_at: ''
  });

  const params = useParams();

  const getTargetUserData = () => {
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

  useEffect(() => {
    getTargetUserData()
  }, [])

  return(
    <>
      <h1>プロフィール</h1>
      <p>ユーザー情報</p>
      <Profile email={userInfo.email} name={userInfo.name} created_at={userInfo.created_at}/>
    </>
  );
}

export default Page;
