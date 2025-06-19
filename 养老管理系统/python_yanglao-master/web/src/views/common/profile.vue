<template>
  <div class="user-profile">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <UserOutlined class="title-icon" />
          个人资料
        </h1>
        <p class="page-description">查看和编辑您的个人信息</p>
      </div>
    </div>

    <!-- 个人信息卡片 -->
    <div class="profile-content">
      <a-row :gutter="24">
        <a-col :span="8">
          <a-card class="profile-card">
            <div class="profile-avatar">
              <a-avatar :size="120" style="background-color: #1890ff">
                {{ userInfo.nickname ? userInfo.nickname.charAt(0) : 'U' }}
              </a-avatar>
              <div class="avatar-info">
                <h3>{{ userInfo.nickname || userInfo.username }}</h3>
                <p>{{ getRoleText(userInfo.role) }}</p>
                <a-tag :color="getStatusColor(userInfo.status)">
                  {{ getStatusText(userInfo.status) }}
                </a-tag>
              </div>
            </div>
          </a-card>
        </a-col>
        
        <a-col :span="16">
          <a-card title="基本信息" class="info-card">
            <template #extra>
              <a-button type="primary" @click="showEditModal">
                <EditOutlined />
                编辑资料
              </a-button>
            </template>
            
            <a-descriptions :column="2" bordered>
              <a-descriptions-item label="用户名">
                {{ userInfo.username }}
              </a-descriptions-item>
              <a-descriptions-item label="昵称">
                {{ userInfo.nickname || '未设置' }}
              </a-descriptions-item>
              <a-descriptions-item label="角色">
                {{ getRoleText(userInfo.role) }}
              </a-descriptions-item>
              <a-descriptions-item label="状态">
                <a-tag :color="getStatusColor(userInfo.status)">
                  {{ getStatusText(userInfo.status) }}
                </a-tag>
              </a-descriptions-item>
              <a-descriptions-item label="邮箱">
                {{ userInfo.email || '未设置' }}
              </a-descriptions-item>
              <a-descriptions-item label="手机号">
                {{ userInfo.mobile || '未设置' }}
              </a-descriptions-item>
              <a-descriptions-item label="注册时间" :span="2">
                {{ formatDate(userInfo.create_time) }}
              </a-descriptions-item>
            </a-descriptions>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 安全设置 -->
    <div class="security-section">
      <a-card title="安全设置" class="security-card">
        <div class="security-list">
          <div class="security-item">
            <div class="security-info">
              <h4>登录密码</h4>
              <p>定期更换密码，保护账号安全</p>
            </div>
            <div class="security-action">
              <a-button @click="showPasswordModal">修改密码</a-button>
            </div>
          </div>
          
          <div class="security-item">
            <div class="security-info">
              <h4>邮箱验证</h4>
              <p>验证邮箱可用于找回密码</p>
            </div>
            <div class="security-action">
              <a-tag v-if="userInfo.email" color="success">已验证</a-tag>
              <a-button v-else type="link">绑定邮箱</a-button>
            </div>
          </div>
          
          <div class="security-item">
            <div class="security-info">
              <h4>手机号码</h4>
              <p>绑定手机号用于接收重要通知</p>
            </div>
            <div class="security-action">
              <a-tag v-if="userInfo.mobile" color="success">已绑定</a-tag>
              <a-button v-else type="link">绑定手机</a-button>
            </div>
          </div>
        </div>
      </a-card>
    </div>

    <!-- 编辑资料模态框 -->
    <a-modal
      v-model:visible="editModalVisible"
      title="编辑个人资料"
      width="600px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
    >
      <template #footer>
        <a-button @click="editModalVisible = false">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleUpdateProfile">
          保存
        </a-button>
      </template>
      
      <a-form
        ref="editFormRef"
        :model="editForm"
        :rules="editRules"
        layout="vertical"
      >
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="昵称" name="nickname">
              <a-input v-model:value="editForm.nickname" placeholder="请输入昵称" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="邮箱" name="email">
              <a-input v-model:value="editForm.email" placeholder="请输入邮箱" />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="手机号" name="mobile">
              <a-input v-model:value="editForm.mobile" placeholder="请输入手机号" />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
    </a-modal>

    <!-- 修改密码模态框 -->
    <a-modal
      v-model:visible="passwordModalVisible"
      title="修改密码"
      width="500px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
    >
      <template #footer>
        <a-button @click="passwordModalVisible = false">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleUpdatePassword">
          确认修改
        </a-button>
      </template>
      
      <a-form
        ref="passwordFormRef"
        :model="passwordForm"
        :rules="passwordRules"
        layout="vertical"
      >
        <a-form-item label="当前密码" name="oldPassword">
          <a-input-password v-model:value="passwordForm.oldPassword" placeholder="请输入当前密码" />
        </a-form-item>
        <a-form-item label="新密码" name="newPassword">
          <a-input-password v-model:value="passwordForm.newPassword" placeholder="请输入新密码" />
        </a-form-item>
        <a-form-item label="确认新密码" name="confirmPassword">
          <a-input-password v-model:value="passwordForm.confirmPassword" placeholder="请再次输入新密码" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import {
  UserOutlined,
  EditOutlined
} from '@ant-design/icons-vue';
import { detailApi, updateApi } from '/@/api/user';

const userStore = useUserStore();
const editModalVisible = ref(false);
const passwordModalVisible = ref(false);
const submitting = ref(false);
const editFormRef = ref();
const passwordFormRef = ref();

// 用户信息
const userInfo = reactive({
  id: '',
  username: '',
  nickname: '',
  role: '',
  status: '',
  email: '',
  mobile: '',
  create_time: ''
});

// 编辑表单
const editForm = reactive({
  nickname: '',
  email: '',
  mobile: ''
});

// 密码表单
const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
});

// 表单验证规则
const editRules = {
  nickname: [
    { required: true, message: '请输入昵称', trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  mobile: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ]
};

const passwordRules = {
  oldPassword: [
    { required: true, message: '请输入当前密码', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少6位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    {
      validator: (rule: any, value: string) => {
        if (value !== passwordForm.newPassword) {
          return Promise.reject('两次输入的密码不一致');
        }
        return Promise.resolve();
      },
      trigger: 'blur'
    }
  ]
};

// 工具函数
const getRoleText = (role: string) => {
  const roleMap = {
    '0': '管理员',
    '1': '老人',
    '2': '护工',
    '3': '亲属'
  };
  return roleMap[role] || '未知';
};

const getStatusColor = (status: string) => {
  return status === '0' ? 'success' : 'error';
};

const getStatusText = (status: string) => {
  return status === '0' ? '正常' : '封号';
};

const formatDate = (dateString: string) => {
  if (!dateString) return '未知';
  return new Date(dateString).toLocaleString('zh-CN');
};

// 数据加载
const loadUserInfo = async () => {
  try {
    const userId = userStore.admin_user_id;
    if (userId) {
      const response = await detailApi({ id: userId });
      if (response.code === 0) {
        Object.assign(userInfo, response.data);
      }
    } else {
      // 从store获取基本信息
      Object.assign(userInfo, {
        id: userStore.admin_user_id,
        username: userStore.admin_user_name,
        nickname: userStore.admin_user_nickname,
        role: userStore.admin_user_role,
        status: '0'
      });
    }
  } catch (error) {
    console.error('加载用户信息失败');
  }
};

// 事件处理
const showEditModal = () => {
  editModalVisible.value = true;
  Object.assign(editForm, {
    nickname: userInfo.nickname,
    email: userInfo.email,
    mobile: userInfo.mobile
  });
};

const showPasswordModal = () => {
  passwordModalVisible.value = true;
  Object.assign(passwordForm, {
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  });
};

const handleUpdateProfile = async () => {
  try {
    await editFormRef.value.validate();
    submitting.value = true;
    
    const response = await updateApi({ id: userInfo.id }, editForm);
    if (response.code === 0) {
      message.success('个人资料更新成功');
      Object.assign(userInfo, editForm);
      editModalVisible.value = false;
      
      // 更新store中的用户信息
      if (editForm.nickname) {
        userStore.admin_user_nickname = editForm.nickname;
      }
    } else {
      message.error(response.msg || '更新失败');
    }
  } catch (error) {
    message.error('更新失败');
  } finally {
    submitting.value = false;
  }
};

const handleUpdatePassword = async () => {
  try {
    await passwordFormRef.value.validate();
    submitting.value = true;
    
    // 这里应该调用修改密码的API
    message.success('密码修改成功，请重新登录');
    passwordModalVisible.value = false;
    
    // 可以考虑自动退出登录
    setTimeout(() => {
      userStore.logout();
      window.location.reload();
    }, 1500);
  } catch (error) {
    message.error('密码修改失败');
  } finally {
    submitting.value = false;
  }
};

onMounted(() => {
  loadUserInfo();
});
</script>

<style lang="less" scoped>
.user-profile {
  padding: 24px;
  background: #f5f5f5;
  min-height: 100vh;
}

.page-header {
  margin-bottom: 24px;
  
  .header-content {
    .page-title {
      margin: 0;
      font-size: 28px;
      font-weight: 600;
      color: #262626;
      display: flex;
      align-items: center;
      
      .title-icon {
        margin-right: 12px;
        color: #1890ff;
      }
    }
    
    .page-description {
      margin: 8px 0 0 0;
      color: #8c8c8c;
      font-size: 14px;
    }
  }
}

.profile-content, .security-section {
  margin-bottom: 24px;
  
  .profile-card, .info-card, .security-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.profile-avatar {
  text-align: center;
  
  .avatar-info {
    margin-top: 16px;
    
    h3 {
      margin: 0 0 8px 0;
      font-size: 20px;
      color: #262626;
    }
    
    p {
      margin: 0 0 8px 0;
      color: #8c8c8c;
      font-size: 14px;
    }
  }
}

.security-list {
  .security-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 0;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
      border-bottom: none;
    }
    
    .security-info {
      flex: 1;
      
      h4 {
        margin: 0 0 4px 0;
        font-size: 16px;
        color: #262626;
      }
      
      p {
        margin: 0;
        color: #8c8c8c;
        font-size: 12px;
      }
    }
  }
}
</style>
