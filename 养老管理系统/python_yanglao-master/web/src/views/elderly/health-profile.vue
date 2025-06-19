<template>
  <div class="health-profile-container">
    <div class="header-section">
      <h2>健康档案</h2>
      <p class="subtitle">您的个人健康档案管理</p>
    </div>

    <!-- 个人信息卡片 -->
    <a-card title="基本信息" class="profile-card" style="margin-bottom: 20px;">
      <a-row :gutter="24">
        <a-col :span="8">
          <div class="info-item">
            <label>姓名：</label>
            <span>{{ userProfile.name || userStore.admin_user_nickname || '张奶奶' }}</span>
          </div>
        </a-col>
        <a-col :span="8">
          <div class="info-item">
            <label>年龄：</label>
            <span>{{ userProfile.age || '78' }}岁</span>
          </div>
        </a-col>
        <a-col :span="8">
          <div class="info-item">
            <label>性别：</label>
            <span>{{ userProfile.gender || '女' }}</span>
          </div>
        </a-col>
        <a-col :span="8">
          <div class="info-item">
            <label>身高：</label>
            <span>{{ userProfile.height || '160' }}cm</span>
          </div>
        </a-col>
        <a-col :span="8">
          <div class="info-item">
            <label>血型：</label>
            <span>{{ userProfile.bloodType || 'A型' }}</span>
          </div>
        </a-col>
        <a-col :span="8">
          <div class="info-item">
            <label>联系电话：</label>
            <span>{{ userProfile.phone || '138****8888' }}</span>
          </div>
        </a-col>
      </a-row>
    </a-card>

    <!-- 健康指标趋势 -->
    <a-card title="健康指标趋势" class="trend-card" style="margin-bottom: 20px;">
      <a-row :gutter="16">
        <a-col :span="12">
          <div class="trend-item">
            <h4>体温趋势 (最近7天)</h4>
            <div class="trend-chart">
              <div class="chart-placeholder">
                <LineChartOutlined style="font-size: 48px; color: #1890ff;" />
                <p>体温变化平稳，保持在36.2°C - 36.8°C之间</p>
              </div>
            </div>
          </div>
        </a-col>
        <a-col :span="12">
          <div class="trend-item">
            <h4>血压趋势 (最近7天)</h4>
            <div class="trend-chart">
              <div class="chart-placeholder">
                <BarChartOutlined style="font-size: 48px; color: #52c41a;" />
                <p>血压稳定，收缩压120-135mmHg，舒张压75-85mmHg</p>
              </div>
            </div>
          </div>
        </a-col>
      </a-row>
    </a-card>

    <!-- 健康建议 -->
    <a-card title="健康建议" class="advice-card" style="margin-bottom: 20px;">
      <a-list :data-source="healthAdvice" item-layout="horizontal">
        <template #renderItem="{ item }">
          <a-list-item>
            <a-list-item-meta>
              <template #avatar>
                <a-avatar :style="{ backgroundColor: item.color }">
                  <component :is="item.icon" />
                </a-avatar>
              </template>
              <template #title>{{ item.title }}</template>
              <template #description>{{ item.description }}</template>
            </a-list-item-meta>
          </a-list-item>
        </template>
      </a-list>
    </a-card>

    <!-- 最近体检记录 -->
    <a-card title="最近体检记录" class="checkup-card">
      <a-table 
        :columns="checkupColumns" 
        :data-source="checkupRecords" 
        :pagination="false"
        size="small"
      >
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'status'">
            <a-tag :color="record.status === '正常' ? 'green' : 'orange'">
              {{ record.status }}
            </a-tag>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import {
  LineChartOutlined,
  BarChartOutlined,
  HeartOutlined,
  SafetyOutlined,
  MedicineBoxOutlined,
  CalendarOutlined
} from '@ant-design/icons-vue';

const userStore = useUserStore();

// 用户档案信息
const userProfile = reactive({
  name: '',
  age: '',
  gender: '',
  height: '',
  bloodType: '',
  phone: ''
});

// 健康建议数据
const healthAdvice = ref([
  {
    icon: HeartOutlined,
    color: '#f56a00',
    title: '适量运动',
    description: '建议每天进行30分钟的轻度运动，如散步、太极拳等'
  },
  {
    icon: SafetyOutlined,
    color: '#7cb305',
    title: '规律作息',
    description: '保持规律的作息时间，每天保证7-8小时的睡眠'
  },
  {
    icon: MedicineBoxOutlined,
    color: '#1890ff',
    title: '按时服药',
    description: '请按医嘱按时服用药物，不要随意停药或改变剂量'
  },
  {
    icon: CalendarOutlined,
    color: '#722ed1',
    title: '定期体检',
    description: '建议每3个月进行一次全面体检，及时了解身体状况'
  }
]);

// 体检记录表格列
const checkupColumns = [
  { title: '检查日期', dataIndex: 'date', key: 'date' },
  { title: '检查项目', dataIndex: 'item', key: 'item' },
  { title: '检查结果', dataIndex: 'result', key: 'result' },
  { title: '状态', dataIndex: 'status', key: 'status' }
];

// 体检记录数据
const checkupRecords = ref([
  {
    key: '1',
    date: '2025-06-15',
    item: '血常规',
    result: '各项指标正常',
    status: '正常'
  },
  {
    key: '2',
    date: '2025-06-10',
    item: '心电图',
    result: '心律正常',
    status: '正常'
  },
  {
    key: '3',
    date: '2025-06-05',
    item: '血压测量',
    result: '130/85 mmHg',
    status: '轻微偏高'
  },
  {
    key: '4',
    date: '2025-06-01',
    item: '血糖检测',
    result: '5.8 mmol/L',
    status: '正常'
  }
]);

// 加载用户档案
const loadUserProfile = () => {
  // 模拟加载用户档案数据
  Object.assign(userProfile, {
    name: userStore.admin_user_nickname || '张奶奶',
    age: '78',
    gender: '女',
    height: '160',
    bloodType: 'A型',
    phone: '138****8888'
  });
};

onMounted(() => {
  loadUserProfile();
});
</script>

<style scoped lang="less">
.health-profile-container {
  padding: 20px;
  background: #f5f5f5;
  min-height: 100vh;
}

.header-section {
  margin-bottom: 24px;
  
  h2 {
    color: #1890ff;
    margin-bottom: 8px;
  }
  
  .subtitle {
    color: #666;
    margin: 0;
  }
}

.profile-card {
  .info-item {
    margin-bottom: 16px;
    
    label {
      font-weight: bold;
      color: #333;
      margin-right: 8px;
    }
    
    span {
      color: #666;
    }
  }
}

.trend-card {
  .trend-item {
    text-align: center;
    
    h4 {
      margin-bottom: 16px;
      color: #333;
    }
    
    .trend-chart {
      .chart-placeholder {
        padding: 40px 20px;
        background: #fafafa;
        border-radius: 8px;
        border: 1px dashed #d9d9d9;
        
        p {
          margin-top: 16px;
          color: #666;
          font-size: 14px;
        }
      }
    }
  }
}

.advice-card {
  :deep(.ant-list-item-meta-title) {
    color: #1890ff;
    font-weight: bold;
  }
  
  :deep(.ant-list-item-meta-description) {
    color: #666;
  }
}

.checkup-card {
  :deep(.ant-table-tbody > tr > td) {
    padding: 12px 16px;
  }
}
</style>
