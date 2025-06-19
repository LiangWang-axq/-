<template>
  <div class="care-center-container">
    <div class="header-section">
      <h2>关爱中心</h2>
      <p class="subtitle">关注家人动态，传递温暖关怀</p>
    </div>

    <!-- 老人选择器 -->
    <a-card title="选择家人" class="selector-card" style="margin-bottom: 20px;">
      <a-select
        v-model:value="selectedElderly"
        style="width: 100%"
        placeholder="请选择要查看的家人"
        @change="handleElderlyChange"
      >
        <a-select-option 
          v-for="elderly in elderlyList" 
          :key="elderly.id" 
          :value="elderly.id"
        >
          <div class="elderly-option">
            <a-avatar size="small" style="background-color: #52c41a; margin-right: 8px;">
              {{ elderly.title.charAt(0) }}
            </a-avatar>
            {{ elderly.title }} ({{ elderly.sex }} · {{ elderly.age }}岁)
          </div>
        </a-select-option>
      </a-select>
    </a-card>

    <!-- 家人状态概览 -->
    <a-card 
      v-if="currentElderly" 
      title="家人状态" 
      class="status-card" 
      style="margin-bottom: 20px;"
    >
      <a-row :gutter="16">
        <a-col :span="8">
          <div class="status-item">
            <div class="status-avatar">
              <a-avatar size="large" style="background-color: #87d068;">
                {{ currentElderly.title.charAt(0) }}
              </a-avatar>
            </div>
            <div class="status-info">
              <h4>{{ currentElderly.title }}</h4>
              <p class="status-text">
                <a-badge status="success" />
                身体状况良好
              </p>
              <p class="last-update">最后更新：2小时前</p>
            </div>
          </div>
        </a-col>
        <a-col :span="8">
          <div class="quick-stats">
            <div class="stat-item">
              <span class="stat-number">{{ currentElderly.age }}</span>
              <span class="stat-label">年龄</span>
            </div>
          </div>
        </a-col>
      </a-row>
    </a-card>

    <!-- 关怀提醒 -->
    <a-card 
      v-if="currentElderly" 
      title="关怀提醒" 
      class="reminder-card" 
      style="margin-bottom: 20px;"
    >
      <a-list :data-source="careReminders" item-layout="horizontal">
        <template #renderItem="{ item }">
          <a-list-item>
            <a-list-item-meta>
              <template #avatar>
                <a-avatar :style="{ backgroundColor: item.color }">
                  <component :is="item.icon" />
                </a-avatar>
              </template>
              <template #title>{{ item.title }}</template>
              <template #description>
                {{ item.description.replace('{name}', currentElderly.title) }}
              </template>
            </a-list-item-meta>
          </a-list-item>
        </template>
      </a-list>
    </a-card>

    <!-- 如果没有选择老人 -->
    <div v-if="!currentElderly && elderlyList.length > 0" class="empty-state">
      <a-empty description="请从上方选择一位家人查看详细信息" />
    </div>

    <!-- 如果没有家人信息 -->
    <div v-if="elderlyList.length === 0" class="empty-state">
      <a-empty description="暂无家人信息">
        <a-button type="primary" @click="contactAdmin">
          联系管理员添加家人信息
        </a-button>
      </a-empty>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import {
  HeartOutlined,
  MedicineBoxOutlined,
  ClockCircleOutlined,
  CalendarOutlined,
  SafetyOutlined,
  SmileOutlined,
  CheckCircleOutlined
} from '@ant-design/icons-vue';
import { listApi as elderlyListApi } from '/@/api/thing';

const userStore = useUserStore();
const elderlyList = ref([]);
const selectedElderly = ref(null);
const currentElderly = ref(null);

// 加载家人列表
const loadElderlyList = async () => {
  try {
    const response = await elderlyListApi({});
    if (response.code === 0) {
      elderlyList.value = response.data;
      // 如果有家人数据，默认选择第一个
      if (elderlyList.value.length > 0) {
        selectedElderly.value = elderlyList.value[0].id;
        currentElderly.value = elderlyList.value[0];
      }
    }
  } catch (error) {
    message.error('加载家人信息失败');
  }
};

// 处理选择家人变化
const handleElderlyChange = (value) => {
  currentElderly.value = elderlyList.value.find(elderly => elderly.id === value);
};


// 关怀提醒数据
const careReminders = ref([
  {
    icon: HeartOutlined,
    color: '#f5222d',
    title: '定期关心',
    description: '请定期关心{name}的身体状况和心理状态'
  },
  {
    icon: MedicineBoxOutlined,
    color: '#1890ff',
    title: '用药提醒',
    description: '请确认{name}是否按时服用药物'
  },
  {
    icon: ClockCircleOutlined,
    color: '#fa8c16',
    title: '作息规律',
    description: '提醒{name}保持规律的作息时间'
  },
  {
    icon: CalendarOutlined,
    color: '#52c41a',
    title: '体检提醒',
    description: '建议每月带{name}进行一次体检'
  }
]);

// 计算属性：筛选当前老人的动态
const filteredActivities = computed(() => {
  if (!currentElderly.value) return [];
  return todayActivities.value.filter(activity => activity.elderlyId === currentElderly.value.id);
});

// 联系管理员
const contactAdmin = () => {
  message.info('请联系管理员添加家人信息');
};

onMounted(() => {
  loadElderlyList();
});
</script>

<style scoped lang="less">
.care-center-container {
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

.selector-card {
  .elderly-option {
    display: flex;
    align-items: center;
  }
}

.status-card {
  .status-item {
    display: flex;
    align-items: center;
    
    .status-avatar {
      margin-right: 16px;
    }
    
    .status-info {
      h4 {
        margin-bottom: 8px;
        color: #333;
      }
      
      .status-text {
        margin-bottom: 4px;
        color: #52c41a;
      }
      
      .last-update {
        margin: 0;
        color: #999;
        font-size: 12px;
      }
    }
  }
  
  .quick-stats {
    text-align: center;
    
    .stat-item {
      .stat-number {
        display: block;
        font-size: 32px;
        font-weight: bold;
        color: #1890ff;
        line-height: 1;
      }
      
      .stat-label {
        color: #666;
        font-size: 14px;
      }
    }
  }
}

.activity-card {
  .activity-content {
    .activity-time {
      color: #1890ff;
      font-weight: bold;
      margin-bottom: 4px;
    }
    
    .activity-title {
      color: #333;
      font-weight: bold;
      margin-bottom: 4px;
    }
    
    .activity-desc {
      color: #666;
      font-size: 14px;
    }
  }
}

.reminder-card {
  :deep(.ant-list-item) {
    padding: 12px 0;
    border-bottom: 1px solid #f0f0f0;
  }
  
  :deep(.ant-list-item-meta-title) {
    color: #333;
    font-weight: bold;
    margin-bottom: 4px;
  }
  
  :deep(.ant-list-item-meta-description) {
    color: #666;
    font-size: 14px;
  }
}

.empty-state {
  margin: 48px 0;
  text-align: center;
}
</style>