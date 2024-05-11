"use client"

import axios from 'axios';
import { useState } from 'react';
import { LoginFormInputsType } from '@/types/loginFormInputsType';
import { useRouter } from 'next/navigation';

const Page: React.FC = () => {
  const [loginFormInputs, setLoginFormInputs] = useState<LoginFormInputsType>({
    login: {
      email: '',
      password: '',
    }
  });

  const router = useRouter();

  const clickLogin = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    axios.post(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/user/login`, loginFormInputs,
      { withCredentials: true }
    )
      .then((response) => {
        router.push(`../user/${response.data.id}`);
      })
      .catch((error) => {
        console.log(error);
      })
  }

  const changeName = (event: React.ChangeEvent<HTMLInputElement>) => {
    setLoginFormInputs(
      {login: { email: event.target.value, password: loginFormInputs.login.password }}
    )
  };

  const changePassword = (event: React.ChangeEvent<HTMLInputElement>) => {
    setLoginFormInputs(
      {login: { email: loginFormInputs.login.email, password: event.target.value }}
    )
  };

  return(
    <>
      <h1>ログインページ</h1>
      <form onSubmit={clickLogin}>
        <div>
          <label htmlFor="login-email">email</label>
          <input
            type="email"
            id='login-email'
            value={loginFormInputs.login.email}
            onChange={changeName}
          />
        </div>
        <div>
          <label htmlFor="login-password">password</label>
          <input
            type="password"
            id='login-password'
            value={loginFormInputs.login.password}
            onChange={changePassword}
          />
        </div>
        <button>ログイン</button>
      </form>
    </>
  );
}

export default Page;
