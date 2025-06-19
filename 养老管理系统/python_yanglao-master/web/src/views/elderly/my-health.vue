<template>
  <div class="my-health-container">
    <!-- 健康概览卡片 -->
    <div class="health-overview">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card class="health-card">
            <div class="health-item">
              <div class="health-icon">
                <HeartOutlined style="color: #ff4d4f; font-size: 24px;" />
              </div>
              <div class="health-info">
                <div class="health-value">{{ latestHealth.temperature || '--' }}°C</div>
                <div class="health-label">体温</div>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="health-card">
            <div class="health-item">
              <div class="health-icon">
                <DashboardOutlined style="color: #1890ff; font-size: 24px;" />
              </div>
              <div class="health-info">
                <div class="health-value">{{ latestHealth.pressure || '--' }}</div>
                <div class="health-label">血压</div>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="health-card">
            <div class="health-item">
              <div class="health-icon">
                <ScaleOutlined style="color: #52c41a; font-size: 24px;" />
              </div>
              <div class="health-info">
                <div class="health-value">{{ latestHealth.weight || '--' }}kg</div>
                <div class="health-label">体重</div>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="health-card">
            <div class="health-item">
              <div class="health-icon">
                <LineHeightOutlined style="color: #722ed1; font-size: 24px;" />
              </div>
              <div class="health-info">
                <div class="health-value">{{ latestHealth.height || '--' }}cm</div>
                <div class="health-label">身高</div>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 健康记录列表 -->
    <a-card title="我的健康记录" class="health-records">
      <template #extra>
        <a-button type="primary" @click="showAddModal">
          <PlusOutlined />
          添加记录
        </a-button>
      </template>
      
      <a-table
        :columns="columns"
        :data-source="healthRecords"
        :loading="loading"
        row-key="id"
        :pagination="{ pageSize: 10 }"
      >
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'action'">
            <a-space>
              <a-button type="link" @click="viewRecord(record)">查看</a-button>
              <a-button type="link" @click="editRecord(record)">编辑</a-button>
            </a-space>
          </template>
          <template v-if="column.key === 'status'">
            <a-tag :color="getHealthStatus(record).color">
              {{ getHealthStatus(record).text }}
            </a-tag>
          </template>
        </template>
      </a-table>
    </a-card>

    <!-- 添加/编辑健康记录模态框 -->
    <a-modal
      v-model:visible="modalVisible"
      :title="modalTitle"
      width="600px"
      @ok="handleSubmit"
      @cancel="handleCancel"
    >
      <template #footer>
        <a-button @click="handleCancel">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleSubmit">确认</a-button>
      </template>
      <a-form
        ref="formRef"
        :model="formData"
        :rules="rules"
        layout="vertical"
      >
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="体温(°C)" name="temperature">
              <a-input v-model:value="formData.temperature" placeholder="36.5" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="血压" name="pressure">
              <a-input v-model:value="formData.pressure" placeholder="120/80" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="体重(kg)" name="weight">
              <a-input v-model:value="formData.weight" placeholder="65" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="身高(cm)" name="height">
              <a-input v-model:value="formData.height" placeholder="170" />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="备注" name="remark">
              <a-textarea v-model:value="formData.remark" :rows="3" placeholder="请输入健康状况备注" />
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
import { HeartOutlined, DashboardOutlined, ScaleOutlined, LineHeightOutlined, PlusOutlined } from '@ant-design/icons-vue';
import { listApi, createApi, updateApi } from '/@/api/health.js';
import { useUserStore } from '/@/store';

const userStore = useUserStore();
const loading = ref(false);
const modalVisible = ref(false);
const modalTitle = ref('');
const isEdit = ref(false);
const formRef = ref();
const submitting = ref(false);

const healthRecords = ref([]);
const latestHealth = computed(() => {
  return healthRecords.value[0] || {};
});

const formData = reactive({
  id: undefined,
  temperature: '',
  pressure: '',
  weight: '',
  height: '',
  remark: ''
});

const rules = {
  temperature: [{ required: true, message: '请输入体温', trigger: 'blur' }],
  pressure: [{ required: true, message: '请输入血压', trigger: 'blur' }],
  weight: [{ required: true, message: '请输入体重', trigger: 'blur' }],
  height: [{ required: true, message: '请输入身高', trigger: 'blur' }]
};

const columns = [
  {
    title: '记录时间',
    dataIndex: 'create_time',
    key: 'create_time',
    width: 150
  },
  {
    title: '体温(°C)',
    dataIndex: 'temperature',
    key: 'temperature',
    width: 100
  },
  {
    title: '血压',
    dataIndex: 'pressure',
    key: 'pressure',
    width: 120
  },
  {
    title: '体重(kg)',
    dataIndex: 'weight',
    key: 'weight',
    width: 100
  },
  {
    title: '身高(cm)',
    dataIndex: 'height',
    key: 'height',
    width: 100
  },
  {
    title: '健康状态',
    key: 'status',
    width: 100
  },
  {
    title: '备注',
    dataIndex: 'remark',
    key: 'remark'
  },
  {
    title: '操作',
    key: 'action',
    width: 120,
    fixed: 'right'
  }
];

const getHealthStatus = (record: any) => {
  const temp = parseFloat(record.temperature);
  const weight = parseFloat(record.weight);
  
  if (temp >= 37.3) {
    return { color: 'red', text: '发热' };
  } else if (temp < 36.0) {
    return { color: 'blue', text: '体温偏低' };
  } else {
    return { color: 'green', text: '正常' };
  }
};

const loadHealthRecords = async () => {
  loading.value = true;
  try {
    const response = await listApi({});
    if (response.code === 0) {
      // 过滤只显示当前用户的记录
      const currentUser = userStore.admin_user_nickname || userStore.admin_user_name;
      console.log('当前用户:', currentUser);
      console.log('所有健康记录:', response.data);

      healthRecords.value = response.data.filter((record: any) =>
        record.title === currentUser
      ).sort((a: any, b: any) => new Date(b.create_time).getTime() - new Date(a.create_time).getTime());

      console.log('过滤后的健康记录:', healthRecords.value);

      if (healthRecords.value.length === 0) {
        message.info('暂无健康记录，请添加您的健康数据');
      }
    }
  } catch (error) {
    console.error('加载健康记录失败:', error);
    message.error('加载健康记录失败');
  } finally {
    loading.value = false;
  }
};

const showAddModal = () => {
  modalVisible.value = true;
  modalTitle.value = '添加健康记录';
  isEdit.value = false;
  resetForm();
};

const editRecord = (record: any) => {
  modalVisible.value = true;
  modalTitle.value = '编辑健康记录';
  isEdit.value = true;
  Object.assign(formData, record);
};

const viewRecord = (record: any) => {
  message.info(`查看健康记录: ${record.create_time}`);
};

const resetForm = () => {
  Object.assign(formData, {
    id: undefined,
    temperature: '',
    pressure: '',
    weight: '',
    height: '',
    remark: ''
  });
};

const handleSubmit = async () => {
  try {
    await formRef.value.validate();
    submitting.value = true;

    const submitData = {
      ...formData,
      title: userStore.admin_user_nickname || userStore.admin_user_name,
      sex: '未知',
      age: '未知'
    };

    if (isEdit.value) {
      await updateApi({ id: formData.id }, submitData);
      message.success('健康记录更新成功');
    } else {
      await createApi(submitData);
      message.success('健康记录添加成功');
    }

    modalVisible.value = false;
    loadHealthRecords();
  } catch (error) {
    message.error('操作失败');
  } finally {
    submitting.value = false;
  }
};

const handleCancel = () => {
  modalVisible.value = false;
  resetForm();
};

onMounted(() => {
  loadHealthRecords();
});
</script>

<style lang="less" scoped>
.my-health-container {
  padding: 24px;
  background: #f5f7fa;
  min-height: 100vh;
}

.health-overview {
  margin-bottom: 24px;
}

.health-card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  }
}

.health-item {
  display: flex;
  align-items: center;
  padding: 8px 0;
}

.health-icon {
  margin-right: 16px;
}

.health-info {
  flex: 1;
}

.health-value {
  font-size: 24px;
  font-weight: bold;
  color: #262626;
  line-height: 1;
}

.health-label {
  font-size: 14px;
  color: #8c8c8c;
  margin-top: 4px;
}

.health-records {
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
</style>
