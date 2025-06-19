<template>
  <div class="family-activity-records">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <CalendarOutlined class="title-icon" />
          活动记录
        </h1>
        <p class="page-description">查看您家人的活动安排和参与记录</p>
      </div>
      <div class="header-actions">
        <a-button type="primary" size="large" @click="refreshData">
          <ReloadOutlined />
          刷新数据
        </a-button>
      </div>
    </div>

    <!-- 活动统计 -->
    <div class="activity-stats">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="本周活动"
              :value="activityStats.weeklyTotal"
              :value-style="{ color: '#1890ff' }"
            >
              <template #prefix>
                <CalendarOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="已完成"
              :value="activityStats.completed"
              :value-style="{ color: '#52c41a' }"
            >
              <template #prefix>
                <CheckCircleOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="进行中"
              :value="activityStats.ongoing"
              :value-style="{ color: '#fa8c16' }"
            >
              <template #prefix>
                <ClockCircleOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="参与率"
              :value="activityStats.participationRate"
              suffix="%"
              :value-style="{ color: '#722ed1' }"
            >
              <template #prefix>
                <TrophyOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 筛选和搜索 -->
    <div class="filter-section">
      <a-card class="filter-card">
        <a-row :gutter="16" align="middle">
          <a-col :span="6">
            <a-select
              v-model:value="filterForm.member"
              placeholder="选择家人"
              allowClear
              @change="handleFilter"
            >
              <a-select-option value="">全部家人</a-select-option>
              <a-select-option v-for="member in familyMembers" :key="member.id" :value="member.name">
                {{ member.name }}
              </a-select-option>
            </a-select>
          </a-col>
          <a-col :span="4">
            <a-select
              v-model:value="filterForm.status"
              placeholder="活动状态"
              allowClear
              @change="handleFilter"
            >
              <a-select-option value="">全部状态</a-select-option>
              <a-select-option value="pending">待执行</a-select-option>
              <a-select-option value="ongoing">进行中</a-select-option>
              <a-select-option value="completed">已完成</a-select-option>
              <a-select-option value="cancelled">已取消</a-select-option>
            </a-select>
          </a-col>
          <a-col :span="4">
            <a-select
              v-model:value="filterForm.type"
              placeholder="活动类型"
              allowClear
              @change="handleFilter"
            >
              <a-select-option value="">全部类型</a-select-option>
              <a-select-option value="meal">送餐服务</a-select-option>
              <a-select-option value="clean">房间保洁</a-select-option>
              <a-select-option value="massage">按摩服务</a-select-option>
              <a-select-option value="medical">医疗检查</a-select-option>
              <a-select-option value="exercise">康复训练</a-select-option>
              <a-select-option value="counseling">心理咨询</a-select-option>
              <a-select-option value="entertainment">娱乐活动</a-select-option>
            </a-select>
          </a-col>
          <a-col :span="6">
            <a-range-picker
              v-model:value="filterForm.dateRange"
              @change="handleFilter"
            />
          </a-col>
          <a-col :span="4">
            <a-button @click="resetFilter">重置</a-button>
          </a-col>
        </a-row>
      </a-card>
    </div>

    <!-- 活动记录列表 -->
    <div class="activity-list">
      <a-card title="活动记录" class="list-card">
        <div class="activity-timeline">
          <a-timeline>
            <a-timeline-item
              v-for="activity in filteredActivityList"
              :key="activity.id"
              :color="getActivityColor(activity.status)"
            >
              <div class="activity-item">
                <div class="activity-header">
                  <div class="activity-info">
                    <h4>{{ activity.title }}</h4>
                    <p>{{ activity.member }} · {{ activity.time }}</p>
                  </div>
                  <div class="activity-status">
                    <a-tag :color="getStatusColor(activity.status)">
                      {{ getStatusText(activity.status) }}
                    </a-tag>
                  </div>
                </div>
                
                <div class="activity-details">
                  <div class="detail-row">
                    <span class="label">服务类型：</span>
                    <a-tag :color="getTypeColor(activity.type)">
                      {{ getTypeText(activity.type) }}
                    </a-tag>
                  </div>
                  <div class="detail-row">
                    <span class="label">负责护工：</span>
                    <span class="value">{{ activity.caregiver }}</span>
                  </div>
                  <div class="detail-row">
                    <span class="label">预计时长：</span>
                    <span class="value">{{ activity.duration }}分钟</span>
                  </div>
                  <div class="detail-row" v-if="activity.remark">
                    <span class="label">备注：</span>
                    <span class="value">{{ activity.remark }}</span>
                  </div>
                </div>
              </div>
            </a-timeline-item>
          </a-timeline>
        </div>
      </a-card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import {
  CalendarOutlined,
  ReloadOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  TrophyOutlined,
  EyeOutlined,
  PhoneOutlined,
  MessageOutlined
} from '@ant-design/icons-vue';

const activityList = ref([]);
const familyMembers = ref([
  { id: 1, name: '张奶奶' },
  { id: 2, name: '李爷爷' }
]);

// 筛选表单
const filterForm = reactive({
  member: '',
  status: '',
  type: '',
  dateRange: undefined
});

// 活动统计
const activityStats = reactive({
  weeklyTotal: 24,
  completed: 18,
  ongoing: 3,
  participationRate: 85
});

// 计算属性
const filteredActivityList = computed(() => {
  let filtered = activityList.value;
  
  if (filterForm.member) {
    filtered = filtered.filter(item => item.member === filterForm.member);
  }
  
  if (filterForm.status) {
    filtered = filtered.filter(item => item.status === filterForm.status);
  }
  
  if (filterForm.type) {
    filtered = filtered.filter(item => item.type === filterForm.type);
  }
  
  return filtered;
});

// 工具函数
const getActivityColor = (status: string) => {
  const colors = {
    'pending': 'blue',
    'ongoing': 'orange',
    'completed': 'green',
    'cancelled': 'red'
  };
  return colors[status] || 'gray';
};

const getStatusColor = (status: string) => {
  const colors = {
    'pending': 'orange',
    'ongoing': 'blue',
    'completed': 'green',
    'cancelled': 'red'
  };
  return colors[status] || 'default';
};

const getStatusText = (status: string) => {
  const texts = {
    'pending': '待执行',
    'ongoing': '进行中',
    'completed': '已完成',
    'cancelled': '已取消'
  };
  return texts[status] || '未知';
};

const getTypeColor = (type: string) => {
  const colors = {
    'meal': 'blue',
    'clean': 'green',
    'massage': 'orange',
    'medical': 'red',
    'exercise': 'purple',
    'counseling': 'cyan',
    'entertainment': 'magenta'
  };
  return colors[type] || 'default';
};

const getTypeText = (type: string) => {
  const texts = {
    'meal': '送餐服务',
    'clean': '房间保洁',
    'massage': '按摩服务',
    'medical': '医疗检查',
    'exercise': '康复训练',
    'counseling': '心理咨询',
    'entertainment': '娱乐活动'
  };
  return texts[type] || '未知';
};

// 数据加载
const loadActivityData = async () => {
  try {
    // 模拟活动数据
    activityList.value = [
      {
        id: 1,
        title: '早餐送餐服务',
        member: '张奶奶',
        time: '2025-06-15 08:00',
        status: 'completed',
        type: 'meal',
        caregiver: '王护工',
        duration: 30,
        remark: '按时完成，老人用餐正常'
      },
      {
        id: 2,
        title: '康复训练',
        member: '李爷爷',
        time: '2025-06-15 10:00',
        status: 'ongoing',
        type: 'exercise',
        caregiver: '李护工',
        duration: 60,
        remark: '进行腿部康复训练'
      },
      {
        id: 3,
        title: '房间保洁',
        member: '张奶奶',
        time: '2025-06-15 14:00',
        status: 'pending',
        type: 'clean',
        caregiver: '赵护工',
        duration: 45,
        remark: ''
      }
    ];
  } catch (error) {
    message.error('加载活动数据失败');
  }
};

// 事件处理
const refreshData = () => {
  loadActivityData();
  message.success('数据已刷新');
};

const handleFilter = () => {
  // 筛选逻辑已在计算属性中实现
};

const resetFilter = () => {
  filterForm.member = '';
  filterForm.status = '';
  filterForm.type = '';
  filterForm.dateRange = undefined;
};

const viewDetails = (activity: any) => {
  message.info(`查看活动详情: ${activity.title}`);
};

const contactCaregiver = (activity: any) => {
  message.info(`联系护工: ${activity.caregiver}`);
};

const giveFeedback = (activity: any) => {
  message.info(`为活动"${activity.title}"提供反馈评价`);
};

onMounted(() => {
  loadActivityData();
});
</script>

<style lang="less" scoped>
.family-activity-records {
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
}

.activity-stats, .filter-section, .activity-list {
  margin-bottom: 24px;
  
  .stat-card, .filter-card, .list-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.activity-item {
  background: #fff;
  border: 1px solid #f0f0f0;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 16px;
  
  .activity-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    
    .activity-info {
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
  
  .activity-details {
    margin-bottom: 12px;
    
    .detail-row {
      display: flex;
      align-items: center;
      margin-bottom: 8px;
      
      .label {
        color: #8c8c8c;
        font-size: 12px;
        margin-right: 8px;
        min-width: 80px;
      }
      
      .value {
        color: #262626;
        font-size: 12px;
      }
    }
  }
  
  .activity-actions {
    text-align: right;
    border-top: 1px solid #f0f0f0;
    padding-top: 12px;
  }
}
</style>
