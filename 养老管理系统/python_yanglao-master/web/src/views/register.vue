<template>
  <div id="userLayout">
    <div class="user-layout-header">
      <img class="logo" :src="logoImage" alt="">
      <span>养老管理系统</span>
    </div>
    <div class="main-container">
      <div class="main">
        <div class="main_right">
          <h2 class="sys_title">用户注册</h2>
          <a-form
              ref="myform"
              layout="vertical"
              :model="data.registerForm"
              :rules="data.rules"
              :hideRequiredMark="true"
          >
            <a-row :gutter="16">
              <a-col :span="12">
                <a-form-item name="username" label="用户名" :colon="false">
                  <a-input
                      size="large"
                      placeholder="请输入用户名"
                      v-model:value="data.registerForm.username">
                  </a-input>
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item name="nickname" label="姓名" :colon="false">
                  <a-input
                      size="large"
                      placeholder="请输入真实姓名"
                      v-model:value="data.registerForm.nickname">
                  </a-input>
                </a-form-item>
              </a-col>
            </a-row>
            
            <a-row :gutter="16">
              <a-col :span="12">
                <a-form-item name="password" label="密码" :colon="false">
                  <a-input
                      size="large"
                      type="password"
                      placeholder="请输入密码"
                      v-model:value="data.registerForm.password">
                  </a-input>
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item name="confirmPassword" label="确认密码" :colon="false">
                  <a-input
                      size="large"
                      type="password"
                      placeholder="请再次输入密码"
                      v-model:value="data.registerForm.confirmPassword">
                  </a-input>
                </a-form-item>
              </a-col>
            </a-row>

            <a-form-item name="role" label="用户类型" :colon="false">
              <a-select
                  size="large"
                  placeholder="请选择用户类型"
                  v-model:value="data.registerForm.role">
                <a-select-option value="1">老人</a-select-option>
                <a-select-option value="2">护工</a-select-option>
                <a-select-option value="3">亲属</a-select-option>
              </a-select>
            </a-form-item>

            <a-row :gutter="16">
              <a-col :span="12">
                <a-form-item name="mobile" label="手机号" :colon="false">
                  <a-input
                      size="large"
                      placeholder="请输入手机号"
                      v-model:value="data.registerForm.mobile">
                  </a-input>
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item name="email" label="邮箱" :colon="false">
                  <a-input
                      size="large"
                      placeholder="请输入邮箱"
                      v-model:value="data.registerForm.email">
                  </a-input>
                </a-form-item>
              </a-col>
            </a-row>

            <a-form-item style="padding-top: 24px">
              <a-button
                  class="register-button"
                  type="primary"
                  :loading="registerBtn"
                  size="large"
                  block
                  @click="handleSubmit"
              >
                注册
              </a-button>
            </a-form-item>
            <a-form-item>
              <div class="login-link">
                已有账号？<a @click="goToLogin">立即登录</a>
              </div>
            </a-form-item>
          </a-form>
          <div class="error-tip"></div>
        </div>
      </div>
    </div>
    <footer class="footer">
      <div class="copyright">
        <span></span>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import logoImage from '/@/assets/images/k-logo.png';
import { message } from "ant-design-vue";
import { userRegisterApi } from '/@/api/user';

const router = useRouter();

const myform = ref()
const registerBtn = ref<Boolean>(false)

// 先定义密码验证函数
function validatePassword(rule: any, value: string, callback: Function) {
  if (value !== data.registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const data = reactive({
  registerForm: {
    username: '',
    password: '',
    confirmPassword: '',
    nickname: '',
    role: '',
    mobile: '',
    email: ''
  },
  rules: {
    username: [
      { required: true, message: '请输入用户名', trigger: 'blur' },
      { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
    ],
    password: [
      { required: true, message: '请输入密码', trigger: 'blur' },
      { min: 6, max: 20, message: '密码长度在6到20个字符', trigger: 'blur' }
    ],
    confirmPassword: [
      { required: true, message: '请确认密码', trigger: 'blur' },
      { validator: validatePassword, trigger: 'blur' }
    ],
    nickname: [
      { required: true, message: '请输入姓名', trigger: 'blur' }
    ],
    role: [
      { required: true, message: '请选择用户类型', trigger: 'change' }
    ],
    mobile: [
      { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
    ],
    email: [
      { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
    ]
  }
})

const handleSubmit = () => {
  console.log('开始提交注册表单...');
  console.log('表单数据:', data.registerForm);

  myform.value?.validate().then(() => {
    console.log('表单验证通过');
    handleRegister()
  }).catch((error) => {
    console.log('表单验证失败:', error);
    message.warn('请检查输入信息')
  })
}

const handleRegister = () => {
  console.log('开始注册用户...');
  registerBtn.value = true

  const registerData = {
    username: data.registerForm.username,
    password: data.registerForm.password,
    nickname: data.registerForm.nickname,
    role: data.registerForm.role,
    mobile: data.registerForm.mobile,
    email: data.registerForm.email
  }

  console.log('注册数据:', registerData);

  userRegisterApi(registerData).then(res => {
    console.log('注册API响应:', res);
    registerBtn.value = false

    // 检查响应码
    if (res.code === 0) {
      message.success('注册成功！请登录')
      router.push({ name: 'adminLogin' })
    } else {
      message.error(res.msg || '注册失败')
    }
  }).catch(err => {
    console.log('注册API错误:', err);
    registerBtn.value = false
    message.error(err.msg || err.message || '注册失败')
  })
}

const goToLogin = () => {
  router.push({ name: 'adminLogin' })
}
</script>

<style lang="less" scoped>
#userLayout {
  position: relative;
  height: 100vh;

  .user-layout-header {
    height: 80px;
    padding: 0 24px;
    color: fade(#000, 85%);
    font-size: 24px;
    font-weight: bold;
    line-height: 80px;

    .logo {
      width: 36px;
      height: 36px;
      margin-right: 16px;
      margin-top: -4px;
    }
  }

  .main-container {
    width: 100%;
    height: calc(100vh - 160px);
    background-image: url('../images/admin-login-bg.jpg');
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;

    .main {
      position: absolute;
      right: 80px;
      top: 50%;
      display: flex;
      transform: translate(0, -50%);
      border-radius: 8px;
      overflow: hidden;
      -webkit-box-shadow: 2px 2px 6px #aaa;
      box-shadow: 2px 2px 6px #aaa;

      .main_right {
        background: #ffffff;
        padding: 24px;
        width: 520px;
        user-select: none;

        .sys_title {
          font-size: 24px;
          color: fade(#000, 85%);
          font-weight: bold;
          user-select: none;
          padding-bottom: 8px;
        }

        :deep(.ant-form-item label) {
          font-weight: bold;
        }

        .register-button {
          background: linear-gradient(128deg, #52c41a, #73d13d 59%, #95de64 100%);
        }

        .login-link {
          text-align: center;
          margin-top: 16px;
          a {
            color: #1890ff;
            cursor: pointer;
            text-decoration: none;
            &:hover {
              color: #40a9ff;
            }
          }
        }
      }

      .error-tip {
        text-align: center;
      }
    }
  }

  .footer {
    height: 80px;
  }
}
</style>
