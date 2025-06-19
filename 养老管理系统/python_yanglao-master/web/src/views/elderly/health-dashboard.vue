<template>
  <div class="elderly-health-dashboard">
    <!-- 欢迎区域 -->
    <div class="welcome-section">
      <a-card class="welcome-card">
        <div class="welcome-content">
          <div class="welcome-text">
            <h2>您好，{{ userName }}！</h2>
            <p>今天是 {{ currentDate }}，祝您身体健康！</p>
          </div>
          <div class="welcome-actions">
            <a-button type="primary" size="large" @click="recordHealth">
              <PlusOutlined />
              记录健康数据
            </a-button>
          </div>
        </div>
      </a-card>
    </div>

    <!-- 健康概览 -->
    <div class="health-overview">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card class="health-card temperature-card">
            <div class="health-item">
              <div class="health-icon">
                <ThermometerOutlined />
              </div>
              <div class="health-info">
                <div class="health-value">{{ healthData.temperature }}°C</div>
                <div class="health-label">体温</div>
                <div class="health-status" :class="getTemperatureStatus(healthData.temperature)">
                  {{ getTemperatureText(healthData.temperature) }}
                </div>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="health-card pressure-card">
            <div class="health-item">
              <div class="health-icon">
                <DashboardOutlined />
              </div>
              <div class="health-info">
                <div class="health-value">{{ healthData.pressure }}</div>
                <div class="health-label">血压</div>
                <div class="health-status" :class="getPressureStatus(healthData.pressure)">
                  {{ getPressureText(healthData.pressure) }}
                </div>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="health-card weight-card">
            <div class="health-item">
              <div class="health-icon">
                <ScaleOutlined />
              </div>
              <div class="health-info">
                <div class="health-value">{{ healthData.weight }}kg</div>
                <div class="health-label">体重</div>
                <div class="health-status normal">
                  正常范围
                </div>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="health-card bmi-card">
            <div class="health-item">
              <div class="health-icon">
                <CalculatorOutlined />
              </div>
              <div class="health-info">
                <div class="health-value">{{ calculateBMI() }}</div>
                <div class="health-label">BMI指数</div>
                <div class="health-status" :class="getBMIStatus(calculateBMI())">
                  {{ getBMIText(calculateBMI()) }}
                </div>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 最近记录 -->
    <div class="recent-records">
      <a-card title="最近健康记录" class="records-card">
        <template #extra>
          <a-button type="link" @click="viewAllRecords">查看全部</a-button>
        </template>
        <a-table
          :columns="recordColumns"
          :data-source="recentRecords"
          :pagination="false"
          size="small"
        >
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'status'">
              <a-tag :color="getHealthStatusColor(record)">
                {{ getHealthStatusText(record) }}
              </a-tag>
            </template>
          </template>
        </a-table>
      </a-card>
    </div>

    <!-- 健康建议 -->
    <div class="health-suggestions">
      <a-card title="健康建议" class="suggestions-card">
        <div class="suggestion-list">
          <div class="suggestion-item" v-for="suggestion in healthSuggestions" :key="suggestion.id">
            <div class="suggestion-icon">
              <component :is="suggestion.icon" :style="{ color: suggestion.color }" />
            </div>
            <div class="suggestion-content">
              <div class="suggestion-title">{{ suggestion.title }}</div>
              <div class="suggestion-desc">{{ suggestion.description }}</div>
            </div>
          </div>
        </div>
      </a-card>
    </div>

    <!-- 健康记录模态框 -->
    <a-modal
      v-model:visible="healthModalVisible"
      title="记录健康数据"
      width="600px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
    >
      <template #footer>
        <a-button @click="healthModalVisible = false">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="submitHealthRecord">
          保存记录
        </a-button>
      </template>
      
      <a-form
        ref="healthFormRef"
        :model="healthForm"
        :rules="healthRules"
        layout="vertical"
      >
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="体温(°C)" name="temperature">
              <a-input v-model:value="healthForm.temperature" placeholder="36.5" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="血压" name="pressure">
              <a-input v-model:value="healthForm.pressure" placeholder="120/80" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="体重(kg)" name="weight">
              <a-input v-model:value="healthForm.weight" placeholder="65" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="身高(cm)" name="height">
              <a-input v-model:value="healthForm.height" placeholder="170" />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="备注" name="remark">
              <a-textarea v-model:value="healthForm.remark" placeholder="请输入健康状况备注" :rows="3" />
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
import { useUserStore } from '/@/store';
import {
  PlusOutlined,
  ThermometerOutlined,
  DashboardOutlined,
  ScaleOutlined,
  CalculatorOutlined,
  HeartOutlined,
  SafetyOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons-vue';
import { listApi, createApi } from '/@/api/health';

const userStore = useUserStore();
const healthModalVisible = ref(false);
const submitting = ref(false);
const recentRecords = ref([]);
const healthFormRef = ref();

// 用户信息
const userName = computed(() => userStore.admin_user_nickname || userStore.admin_user_name || '用户');
const currentDate = computed(() => new Date().toLocaleDateString('zh-CN', { 
  year: 'numeric', 
  month: 'long', 
  day: 'numeric',
  weekday: 'long'
}));

// 健康数据
const healthData = reactive({
  temperature: '36.5',
  pressure: '120/80',
  weight: '65',
  height: '170'
});

// 健康记录表单
const healthForm = reactive({
  temperature: '',
  pressure: '',
  weight: '',
  height: '',
  remark: ''
});

// 表单验证规则
const healthRules = {
  temperature: [
    { required: true, message: '请输入体温', trigger: 'blur' }
  ],
  pressure: [
    { required: true, message: '请输入血压', trigger: 'blur' }
  ],
  weight: [
    { required: true, message: '请输入体重', trigger: 'blur' }
  ],
  height: [
    { required: true, message: '请输入身高', trigger: 'blur' }
  ]
};

// 表格列定义
const recordColumns = [
  {
    title: '记录时间',
    dataIndex: 'create_time',
    key: 'create_time',
    width: 120
  },
  {
    title: '体温(°C)',
    dataIndex: 'temperature',
    key: 'temperature',
    width: 80
  },
  {
    title: '血压',
    dataIndex: 'pressure',
    key: 'pressure',
    width: 100
  },
  {
    title: '体重(kg)',
    dataIndex: 'weight',
    key: 'weight',
    width: 80
  },
  {
    title: '健康状态',
    key: 'status',
    width: 100
  }
];

// 健康建议
const healthSuggestions = computed(() => [
  {
    id: 1,
    icon: HeartOutlined,
    color: '#52c41a',
    title: '保持规律作息',
    description: '建议每天保持8小时充足睡眠，有助于身体恢复'
  },
  {
    id: 2,
    icon: SafetyOutlined,
    color: '#1890ff',
    title: '适量运动',
    description: '每天进行30分钟轻度运动，如散步、太极等'
  },
  {
    id: 3,
    icon: ExclamationCircleOutlined,
    color: '#fa8c16',
    title: '定期体检',
    description: '建议每月记录健康数据，及时发现身体变化'
  }
]);

// 工具函数
const calculateBMI = () => {
  const weight = parseFloat(healthData.weight);
  const height = parseFloat(healthData.height) / 100;
  if (weight && height) {
    return (weight / (height * height)).toFixed(1);
  }
  return '--';
};

const getTemperatureStatus = (temp: string) => {
  const temperature = parseFloat(temp);
  if (temperature < 36.0 || temperature > 37.5) return 'warning';
  return 'normal';
};

const getTemperatureText = (temp: string) => {
  const temperature = parseFloat(temp);
  if (temperature < 36.0) return '偏低';
  if (temperature > 37.5) return '偏高';
  return '正常';
};

const getPressureStatus = (pressure: string) => {
  // 简单的血压判断逻辑
  return 'normal';
};

const getPressureText = (pressure: string) => {
  return '正常';
};

const getBMIStatus = (bmi: string) => {
  const bmiValue = parseFloat(bmi);
  if (bmiValue < 18.5 || bmiValue > 24.9) return 'warning';
  return 'normal';
};

const getBMIText = (bmi: string) => {
  const bmiValue = parseFloat(bmi);
  if (bmiValue < 18.5) return '偏瘦';
  if (bmiValue > 24.9) return '偏胖';
  return '正常';
};

const getHealthStatusColor = (record: any) => {
  return 'success';
};

const getHealthStatusText = (record: any) => {
  return '正常';
};

// 事件处理
const recordHealth = () => {
  healthModalVisible.value = true;
  Object.assign(healthForm, {
    temperature: '',
    pressure: '',
    weight: '',
    height: '',
    remark: ''
  });
};

const submitHealthRecord = async () => {
  try {
    await healthFormRef.value.validate();
    submitting.value = true;
    
    const submitData = {
      title: userName.value,
      temperature: healthForm.temperature,
      pressure: healthForm.pressure,
      weight: healthForm.weight,
      height: healthForm.height,
      sex: '未知',
      age: '未知',
      remark: healthForm.remark
    };
    
    await createApi(submitData);
    message.success('健康数据记录成功');
    healthModalVisible.value = false;
    loadHealthData();
  } catch (error) {
    message.error('记录失败');
  } finally {
    submitting.value = false;
  }
};

const viewAllRecords = () => {
  // 跳转到完整的健康记录页面
  message.info('跳转到完整健康记录页面');
};

const loadHealthData = async () => {
  try {
    const response = await listApi({});
    if (response.code === 0) {
      const currentUserRecords = response.data.filter((record: any) => 
        record.title === userName.value
      );
      
      if (currentUserRecords.length > 0) {
        const latest = currentUserRecords[0];
        Object.assign(healthData, {
          temperature: latest.temperature || '36.5',
          pressure: latest.pressure || '120/80',
          weight: latest.weight || '65',
          height: latest.height || '170'
        });
      }
      
      recentRecords.value = currentUserRecords.slice(0, 5);
    }
  } catch (error) {
    console.error('加载健康数据失败');
  }
};

onMounted(() => {
  loadHealthData();
});
</script>

<style lang="less" scoped>
.elderly-health-dashboard {
  padding: 24px;
  background: #f5f5f5;
  min-height: 100vh;
}

.welcome-section {
  margin-bottom: 24px;
  
  .welcome-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    
    .welcome-content {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .welcome-text {
        h2 {
          margin: 0 0 8px 0;
          color: #262626;
          font-size: 24px;
        }
        
        p {
          margin: 0;
          color: #8c8c8c;
          font-size: 14px;
        }
      }
    }
  }
}

.health-overview {
  margin-bottom: 24px;
  
  .health-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    }
    
    .health-item {
      display: flex;
      align-items: center;
      
      .health-icon {
        font-size: 32px;
        margin-right: 16px;
        color: #1890ff;
      }
      
      .health-info {
        flex: 1;
        
        .health-value {
          font-size: 24px;
          font-weight: 600;
          color: #262626;
          margin-bottom: 4px;
        }
        
        .health-label {
          font-size: 14px;
          color: #8c8c8c;
          margin-bottom: 4px;
        }
        
        .health-status {
          font-size: 12px;
          padding: 2px 8px;
          border-radius: 4px;
          
          &.normal {
            background: #f6ffed;
            color: #52c41a;
          }
          
          &.warning {
            background: #fff7e6;
            color: #fa8c16;
          }
        }
      }
    }
  }
}

.recent-records, .health-suggestions {
  margin-bottom: 24px;
  
  .records-card, .suggestions-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.suggestion-list {
  .suggestion-item {
    display: flex;
    align-items: center;
    padding: 16px 0;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
      border-bottom: none;
    }
    
    .suggestion-icon {
      font-size: 24px;
      margin-right: 16px;
    }
    
    .suggestion-content {
      flex: 1;
      
      .suggestion-title {
        font-size: 16px;
        font-weight: 500;
        color: #262626;
        margin-bottom: 4px;
      }
      
      .suggestion-desc {
        font-size: 14px;
        color: #8c8c8c;
      }
    }
  }
}
</style>
