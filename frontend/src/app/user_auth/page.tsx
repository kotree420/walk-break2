"use client"

import axios from 'axios';
import { useEffect } from 'react';

const Page = () => {

  const fetchSessions = () => {
    axios.post(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/user/sessions`, {
      email: 'test'
    })
      .then((_res) => {
        console.log(_res);
      })
      .catch((error) => {
        console.error('Error fetchSessions', error);
      })
  }

  useEffect(() => {
    fetchSessions();
  }, [])
  return(
    <>
      <h1>ログインページ</h1>
    </>
  );
}

export default Page;
