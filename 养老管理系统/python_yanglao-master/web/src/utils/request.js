import axios from 'axios';
import { BASE_URL, ADMIN_USER_TOKEN, USER_TOKEN } from '/@/store/constants';

// 创建axios实例
const service = axios.create({
  baseURL: BASE_URL,
  timeout: 15000,
});

// 请求拦截器
service.interceptors.request.use(
  (config) => {
    // 添加token到请求头
    config.headers.ADMINTOKEN = localStorage.getItem(ADMIN_USER_TOKEN);
    config.headers.TOKEN = localStorage.getItem(USER_TOKEN);
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// 响应拦截器
service.interceptors.response.use(
  (response) => {
    if (response.status === 200) {
      if (response.data.code === 0 || response.data.code === 200) {
        return response.data;
      } else {
        return Promise.reject(response.data);
      }
    } else {
      return Promise.reject(response.data);
    }
  },
  (error) => {
    console.log('Request error:', error.response?.status);
    if (error.response?.status === 404) {
      // 处理404错误
    } else if (error.response?.status === 403) {
      // 处理403错误
    }
    return Promise.reject(error);
  }
);

// 导出request函数
export function request(config) {
  return service(config);
}

export default service;
