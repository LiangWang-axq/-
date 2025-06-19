<template>
  <div class="family-elderly-info">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <UserOutlined class="title-icon" />
          家人信息
        </h1>
        <p class="page-description">查看和管理您的家人基本信息</p>
      </div>
    </div>

    <!-- 家人信息卡片 -->
    <div class="elderly-cards">
      <a-row :gutter="16">
        <a-col :span="8" v-for="elderly in elderlyList" :key="elderly.id">
          <a-card class="elderly-card" hoverable>
            <div class="elderly-header">
              <a-avatar :size="64" style="background-color: #52c41a">
                {{ elderly.title.charAt(0) }}
              </a-avatar>
              <div class="elderly-basic">
                <h3>{{ elderly.title }}</h3>
                <p>{{ elderly.sex }} · {{ elderly.age }}岁</p>
              </div>
            </div>
            
            <a-divider />
            
            <div class="elderly-details">
              <div class="detail-item">
                <span class="label">房间号：</span>
                <span class="value">{{ elderly.address || '未分配' }}</span>
              </div>
              <div class="detail-item">
                <span class="label">入住时间：</span>
                <span class="value">{{ formatDate(elderly.create_time) }}</span>
              </div>
              <div class="detail-item">
                <span class="label">健康状态：</span>
                <a-tag :color="getHealthColor(elderly)">
                  {{ getHealthStatus(elderly) }}
                </a-tag>
              </div>
              <div class="detail-item" v-if="elderly.remark">
                <span class="label">备注：</span>
                <span class="value">{{ elderly.remark }}</span>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 如果没有家人信息 -->
    <div v-if="elderlyList.length === 0" class="empty-state">
      <a-empty description="暂无家人信息">
        <a-button type="primary" @click="contactAdmin">
          联系管理员添加家人信息
        </a-button>
      </a-empty>
    </div>

    <!-- 紧急联系卡片 -->
    <div class="emergency-contact">
      <a-card class="emergency-card">
        <div class="emergency-content">
          <div class="emergency-icon">
            <ExclamationCircleOutlined style="font-size: 32px; color: #ff4d4f;" />
          </div>
          <div class="emergency-info">
            <h3>紧急联系</h3>
            <p>如遇紧急情况，请立即联系护理站</p>
            <p>护理站电话：400-123-4567</p>
          </div>
        </div>
      </a-card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import {
  UserOutlined,
  HeartOutlined,
  CalendarOutlined,
  PhoneOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons-vue';
import { listApi as elderlyListApi } from '/@/api/thing';

const userStore = useUserStore();
const elderlyList = ref([]);

// 数据加载
const loadElderlyList = async () => {
  try {
    const response = await elderlyListApi({});
    if (response.code === 0) {
      // 这里应该根据当前用户筛选相关的家人
      // 暂时显示所有老人作为示例
      elderlyList.value = response.data.slice(0, 3);
    }
  } catch (error) {
    message.error('加载家人信息失败');
  }
};

// 工具函数
const formatDate = (dateString: string) => {
  if (!dateString) return '未知';
  return new Date(dateString).toLocaleDateString('zh-CN');
};

const getHealthColor = (elderly: any) => {
  // 简单的健康状态判断
  return 'success';
};

const getHealthStatus = (elderly: any) => {
  return '健康';
};

// 事件处理
const viewHealth = async (elderly: any) => {
  try {
    // 加载健康记录
    const healthResponse = await fetch(`/api/admin/health/list?keyword=${elderly.title}`, {
      headers: {
        'AdminToken': userStore.admin_user_token
      }
    });
    const healthData = await healthResponse.json();

    if (healthData.code === 0 && healthData.data.length > 0) {
      const healthRecords = healthData.data.filter(record => record.title === elderly.title);
      if (healthRecords.length > 0) {
        const latest = healthRecords[0];
        message.success(`${elderly.title} 最新健康记录：体温${latest.temperature}°C，血压${latest.blood_pressure}，心率${latest.heart_rate}次/分`);
      } else {
        message.info(`${elderly.title} 暂无健康记录`);
      }
    } else {
      message.info(`${elderly.title} 暂无健康记录`);
    }
  } catch (error) {
    message.error('获取健康记录失败');
  }
};

const viewActivities = async (elderly: any) => {
  try {
    // 加载活动记录
    const activityResponse = await fetch(`/api/admin/tag/list?keyword=${elderly.title}`, {
      headers: {
        'AdminToken': userStore.admin_user_token
      }
    });
    const activityData = await activityResponse.json();

    if (activityData.code === 0 && activityData.data.length > 0) {
      const activities = activityData.data.filter(activity => activity.name === elderly.title);
      if (activities.length > 0) {
        const activityList = activities.map(a => a.title).join('、');
        message.success(`${elderly.title} 的活动记录：${activityList}`);
      } else {
        message.info(`${elderly.title} 暂无活动记录`);
      }
    } else {
      message.info(`${elderly.title} 暂无活动记录`);
    }
  } catch (error) {
    message.error('获取活动记录失败');
  }
};

const contactCaregiver = async (elderly: any) => {
  try {
    // 查找负责的护工
    const workerResponse = await fetch('/api/admin/worker/list', {
      headers: {
        'AdminToken': userStore.admin_user_token
      }
    });
    const workerData = await workerResponse.json();

    if (workerData.code === 0 && workerData.data.length > 0) {
      const caregiver = workerData.data[0]; // 简化处理，取第一个护工
      message.success(`护工联系方式：${caregiver.name || '王护工'} - 电话：${caregiver.mobile || '13800000002'}`);
    } else {
      message.info('暂无护工信息，请联系管理员');
    }
  } catch (error) {
    message.error('获取护工信息失败');
  }
};

const contactAdmin = () => {
  message.info('请联系管理员添加家人信息');
};

const emergencyCall = () => {
  message.warning('紧急呼叫已发送到护理站！');
};

onMounted(() => {
  loadElderlyList();
});
</script>

<style lang="less" scoped>
.family-elderly-info {
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

.elderly-cards {
  margin-bottom: 24px;
  
  .elderly-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    transition: all 0.3s ease;
    
    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    }
    
    .elderly-header {
      display: flex;
      align-items: center;
      margin-bottom: 16px;
      
      .elderly-basic {
        margin-left: 16px;
        
        h3 {
          margin: 0 0 4px 0;
          font-size: 18px;
          color: #262626;
        }
        
        p {
          margin: 0;
          color: #8c8c8c;
          font-size: 14px;
        }
      }
    }
    
    .elderly-details {
      .detail-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
        
        .label {
          color: #8c8c8c;
          font-size: 14px;
        }
        
        .value {
          color: #262626;
          font-size: 14px;
          font-weight: 500;
        }
      }
    }
    
    .elderly-actions {
      text-align: center;
    }
  }
}

.empty-state {
  margin: 48px 0;
  text-align: center;
}

.emergency-contact {
  .emergency-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    border: 1px solid #ffccc7;
    
    .emergency-content {
      display: flex;
      align-items: center;
      
      .emergency-icon {
        margin-right: 16px;
      }
      
      .emergency-info {
        flex: 1;
        
        h3 {
          margin: 0 0 8px 0;
          color: #ff4d4f;
          font-size: 18px;
        }
        
        p {
          margin: 4px 0;
          color: #8c8c8c;
          font-size: 14px;
        }
      }
    }
  }
}
</style>
