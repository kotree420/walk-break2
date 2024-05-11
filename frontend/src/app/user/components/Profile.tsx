"use client"

import { UserInfo } from "@/types/userInfo";

const Profile: React.FC<UserInfo> = ({ email, name, created_at}) => {

  return(
    <>
      <div>email: {email}</div>
      <div>name: {name}</div>
      <div>created_at: {created_at}</div>
    </>
  );
}

export default Profile;
