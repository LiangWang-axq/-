<template>
  <div class="my-profile-container">
    <a-row :gutter="24">
      <!-- 个人信息卡片 -->
      <a-col :span="8">
        <a-card title="个人信息" class="profile-card">
          <div class="profile-avatar">
            <a-avatar :size="80" :style="{ backgroundColor: getAvatarColor() }">
              {{ getAvatarText() }}
            </a-avatar>
            <div class="profile-name">{{ userInfo.nickname || userInfo.username }}</div>
            <div class="profile-role">{{ getRoleText() }}</div>
          </div>
          
          <a-divider />
          
          <div class="profile-info">
            <div class="info-item">
              <span class="info-label">用户名:</span>
              <span class="info-value">{{ userInfo.username }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">昵称:</span>
              <span class="info-value">{{ userInfo.nickname || '未设置' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">角色:</span>
              <span class="info-value">{{ getRoleText() }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">邮箱:</span>
              <span class="info-value">{{ userInfo.email || '未设置' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">手机:</span>
              <span class="info-value">{{ userInfo.mobile || '未设置' }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">注册时间:</span>
              <span class="info-value">{{ formatDate(userInfo.create_time) }}</span>
            </div>
          </div>
        </a-card>
      </a-col>
      
      <!-- 编辑信息表单 -->
      <a-col :span="16">
        <a-card title="编辑个人信息" class="edit-card">
          <a-form
            ref="formRef"
            :model="formData"
            :rules="rules"
            layout="vertical"
            @finish="handleSubmit"
          >
            <a-row :gutter="16">
              <a-col :span="12">
                <a-form-item label="昵称" name="nickname">
                  <a-input v-model:value="formData.nickname" placeholder="请输入昵称" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="邮箱" name="email">
                  <a-input v-model:value="formData.email" placeholder="请输入邮箱" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="手机号" name="mobile">
                  <a-input v-model:value="formData.mobile" placeholder="请输入手机号" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="性别" name="sex">
                  <a-select v-model:value="formData.sex" placeholder="请选择性别">
                    <a-select-option value="男">男</a-select-option>
                    <a-select-option value="女">女</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="年龄" name="age">
                  <a-input-number v-model:value="formData.age" :min="1" :max="120" placeholder="请输入年龄" style="width: 100%" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="紧急联系人" name="emergency_contact">
                  <a-input v-model:value="formData.emergency_contact" placeholder="请输入紧急联系人" />
                </a-form-item>
              </a-col>
              <a-col :span="24">
                <a-form-item label="个人简介" name="bio">
                  <a-textarea v-model:value="formData.bio" :rows="4" placeholder="请输入个人简介" />
                </a-form-item>
              </a-col>
            </a-row>
            
            <a-form-item>
              <a-space>
                <a-button type="primary" html-type="submit" :loading="loading">
                  保存修改
                </a-button>
                <a-button @click="resetForm">
                  重置
                </a-button>
              </a-space>
            </a-form-item>
          </a-form>
        </a-card>
        
        <!-- 修改密码 -->
        <a-card title="修改密码" class="password-card" style="margin-top: 24px;">
          <a-form
            ref="passwordFormRef"
            :model="passwordData"
            :rules="passwordRules"
            layout="vertical"
            @finish="handlePasswordSubmit"
          >
            <a-row :gutter="16">
              <a-col :span="12">
                <a-form-item label="当前密码" name="oldPassword">
                  <a-input-password v-model:value="passwordData.oldPassword" placeholder="请输入当前密码" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="新密码" name="newPassword">
                  <a-input-password v-model:value="passwordData.newPassword" placeholder="请输入新密码" />
                </a-form-item>
              </a-col>
              <a-col :span="12">
                <a-form-item label="确认新密码" name="confirmPassword">
                  <a-input-password v-model:value="passwordData.confirmPassword" placeholder="请再次输入新密码" />
                </a-form-item>
              </a-col>
            </a-row>
            
            <a-form-item>
              <a-button type="primary" html-type="submit" :loading="passwordLoading">
                修改密码
              </a-button>
            </a-form-item>
          </a-form>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import dayjs from 'dayjs';
import { useUserStore } from '/@/store';

const userStore = useUserStore();
const loading = ref(false);
const passwordLoading = ref(false);
const formRef = ref();
const passwordFormRef = ref();

const userInfo = ref({});

const formData = reactive({
  nickname: '',
  email: '',
  mobile: '',
  sex: '',
  age: undefined,
  emergency_contact: '',
  bio: ''
});

const passwordData = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
});

const rules = {
  nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  email: [{ type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }],
  mobile: [{ pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }]
};

const passwordRules = {
  oldPassword: [{ required: true, message: '请输入当前密码', trigger: 'blur' }],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    { validator: validatePassword, trigger: 'blur' }
  ]
};

function validatePassword(rule: any, value: string, callback: Function) {
  if (value !== passwordData.newPassword) {
    callback(new Error('两次输入的密码不一致'));
  } else {
    callback();
  }
}

const getUserRole = () => {
  return userStore.admin_user_role || localStorage.getItem('ADMIN_USER_ROLE') || '0';
};

const getRoleText = () => {
  const role = getUserRole();
  switch (role) {
    case '0': return '管理员';
    case '1': return '老人';
    case '2': return '护工';
    case '3': return '亲属';
    default: return '用户';
  }
};

const getAvatarColor = () => {
  const colors = ['#f56a00', '#7265e6', '#ffbf00', '#00a2ae'];
  const role = getUserRole();
  return colors[parseInt(role)] || colors[0];
};

const getAvatarText = () => {
  const nickname = userInfo.value.nickname || userInfo.value.username || '';
  return nickname.charAt(0).toUpperCase();
};

const formatDate = (dateString: string) => {
  return dateString ? dayjs(dateString).format('YYYY-MM-DD HH:mm') : '未知';
};

const loadUserInfo = async () => {
  try {
    // 这里应该调用获取用户信息的API
    // 暂时使用store中的信息
    userInfo.value = {
      username: userStore.admin_user_name,
      nickname: userStore.admin_user_nickname,
      role: userStore.admin_user_role,
      email: '',
      mobile: '',
      create_time: new Date().toISOString()
    };
    
    // 填充表单数据
    Object.assign(formData, userInfo.value);
  } catch (error) {
    message.error('加载用户信息失败');
  }
};

const handleSubmit = async () => {
  loading.value = true;
  try {
    // 这里应该调用更新用户信息的API
    await new Promise(resolve => setTimeout(resolve, 1000)); // 模拟API调用
    
    message.success('个人信息更新成功');
    loadUserInfo();
  } catch (error) {
    message.error('更新失败');
  } finally {
    loading.value = false;
  }
};

const handlePasswordSubmit = async () => {
  passwordLoading.value = true;
  try {
    // 这里应该调用修改密码的API
    await new Promise(resolve => setTimeout(resolve, 1000)); // 模拟API调用
    
    message.success('密码修改成功');
    resetPasswordForm();
  } catch (error) {
    message.error('密码修改失败');
  } finally {
    passwordLoading.value = false;
  }
};

const resetForm = () => {
  Object.assign(formData, userInfo.value);
};

const resetPasswordForm = () => {
  Object.assign(passwordData, {
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  });
};

onMounted(() => {
  loadUserInfo();
});
</script>

<style lang="less" scoped>
.my-profile-container {
  padding: 24px;
  background: #f5f7fa;
  min-height: 100vh;
}

.profile-card, .edit-card, .password-card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  
  :deep(.ant-card-head) {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 12px 12px 0 0;
    
    .ant-card-head-title {
      color: white;
      font-weight: 600;
    }
  }
}

.profile-avatar {
  text-align: center;
  padding: 20px 0;
}

.profile-name {
  font-size: 20px;
  font-weight: 600;
  color: #262626;
  margin-top: 16px;
}

.profile-role {
  font-size: 14px;
  color: #8c8c8c;
  margin-top: 4px;
}

.profile-info {
  .info-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 0;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
      border-bottom: none;
    }
  }
  
  .info-label {
    font-weight: 500;
    color: #595959;
  }
  
  .info-value {
    color: #262626;
  }
}
</style>
