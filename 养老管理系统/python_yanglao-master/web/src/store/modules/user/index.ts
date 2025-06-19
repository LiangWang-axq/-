import { defineStore } from 'pinia';
import {loginApi as adminLogin} from '/@/api/user';
import { setToken, clearToken } from '/@/utils/auth';
import { UserState } from './types';
import {USER_ID, USER_NAME, USER_TOKEN, ADMIN_USER_ID,ADMIN_USER_NAME,ADMIN_USER_TOKEN} from "/@/store/constants";

export const useUserStore = defineStore('user', {
  state: (): UserState => ({
    user_id: undefined,
    user_name: undefined,
    user_token: undefined,

    admin_user_id: undefined,
    admin_user_name: undefined,
    admin_user_token: undefined,
    admin_user_role: undefined,
    admin_user_nickname: undefined,
  }),
  getters: {},
  actions: {

    // 管理员登录
    async adminLogin(loginForm) {
      const result = await adminLogin(loginForm);
      console.log('result==>', result)

      if(result.code === 0) {
        console.log('登录成功，用户数据:', result.data);

        this.$patch((state)=>{
          state.admin_user_id = result.data.id
          state.admin_user_name = result.data.username
          state.admin_user_token = result.data.admin_token
          state.admin_user_role = result.data.role
          state.admin_user_nickname = result.data.nickname
          console.log('更新后的state==>', state)
        })

        localStorage.setItem(ADMIN_USER_TOKEN, result.data.admin_token)
        localStorage.setItem(ADMIN_USER_NAME, result.data.username)
        localStorage.setItem(ADMIN_USER_ID, result.data.id)
        localStorage.setItem('ADMIN_USER_ROLE', result.data.role || '0')
        localStorage.setItem('ADMIN_USER_NICKNAME', result.data.nickname || '')

        console.log('保存到localStorage的角色:', result.data.role);
      }

      return result;
    },
    // 管理员登出
    async adminLogout() {
      // await userLogout();
      this.$patch((state)=>{
        localStorage.removeItem(ADMIN_USER_ID)
        localStorage.removeItem(ADMIN_USER_NAME)
        localStorage.removeItem(ADMIN_USER_TOKEN)
        localStorage.removeItem('ADMIN_USER_ROLE')
        localStorage.removeItem('ADMIN_USER_NICKNAME')

        state.admin_user_id = undefined
        state.admin_user_name = undefined
        state.admin_user_token = undefined
        state.admin_user_role = undefined
        state.admin_user_nickname = undefined
      })
    },
  },
});
