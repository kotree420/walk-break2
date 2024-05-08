"use client"

import { userInfo } from "@/types/userInfo";
import axios from "axios";
import { useParams } from "next/navigation";
import { useEffect, useState } from "react";

const Page: React.FC = () => {
  const [userInfo, setUserInfo] = useState<userInfo>({
    email: '',
    name: '',
    created_at: ''
  });

  const params = useParams();

  const getTargetUserData = () => {
    axios.get(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/user/${params.id}`)
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

  // TODO: // check_session

  useEffect(() => {
    getTargetUserData()
  }, [])

  return(
    <>
      <h1>プロフィール</h1>
      <p>ユーザー情報</p>
      <div>email: {userInfo.email}</div>
      <div>name: {userInfo.name}</div>
      <div>created_at: {userInfo.created_at}</div>
    </>
  );
}

export default Page;
