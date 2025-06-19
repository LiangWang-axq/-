<template>
  <div class="family-elderly-container">
    <!-- 家人概览 -->
    <div class="family-overview">
      <a-row :gutter="24">
        <a-col :span="16">
          <a-card class="elderly-profile" v-if="elderlyInfo">
            <div class="profile-header">
              <a-avatar :size="80" :style="{ backgroundColor: '#1890ff' }">
                {{ elderlyInfo.title?.charAt(0) }}
              </a-avatar>
              <div class="profile-info">
                <h2>{{ elderlyInfo.title }}</h2>
                <p class="profile-desc">{{ elderlyInfo.age }}岁 · {{ elderlyInfo.sex }} · 房间号: {{ elderlyInfo.room }}</p>
                <div class="profile-tags">
                  <a-tag color="blue">{{ elderlyInfo.care_level }}</a-tag>
                  <a-tag :color="getHealthColor()">{{ getHealthStatus() }}</a-tag>
                </div>
              </div>
            </div>
            
            <a-divider />
            
            <a-row :gutter="16">
              <a-col :span="8">
                <div class="info-item">
                  <div class="info-label">入住时间</div>
                  <div class="info-value">{{ formatDate(elderlyInfo.admission_date) }}</div>
                </div>
              </a-col>
              <a-col :span="8">
                <div class="info-item">
                  <div class="info-label">紧急联系人</div>
                  <div class="info-value">{{ elderlyInfo.emergency_contact }}</div>
                </div>
              </a-col>
            </a-row>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 最近动态 -->
    <a-card title="最近动态" class="recent-activities" style="margin-top: 24px;">
      <a-timeline>
        <a-timeline-item v-for="activity in recentActivities" :key="activity.id" :color="activity.color">
          <template #dot>
            <component :is="activity.icon" />
          </template>
          <div class="activity-item">
            <div class="activity-header">
              <span class="activity-title">{{ activity.title }}</span>
              <span class="activity-time">{{ activity.time }}</span>
            </div>
            <div class="activity-desc">{{ activity.description }}</div>
          </div>
        </a-timeline-item>
      </a-timeline>
    </a-card>
      <a-col :span="12">
        <a-card title="本月服务记录" class="service-summary">
          <div class="service-stats">
            <div class="stat-item">
              <div class="stat-number">12</div>
              <div class="stat-label">送餐服务</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">8</div>
              <div class="stat-label">保洁服务</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">6</div>
              <div class="stat-label">医疗护理</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">4</div>
              <div class="stat-label">康复训练</div>
            </div>
          </div>
        </a-card>
      </a-col>
    </a-row>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import dayjs from 'dayjs';
import { 
  HeartOutlined, 
  CalendarOutlined, 
  PhoneOutlined, 
  UserOutlined,
  DashboardOutlined,
  ScaleOutlined,
  ArrowUpOutlined,
  ArrowDownOutlined,
  MinusOutlined,
  CheckCircleOutlined,
  MedicineBoxOutlined,
  ClockCircleOutlined
} from '@ant-design/icons-vue';
import { listApi as thingListApi } from '/@/api/thing';
import { useUserStore } from '/@/store';

const userStore = useUserStore();
const visitModalVisible = ref(false);
const visitSubmitting = ref(false);

const elderlyInfo = ref(null);
const recentActivities = ref([]);

const visitData = reactive({
  date: undefined,
  visitors: 1,
  remark: ''
});

const getHealthColor = () => {
  return 'green'; // 根据实际健康状态返回颜色
};

const getHealthStatus = () => {
  return '健康良好'; // 根据实际健康状态返回文本
};

const formatDate = (dateString: string) => {
  return dateString ? dayjs(dateString).format('YYYY-MM-DD') : '未知';
};

const loadElderlyInfo = async () => {
  try {
    const response = await thingListApi({});
    if (response.code === 0 && response.data.length > 0) {
      // 模拟获取家人信息（实际应该根据当前用户关联的老人）
      elderlyInfo.value = {
        ...response.data[0],
        room: 'A101',
        care_level: '二级护理',
        admission_date: '2024-01-15',
        caregiver: '张护工',
        emergency_contact: userStore.admin_user_name
      };
    }
  } catch (error) {
    message.error('加载家人信息失败');
  }
};

const loadRecentActivities = () => {
  recentActivities.value = [
    {
      id: 1,
      title: '健康检查',
      description: '完成了血压、体温测量，各项指标正常',
      time: '2小时前',
      color: 'green',
      icon: 'CheckCircleOutlined'
    },
    {
      id: 2,
      title: '用餐服务',
      description: '享用了营养午餐，食欲良好',
      time: '4小时前',
      color: 'blue',
      icon: 'ClockCircleOutlined'
    },
    {
      id: 3,
      title: '康复训练',
      description: '完成了30分钟的康复训练',
      time: '昨天',
      color: 'orange',
      icon: 'MedicineBoxOutlined'
    },
    {
      id: 4,
      title: '家属探视',
      description: '您上次的探视记录',
      time: '3天前',
      color: 'purple',
      icon: 'UserOutlined'
    }
  ];
};

const viewHealthRecords = () => {
  message.info('查看健康记录功能');
};

const viewActivities = () => {
  message.info('查看活动安排功能');
};

const contactCaregiver = () => {
  message.info('联系护工功能');
};

const bookVisit = () => {
  visitModalVisible.value = true;
};

const handleVisitSubmit = async () => {
  if (!visitData.date) {
    message.warning('请选择探视时间');
    return;
  }

  visitSubmitting.value = true;
  try {
    // 这里应该调用预约探视的API
    await new Promise(resolve => setTimeout(resolve, 1000)); // 模拟API调用
    message.success('探视预约成功');
    visitModalVisible.value = false;
  } catch (error) {
    message.error('预约失败');
  } finally {
    visitSubmitting.value = false;
  }
};

const handleVisitCancel = () => {
  visitModalVisible.value = false;
  Object.assign(visitData, {
    date: undefined,
    visitors: 1,
    remark: ''
  });
};

onMounted(() => {
  loadElderlyInfo();
  loadRecentActivities();
});
</script>

<style lang="less" scoped>
.family-elderly-container {
  padding: 24px;
  background: #f5f7fa;
  min-height: 100vh;
}

.elderly-profile, .quick-actions, .recent-activities, .health-chart, .service-summary {
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

.profile-header {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
  
  .profile-info {
    margin-left: 24px;
    flex: 1;
    
    h2 {
      margin: 0 0 8px 0;
      color: #262626;
    }
    
    .profile-desc {
      color: #8c8c8c;
      margin: 0 0 12px 0;
    }
    
    .profile-tags {
      .ant-tag {
        margin-right: 8px;
      }
    }
  }
}

.info-item {
  text-align: center;
  
  .info-label {
    color: #8c8c8c;
    font-size: 12px;
    margin-bottom: 4px;
  }
  
  .info-value {
    color: #262626;
    font-weight: 500;
  }
}

.activity-item {
  .activity-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 4px;
    
    .activity-title {
      font-weight: 600;
      color: #262626;
    }
    
    .activity-time {
      color: #8c8c8c;
      font-size: 12px;
    }
  }
  
  .activity-desc {
    color: #595959;
    font-size: 14px;
  }
}

.health-metrics {
  .metric-item {
    display: flex;
    align-items: center;
    padding: 16px 0;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
      border-bottom: none;
    }
    
    .metric-icon {
      margin-right: 16px;
    }
    
    .metric-info {
      flex: 1;
      
      .metric-value {
        font-size: 18px;
        font-weight: 600;
        color: #262626;
      }
      
      .metric-label {
        color: #8c8c8c;
        font-size: 12px;
      }
    }
    
    .metric-trend {
      margin-left: 16px;
    }
  }
}

.service-stats {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  
  .stat-item {
    text-align: center;
    
    .stat-number {
      font-size: 32px;
      font-weight: bold;
      color: #1890ff;
      margin-bottom: 8px;
    }
    
    .stat-label {
      color: #8c8c8c;
      font-size: 14px;
    }
  }
}
</style>
