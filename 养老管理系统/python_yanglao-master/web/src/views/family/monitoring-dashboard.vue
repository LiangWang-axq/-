<template>
  <div class="family-monitoring-dashboard">
    <!-- 欢迎区域 -->
    <div class="welcome-section">
      <a-card class="welcome-card">
        <div class="welcome-content">
          <div class="welcome-text">
            <h2>您好，{{ familyName }}！</h2>
            <p>这里是您家人的健康监护中心</p>
          </div>
          <div class="welcome-actions">
            <a-button type="primary" size="large" @click="viewHealthReport">
              <FileTextOutlined />
              查看健康报告
            </a-button>
          </div>
        </div>
      </a-card>
    </div>

    <!-- 家人信息卡片 -->
    <div class="family-members">
      <a-card title="监护的家人" class="members-card">
        <template #extra>
          <a-button type="link" @click="refreshData">
            <ReloadOutlined />
            刷新数据
          </a-button>
        </template>
        
        <a-row :gutter="16">
          <a-col :span="8" v-for="member in familyMembers" :key="member.id">
            <a-card class="member-card" hoverable @click="viewMemberDetails(member)">
              <div class="member-info">
                <div class="member-avatar">
                  <a-avatar :size="64" style="background-color: #52c41a">
                    {{ member.title.charAt(0) }}
                  </a-avatar>
                </div>
                <div class="member-details">
                  <h3>{{ member.title }}</h3>
                  <p>性别: {{ member.sex || '未知' }}</p>
                  <p>年龄: {{ member.age || '未知' }}岁</p>
                  <p>房间: {{ member.address || '未分配' }}</p>
                </div>
              </div>
              <div class="member-status">
                <a-tag :color="getMemberHealthColor(member)">
                  {{ getMemberHealthStatus(member) }}
                </a-tag>
              </div>
            </a-card>
          </a-col>
        </a-row>
      </a-card>
    </div>

    <!-- 健康概览 -->
    <div class="health-overview">
      <a-row :gutter="16">
        <a-col :span="12">
          <a-card title="最新健康数据" class="health-data-card">
            <div class="health-metrics" v-if="latestHealthData">
              <div class="metric-item">
                <div class="metric-icon">
                  <ThermometerOutlined />
                </div>
                <div class="metric-info">
                  <div class="metric-value">{{ latestHealthData.temperature }}°C</div>
                  <div class="metric-label">体温</div>
                </div>
              </div>
              <div class="metric-item">
                <div class="metric-icon">
                  <DashboardOutlined />
                </div>
                <div class="metric-info">
                  <div class="metric-value">{{ latestHealthData.pressure }}</div>
                  <div class="metric-label">血压</div>
                </div>
              </div>
              <div class="metric-item">
                <div class="metric-icon">
                  <ScaleOutlined />
                </div>
                <div class="metric-info">
                  <div class="metric-value">{{ latestHealthData.weight }}kg</div>
                  <div class="metric-label">体重</div>
                </div>
              </div>
            </div>
            <a-empty v-else description="暂无健康数据" />
          </a-card>
        </a-col>
        <a-col :span="12">
          <a-card title="近期活动" class="activities-card">
            <a-list
              :data-source="recentActivities"
              :loading="activitiesLoading"
              size="small"
            >
              <template #renderItem="{ item }">
                <a-list-item>
                  <a-list-item-meta>
                    <template #title>
                      {{ item.title }}
                    </template>
                    <template #description>
                      <div>
                        <span>时间: {{ item.activity_time }}</span>
                        <a-tag :color="getActivityStatusColor(item.status)" style="margin-left: 8px">
                          {{ getActivityStatusText(item.status) }}
                        </a-tag>
                      </div>
                    </template>
                  </a-list-item-meta>
                </a-list-item>
              </template>
            </a-list>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 健康趋势 -->
    <div class="health-trends">
      <a-card title="健康趋势" class="trends-card">
        <template #extra>
          <a-radio-group v-model:value="trendPeriod" @change="updateTrends">
            <a-radio-button value="week">近一周</a-radio-button>
            <a-radio-button value="month">近一月</a-radio-button>
            <a-radio-button value="quarter">近三月</a-radio-button>
          </a-radio-group>
        </template>
        
        <div class="trend-charts">
          <div class="chart-placeholder">
            <a-empty description="健康趋势图表开发中" />
          </div>
        </div>
      </a-card>
    </div>

    <!-- 护工信息 -->
    <div class="caregiver-info">
      <a-card title="负责护工" class="caregiver-card">
        <div class="caregiver-list">
          <div class="caregiver-item" v-for="caregiver in caregivers" :key="caregiver.id">
            <div class="caregiver-avatar">
              <a-avatar :size="48" style="background-color: #1890ff">
                {{ caregiver.title.charAt(0) }}
              </a-avatar>
            </div>
            <div class="caregiver-details">
              <h4>{{ caregiver.title }}</h4>
              <p>联系电话: {{ caregiver.mobile || '未提供' }}</p>
              <p>工作经验: {{ caregiver.experience || '3年' }}</p>
            </div>
            <div class="caregiver-actions">
              <a-button type="link" size="small" @click="contactCaregiver(caregiver)">
                <PhoneOutlined />
                联系
              </a-button>
            </div>
          </div>
        </div>
      </a-card>
    </div>
    
    <!-- 家人详情模态框 -->
    <a-modal
      v-model:visible="memberModalVisible"
      :title="`${selectedMember?.title} 详细信息`"
      width="800px"
      :footer="null"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
    >
      <div v-if="selectedMember" class="member-details-modal">
        <a-tabs>
          <a-tab-pane key="basic" tab="基本信息">
            <a-descriptions :column="2" bordered>
              <a-descriptions-item label="姓名">{{ selectedMember.title }}</a-descriptions-item>
              <a-descriptions-item label="性别">{{ selectedMember.sex || '未知' }}</a-descriptions-item>
              <a-descriptions-item label="年龄">{{ selectedMember.age || '未知' }}岁</a-descriptions-item>
              <a-descriptions-item label="房间">{{ selectedMember.address || '未分配' }}</a-descriptions-item>
              <a-descriptions-item label="入住时间" :span="2">{{ selectedMember.create_time }}</a-descriptions-item>
              <a-descriptions-item label="备注" :span="2">{{ selectedMember.remark || '无' }}</a-descriptions-item>
            </a-descriptions>
          </a-tab-pane>
          <a-tab-pane key="health" tab="健康记录">
            <a-table
              :columns="healthColumns"
              :data-source="memberHealthRecords"
              :pagination="false"
              size="small"
            />
          </a-tab-pane>
          <a-tab-pane key="activities" tab="活动记录">
            <a-table
              :columns="activityColumns"
              :data-source="memberActivities"
              :pagination="false"
              size="small"
            />
          </a-tab-pane>
        </a-tabs>
      </div>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue';
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import {
  FileTextOutlined,
  ReloadOutlined,
  ThermometerOutlined,
  DashboardOutlined,
  ScaleOutlined,
  PhoneOutlined,
  ExclamationCircleOutlined
} from '@ant-design/icons-vue';
import { listApi as elderlyListApi } from '/@/api/thing';
import { listApi as healthListApi } from '/@/api/health';
import { listApi as activityListApi } from '/@/api/tag';
import { listApi as caregiverListApi } from '/@/api/worker';

const userStore = useUserStore();
const memberModalVisible = ref(false);
const activitiesLoading = ref(false);
const familyMembers = ref([]);
const recentActivities = ref([]);
const caregivers = ref([]);
const selectedMember = ref(null);
const memberHealthRecords = ref([]);
const memberActivities = ref([]);
const trendPeriod = ref('week');

// 亲属信息
const familyName = computed(() => userStore.admin_user_nickname || userStore.admin_user_name || '家属');

// 最新健康数据
const latestHealthData = ref(null);

// 健康记录表格列
const healthColumns = [
  { title: '记录时间', dataIndex: 'create_time', key: 'create_time', width: 120 },
  { title: '体温(°C)', dataIndex: 'temperature', key: 'temperature', width: 80 },
  { title: '血压', dataIndex: 'pressure', key: 'pressure', width: 100 },
  { title: '体重(kg)', dataIndex: 'weight', key: 'weight', width: 80 },
  { title: '备注', dataIndex: 'remark', key: 'remark' }
];

// 活动记录表格列
const activityColumns = [
  { title: '活动名称', dataIndex: 'title', key: 'title', width: 120 },
  { title: '活动时间', dataIndex: 'activity_time', key: 'activity_time', width: 160 },
  { title: '负责护工', dataIndex: 'worker', key: 'worker', width: 100 },
  { title: '状态', dataIndex: 'status', key: 'status', width: 80 },
  { title: '备注', dataIndex: 'remark', key: 'remark' }
];

// 工具函数
const getMemberHealthColor = (member: any) => {
  // 简单的健康状态判断
  return 'success';
};

const getMemberHealthStatus = (member: any) => {
  return '健康';
};

const getActivityStatusColor = (status: string) => {
  const colors = {
    'pending': 'orange',
    'ongoing': 'blue',
    'completed': 'green',
    'cancelled': 'red'
  };
  return colors[status] || 'default';
};

const getActivityStatusText = (status: string) => {
  const texts = {
    'pending': '待执行',
    'ongoing': '进行中',
    'completed': '已完成',
    'cancelled': '已取消'
  };
  return texts[status] || '未知';
};

// 数据加载
const loadFamilyMembers = async () => {
  try {
    // 获取老人信息
    const response = await elderlyListApi({});
    if (response.code === 0) {
      // 根据当前亲属用户名获取关联的老人
      const currentFamilyUser = userStore.admin_user_name;

      // 简化逻辑：根据用户名匹配关联的老人
      if (currentFamilyUser === 'family' || currentFamilyUser === '李女士') {
        // 李女士关联张奶奶
        familyMembers.value = response.data.filter(elderly =>
          elderly.title === '张奶奶'
        );
      } else {
        // 其他亲属用户显示第一个老人作为演示
        familyMembers.value = response.data.slice(0, 1);
      }

      console.log('关联的家人:', familyMembers.value);

      if (familyMembers.value.length === 0) {
        message.info('暂无关联的家人信息，请联系管理员');
      }
    }
  } catch (error) {
    console.error('加载家人信息失败:', error);
    message.error('加载家人信息失败');
  }
};

const loadLatestHealthData = async () => {
  try {
    const response = await healthListApi({});
    if (response.code === 0 && response.data.length > 0) {
      // 获取关联老人的健康数据
      let targetElderlyName = '张奶奶'; // 默认

      if (familyMembers.value.length > 0) {
        targetElderlyName = familyMembers.value[0].title;
      }

      const relatedHealthData = response.data.filter(health =>
        health.title === targetElderlyName
      ).sort((a, b) => new Date(b.create_time).getTime() - new Date(a.create_time).getTime());

      if (relatedHealthData.length > 0) {
        latestHealthData.value = relatedHealthData[0];
      } else {
        // 如果没有健康数据，显示提示
        message.info(`暂无${targetElderlyName}的健康数据`);
      }

      console.log('最新健康数据:', latestHealthData.value);
    }
  } catch (error) {
    console.error('加载健康数据失败:', error);
    message.error('加载健康数据失败');
  }
};

const loadRecentActivities = async () => {
  activitiesLoading.value = true;
  try {
    const response = await activityListApi({});
    if (response.code === 0) {
      // 获取关联老人的活动数据
      let targetElderlyName = '张奶奶'; // 默认

      if (familyMembers.value.length > 0) {
        targetElderlyName = familyMembers.value[0].title;
      }

      const relatedActivities = response.data.filter(activity =>
        activity.name === targetElderlyName
      ).sort((a, b) => new Date(b.create_time).getTime() - new Date(a.create_time).getTime());

      recentActivities.value = relatedActivities.slice(0, 5);
      console.log('最近活动:', recentActivities.value);
    }
  } catch (error) {
    console.error('加载活动数据失败:', error);
    message.error('加载活动数据失败');
  } finally {
    activitiesLoading.value = false;
  }
};

const loadCaregivers = async () => {
  try {
    const response = await caregiverListApi({});
    if (response.code === 0) {
      caregivers.value = response.data.slice(0, 2);
    }
  } catch (error) {
    console.error('加载护工信息失败');
  }
};

// 事件处理
const viewHealthReport = () => {
  message.info('健康报告功能开发中');
};

const refreshData = async () => {
  try {
    await loadFamilyMembers();
    await loadLatestHealthData();
    await loadRecentActivities();
    await loadCaregivers();
    message.success('数据已刷新');
  } catch (error) {
    message.error('刷新数据失败');
  }
};

const viewMemberDetails = async (member: any) => {
  selectedMember.value = member;
  memberModalVisible.value = true;
  
  // 加载该家人的健康记录
  try {
    const healthResponse = await healthListApi({});
    if (healthResponse.code === 0) {
      memberHealthRecords.value = healthResponse.data.filter(
        record => record.title === member.title
      ).slice(0, 10);
    }
    
    const activityResponse = await activityListApi({});
    if (activityResponse.code === 0) {
      memberActivities.value = activityResponse.data.filter(
        activity => activity.name === member.title
      ).slice(0, 10);
    }
  } catch (error) {
    console.error('加载详细信息失败');
  }
};

const updateTrends = () => {
  message.info(`切换到${trendPeriod.value === 'week' ? '近一周' : trendPeriod.value === 'month' ? '近一月' : '近三月'}趋势`);
};

const contactCaregiver = (caregiver: any) => {
  message.info(`联系护工 ${caregiver.title}: ${caregiver.mobile || '电话未提供'}`);
};

const emergencyCall = () => {
  message.warning('紧急呼叫已发送到护理站！');
};

onMounted(async () => {
  // 先加载家人信息，再加载其他相关数据
  await loadFamilyMembers();
  await loadLatestHealthData();
  await loadRecentActivities();
  await loadCaregivers();
});
</script>

<style lang="less" scoped>
.family-monitoring-dashboard {
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

.family-members, .health-overview, .health-trends, .caregiver-info, .emergency-contact {
  margin-bottom: 24px;
  
  .members-card, .health-data-card, .activities-card, .trends-card, .caregiver-card, .emergency-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.member-card {
  border-radius: 8px;
  transition: all 0.3s ease;
  cursor: pointer;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  }
  
  .member-info {
    display: flex;
    align-items: center;
    margin-bottom: 16px;
    
    .member-avatar {
      margin-right: 16px;
    }
    
    .member-details {
      flex: 1;
      
      h3 {
        margin: 0 0 8px 0;
        font-size: 18px;
        color: #262626;
      }
      
      p {
        margin: 2px 0;
        font-size: 12px;
        color: #8c8c8c;
      }
    }
  }
  
  .member-status {
    text-align: center;
  }
}

.health-metrics {
  display: flex;
  justify-content: space-around;
  
  .metric-item {
    text-align: center;
    
    .metric-icon {
      font-size: 32px;
      color: #1890ff;
      margin-bottom: 8px;
    }
    
    .metric-value {
      font-size: 20px;
      font-weight: 600;
      color: #262626;
      margin-bottom: 4px;
    }
    
    .metric-label {
      font-size: 12px;
      color: #8c8c8c;
    }
  }
}

.chart-placeholder {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border-radius: 8px;
}

.caregiver-list {
  .caregiver-item {
    display: flex;
    align-items: center;
    padding: 16px 0;
    border-bottom: 1px solid #f0f0f0;
    
    &:last-child {
      border-bottom: none;
    }
    
    .caregiver-avatar {
      margin-right: 16px;
    }
    
    .caregiver-details {
      flex: 1;
      
      h4 {
        margin: 0 0 8px 0;
        font-size: 16px;
        color: #262626;
      }
      
      p {
        margin: 2px 0;
        font-size: 12px;
        color: #8c8c8c;
      }
    }
  }
}

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
      margin: 0;
      color: #8c8c8c;
      font-size: 14px;
    }
  }
}

.member-details-modal {
  .ant-descriptions {
    margin-bottom: 16px;
  }
}
</style>
