"use client"

import axios from 'axios';
import { useState } from 'react';
import { loginFormInputsType } from '@/types/loginFormInputsType';

const Page = () => {
  const [loginFormInputs, setLoginFormInputs] = useState<loginFormInputsType>({
    login: {
      email: '',
      password: '',
    }
  });

  const clickLogin = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    axios.post(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/v1/user/login`, loginFormInputs)
      .then((response) => {
        console.log(response.data);
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
