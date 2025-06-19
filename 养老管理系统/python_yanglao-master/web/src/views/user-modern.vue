<template>
  <div class="user-management-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <UserOutlined class="title-icon" />
          用户管理
        </h1>
        <p class="page-description">管理系统用户账号，分配角色权限</p>
      </div>
      <div class="header-actions">

      </div>
    </div>

    <!-- 搜索和筛选区域 -->
    <div class="search-section">
      <a-card class="search-card">
        <a-row :gutter="16" align="middle">
          <a-col :span="6">
            <a-input-search
              v-model:value="searchForm.keyword"
              placeholder="搜索用户名、昵称"
              @search="handleSearch"
              @change="handleSearchChange"
              size="large"
            />
          </a-col>
          <a-col :span="4">
            <a-select
              v-model:value="searchForm.role"
              placeholder="选择角色"
              size="large"
              allowClear
              @change="handleSearch"
            >
              <a-select-option value="0">管理员</a-select-option>
              <a-select-option value="1">老人</a-select-option>
              <a-select-option value="2">护工</a-select-option>
              <a-select-option value="3">亲属</a-select-option>
            </a-select>
          </a-col>
          <a-col :span="4">
            <a-select
              v-model:value="searchForm.status"
              placeholder="选择状态"
              size="large"
              allowClear
              @change="handleSearch"
            >
              <a-select-option value="0">正常</a-select-option>
              <a-select-option value="1">封号</a-select-option>
            </a-select>
          </a-col>
          <a-col :span="6">
            <a-space>
              <a-button @click="handleReset">重置</a-button>
              <a-button type="primary" @click="handleSearch">搜索</a-button>
            </a-space>
          </a-col>
          <a-col :span="4" class="text-right">
            <a-button 
              danger 
              :disabled="selectedRowKeys.length === 0"
              @click="handleBatchDelete"
            >
              <DeleteOutlined />
              批量删除
            </a-button>
          </a-col>
        </a-row>
      </a-card>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-section">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card class="stat-card admin-card">
            <a-statistic
              title="管理员"
              :value="stats.adminCount"
              :value-style="{ color: '#1890ff' }"
            >
              <template #prefix>
                <CrownOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card elderly-card">
            <a-statistic
              title="老人"
              :value="stats.elderlyCount"
              :value-style="{ color: '#52c41a' }"
            >
              <template #prefix>
                <UserOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card caregiver-card">
            <a-statistic
              title="护工"
              :value="stats.caregiverCount"
              :value-style="{ color: '#fa8c16' }"
            >
              <template #prefix>
                <MedicineBoxOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card family-card">
            <a-statistic
              title="亲属"
              :value="stats.familyCount"
              :value-style="{ color: '#eb2f96' }"
            >
              <template #prefix>
                <HeartOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 用户列表 -->
    <div class="table-section">
      <a-card class="table-card">
        <a-table
          rowKey="id"
          :columns="columns"
          :data-source="userList"
          :loading="loading"
          :row-selection="rowSelection"
          :pagination="pagination"
          :scroll="{ x: 1200 }"
          size="middle"
          class="modern-table"
        >
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'avatar'">
              <a-avatar :src="record.avatar" :size="40">
                {{ record.nickname?.charAt(0) || record.username?.charAt(0) }}
              </a-avatar>
            </template>
            
            <template v-if="column.key === 'role'">
              <a-tag :color="getRoleColor(record.role)" class="role-tag">
                {{ getRoleText(record.role) }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'status'">
              <a-tag :color="record.status === '0' ? 'success' : 'error'">
                {{ record.status === '0' ? '正常' : '封号' }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'action'">
              <a-space>
                <a-button type="link" size="small" @click="handleEdit(record)">
                  <EditOutlined />
                  编辑
                </a-button>
                <a-button type="link" size="small" @click="handleResetPassword(record)">
                  <KeyOutlined />
                  重置密码
                </a-button>
                <a-popconfirm
                  title="确定要删除这个用户吗？"
                  @confirm="handleDelete(record)"
                  ok-text="确定"
                  cancel-text="取消"
                >
                  <a-button type="link" size="small" danger>
                    <DeleteOutlined />
                    删除
                  </a-button>
                </a-popconfirm>
              </a-space>
            </template>
          </template>
        </a-table>
      </a-card>
    </div>

    <!-- 新增/编辑用户模态框 -->
    <a-modal
      v-model:visible="modalVisible"
      :title="modalTitle"
      width="600px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
      class="user-modal"
    >
      <template #footer>
        <a-button @click="handleCancel">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleSubmit">
          {{ isEdit ? '更新' : '创建' }}
        </a-button>
      </template>
      
      <a-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        layout="vertical"
        class="user-form"
      >
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="用户名" name="username">
              <a-input
                v-model:value="formData.username"
                :disabled="isEdit"
                placeholder="请输入用户名"
                size="large"
              />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="昵称" name="nickname">
              <a-input
                v-model:value="formData.nickname"
                placeholder="请输入昵称"
                size="large"
              />
            </a-form-item>
          </a-col>
          <a-col :span="12" v-if="!isEdit">
            <a-form-item label="密码" name="password">
              <a-input-password
                v-model:value="formData.password"
                placeholder="请输入密码"
                size="large"
              />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="角色" name="role">
              <a-select
                v-model:value="formData.role"
                placeholder="请选择角色"
                size="large"
              >
                <a-select-option value="0">管理员</a-select-option>
                <a-select-option value="1">老人</a-select-option>
                <a-select-option value="2">护工</a-select-option>
                <a-select-option value="3">亲属</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="状态" name="status">
              <a-select
                v-model:value="formData.status"
                placeholder="请选择状态"
                size="large"
              >
                <a-select-option value="0">正常</a-select-option>
                <a-select-option value="1">封号</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="邮箱" name="email">
              <a-input
                v-model:value="formData.email"
                placeholder="请输入邮箱"
                size="large"
              />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="手机号" name="mobile">
              <a-input
                v-model:value="formData.mobile"
                placeholder="请输入手机号"
                size="large"
              />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import { message } from 'ant-design-vue';
import {
  UserOutlined,
  PlusOutlined,
  EditOutlined,
  DeleteOutlined,
  KeyOutlined,
  CrownOutlined,
  MedicineBoxOutlined,
  HeartOutlined
} from '@ant-design/icons-vue';
import { createApi, listApi, updateApi, deleteApi } from '/@/api/user';

// 响应式数据
const loading = ref(false);
const modalVisible = ref(false);
const submitting = ref(false);
const isEdit = ref(false);
const selectedRowKeys = ref<string[]>([]);
const userList = ref([]);
const formRef = ref();

// 搜索表单
const searchForm = reactive({
  keyword: '',
  role: undefined,
  status: undefined
});

// 表单数据
const formData = reactive({
  id: undefined,
  username: '',
  password: '',
  nickname: '',
  role: undefined,
  status: '0',
  email: '',
  mobile: ''
});

// 统计数据
const stats = reactive({
  adminCount: 0,
  elderlyCount: 0,
  caregiverCount: 0,
  familyCount: 0
});

// 表单验证规则
const formRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在6到20个字符', trigger: 'blur' }
  ],
  nickname: [
    { required: true, message: '请输入昵称', trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ],
  status: [
    { required: true, message: '请选择状态', trigger: 'change' }
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  mobile: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ]
};

// 表格列定义
const columns = [
  {
    title: '头像',
    dataIndex: 'avatar',
    key: 'avatar',
    width: 80,
    align: 'center'
  },
  {
    title: '用户名',
    dataIndex: 'username',
    key: 'username',
    width: 120
  },
  {
    title: '昵称',
    dataIndex: 'nickname',
    key: 'nickname',
    width: 120
  },
  {
    title: '角色',
    dataIndex: 'role',
    key: 'role',
    width: 100,
    align: 'center'
  },
  {
    title: '状态',
    dataIndex: 'status',
    key: 'status',
    width: 80,
    align: 'center'
  },
  {
    title: '邮箱',
    dataIndex: 'email',
    key: 'email',
    width: 180
  },
  {
    title: '手机号',
    dataIndex: 'mobile',
    key: 'mobile',
    width: 130
  },
  {
    title: '创建时间',
    dataIndex: 'create_time',
    key: 'create_time',
    width: 160
  },
  {
    title: '操作',
    key: 'action',
    width: 200,
    fixed: 'right',
    align: 'center'
  }
];

// 分页配置
const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showSizeChanger: true,
  showQuickJumper: true,
  showTotal: (total: number) => `共 ${total} 条记录`,
  onChange: (page: number, pageSize: number) => {
    pagination.current = page;
    pagination.pageSize = pageSize;
    loadUserList();
  }
});

// 行选择配置
const rowSelection = {
  selectedRowKeys,
  onChange: (keys: string[]) => {
    selectedRowKeys.value = keys;
  }
};

// 计算属性
const modalTitle = computed(() => isEdit.value ? '编辑用户' : '新增用户');

// 工具函数
const getRoleColor = (role: string) => {
  const colors = {
    '0': 'blue',
    '1': 'green',
    '2': 'orange',
    '3': 'magenta'
  };
  return colors[role] || 'default';
};

const getRoleText = (role: string) => {
  const texts = {
    '0': '管理员',
    '1': '老人',
    '2': '护工',
    '3': '亲属'
  };
  return texts[role] || '未知';
};

// 数据加载
const loadUserList = async () => {
  loading.value = true;
  try {
    const params = {
      keyword: searchForm.keyword,
      role: searchForm.role,
      status: searchForm.status,
      page: pagination.current,
      pageSize: pagination.pageSize
    };

    const response = await listApi(params);
    if (response.code === 0) {
      userList.value = response.data.map((item: any, index: number) => ({
        ...item,
        index: (pagination.current - 1) * pagination.pageSize + index + 1
      }));

      // 更新统计数据
      updateStats(response.data);

      // 如果有总数，更新分页
      if (response.total !== undefined) {
        pagination.total = response.total;
      }
    }
  } catch (error) {
    message.error('加载用户列表失败');
  } finally {
    loading.value = false;
  }
};

const updateStats = (data: any[]) => {
  stats.adminCount = data.filter(item => item.role === '0').length;
  stats.elderlyCount = data.filter(item => item.role === '1').length;
  stats.caregiverCount = data.filter(item => item.role === '2').length;
  stats.familyCount = data.filter(item => item.role === '3').length;
};

// 事件处理
const handleSearch = () => {
  pagination.current = 1;
  loadUserList();
};

const handleSearchChange = () => {
  if (!searchForm.keyword) {
    handleSearch();
  }
};

const handleReset = () => {
  searchForm.keyword = '';
  searchForm.role = undefined;
  searchForm.status = undefined;
  handleSearch();
};

const handleAdd = () => {
  isEdit.value = false;
  modalVisible.value = true;
  resetForm();
};

const handleEdit = (record: any) => {
  isEdit.value = true;
  modalVisible.value = true;
  Object.assign(formData, {
    id: record.id,
    username: record.username,
    nickname: record.nickname,
    role: record.role,
    status: record.status,
    email: record.email,
    mobile: record.mobile
  });
};

const handleDelete = async (record: any) => {
  try {
    await deleteApi({ ids: record.id });
    message.success('删除成功');
    loadUserList();
  } catch (error) {
    message.error('删除失败');
  }
};

const handleBatchDelete = async () => {
  if (selectedRowKeys.value.length === 0) {
    message.warning('请选择要删除的用户');
    return;
  }

  try {
    await deleteApi({ ids: selectedRowKeys.value.join(',') });
    message.success('批量删除成功');
    selectedRowKeys.value = [];
    loadUserList();
  } catch (error) {
    message.error('批量删除失败');
  }
};

const handleResetPassword = (record: any) => {
  // TODO: 实现重置密码功能
  message.info('重置密码功能开发中');
};

const handleSubmit = async () => {
  try {
    await formRef.value.validate();
    submitting.value = true;

    const submitData = { ...formData };

    if (isEdit.value) {
      await updateApi({ id: formData.id }, submitData);
      message.success('更新成功');
    } else {
      await createApi(submitData);
      message.success('创建成功');
    }

    modalVisible.value = false;
    loadUserList();
  } catch (error) {
    if (error.errorFields) {
      message.error('请检查表单输入');
    } else {
      message.error(isEdit.value ? '更新失败' : '创建失败');
    }
  } finally {
    submitting.value = false;
  }
};

const handleCancel = () => {
  modalVisible.value = false;
  resetForm();
};

const resetForm = () => {
  Object.assign(formData, {
    id: undefined,
    username: '',
    password: '',
    nickname: '',
    role: undefined,
    status: '0',
    email: '',
    mobile: ''
  });
  formRef.value?.resetFields();
};

// 生命周期
onMounted(() => {
  loadUserList();
});
</script>

<style lang="less" scoped>
.user-management-container {
  padding: 24px;
  background: #f5f5f5;
  min-height: 100vh;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
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

  .add-btn {
    height: 40px;
    border-radius: 6px;
    font-weight: 500;
  }
}

.search-section {
  margin-bottom: 24px;

  .search-card {
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.stats-section {
  margin-bottom: 24px;

  .stat-card {
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    }
  }
}

.table-section {
  .table-card {
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);

    .modern-table {
      :deep(.ant-table-thead > tr > th) {
        background: #fafafa;
        font-weight: 600;
        color: #262626;
      }

      :deep(.ant-table-tbody > tr:hover > td) {
        background: #f5f5f5;
      }
    }
  }
}

.role-tag {
  font-weight: 500;
  border-radius: 4px;
}

.user-modal {
  :deep(.ant-modal-header) {
    border-radius: 8px 8px 0 0;
  }

  :deep(.ant-modal-content) {
    border-radius: 8px;
  }
}

.user-form {
  :deep(.ant-form-item-label > label) {
    font-weight: 500;
    color: #262626;
  }
}

.text-right {
  text-align: right;
}
</style>
