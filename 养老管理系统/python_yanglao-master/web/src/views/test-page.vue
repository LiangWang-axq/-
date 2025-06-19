<template>
  <div style="padding: 20px;">
    <h1>系统测试页面</h1>
    
    <a-card title="用户信息" style="margin-bottom: 20px;">
      <p>用户名: {{ userStore.admin_user_name }}</p>
      <p>昵称: {{ userStore.admin_user_nickname }}</p>
      <p>角色: {{ userStore.admin_user_role }} ({{ getRoleText() }})</p>
      <p>Token: {{ userStore.admin_user_token ? '已登录' : '未登录' }}</p>
      <p>localStorage角色: {{ localStorage.getItem('ADMIN_USER_ROLE') }}</p>
    </a-card>

    <a-card title="功能测试" style="margin-bottom: 20px;">
      <a-space>
        <a-button type="primary" @click="testAPI">测试API</a-button>
        <a-button @click="testLocalStorage">测试LocalStorage</a-button>
        <a-button @click="goToLogin">返回登录</a-button>
      </a-space>
    </a-card>

    <a-card title="测试结果">
      <pre>{{ testResult }}</pre>
    </a-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '/@/store';

const router = useRouter();
const userStore = useUserStore();
const testResult = ref('等待测试...');

const getRoleText = () => {
  const role = userStore.admin_user_role || localStorage.getItem('ADMIN_USER_ROLE') || '0';
  switch (role) {
    case '0': return '管理员';
    case '1': return '老人';
    case '2': return '护工';
    case '3': return '亲属';
    default: return '未知';
  }
};

const testAPI = async () => {
  try {
    const response = await fetch('http://127.0.0.1:8000/myapp/admin/health/list', {
      headers: {
        'AdminToken': userStore.admin_user_token
      }
    });
    const result = await response.json();
    testResult.value = `API测试结果:\n${JSON.stringify(result, null, 2)}`;
  } catch (error) {
    testResult.value = `API测试失败:\n${error.message}`;
  }
};

const testLocalStorage = () => {
  const data = {
    ADMIN_USER_TOKEN: localStorage.getItem('ADMIN_USER_TOKEN'),
    ADMIN_USER_ROLE: localStorage.getItem('ADMIN_USER_ROLE'),
    ADMIN_USER_NAME: localStorage.getItem('ADMIN_USER_NAME'),
    ADMIN_USER_ID: localStorage.getItem('ADMIN_USER_ID')
  };
  testResult.value = `LocalStorage数据:\n${JSON.stringify(data, null, 2)}`;
};

const goToLogin = () => {
  router.push({ path: '/adminLogin' });
};
</script>
