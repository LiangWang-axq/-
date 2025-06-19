<template>
  <div class="caregiver-elderly-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <UserOutlined class="title-icon" />
          我的老人管理
        </h1>
        <p class="page-description">管理您负责照顾的老人信息</p>
      </div>
      <div class="header-actions">
        <a-button type="primary" size="large" @click="showQuickHealthEntry">
          <PlusOutlined />
          快速录入健康数据
        </a-button>
      </div>
    </div>

    <!-- 护工信息卡片 -->
    <div class="caregiver-info">
      <a-card class="info-card">
        <div class="caregiver-profile">
          <div class="profile-avatar">
            <a-avatar :size="64" style="background-color: #1890ff">
              {{ caregiverName.charAt(0) }}
            </a-avatar>
          </div>
          <div class="profile-info">
            <h3>{{ caregiverName }}</h3>
            <p>护工编号: {{ caregiverInfo.id || 'CG001' }}</p>
            <p>负责老人: {{ elderlyList.length }} 位</p>
          </div>
          <div class="profile-stats">
            <div class="stat-item">
              <div class="stat-number">{{ todayTasks }}</div>
              <div class="stat-label">今日任务</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">{{ completedTasks }}</div>
              <div class="stat-label">已完成</div>
            </div>
          </div>
        </div>
      </a-card>
    </div>

    <!-- 快速录入健康数据 -->
    <div class="quick-health-entry">
      <a-card title="快速录入健康数据" class="entry-card">
        <a-form
          ref="quickFormRef"
          :model="quickForm"
          layout="inline"
          @finish="submitQuickHealth"
        >
          <a-form-item label="选择老人" name="elderly">
            <a-select v-model:value="quickForm.elderly" placeholder="选择老人" style="width: 150px">
              <a-select-option v-for="elderly in elderlyList" :key="elderly.id" :value="elderly.title">
                {{ elderly.title }}
              </a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="体温" name="temperature">
            <a-input v-model:value="quickForm.temperature" placeholder="36.5" style="width: 100px" />
          </a-form-item>
          <a-form-item label="血压" name="pressure">
            <a-input v-model:value="quickForm.pressure" placeholder="120/80" style="width: 120px" />
          </a-form-item>
          <a-form-item label="体重" name="weight">
            <a-input v-model:value="quickForm.weight" placeholder="65" style="width: 100px" />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" :loading="quickSubmitting" @click="submitQuickHealth">
              录入数据
            </a-button>
          </a-form-item>
        </a-form>
      </a-card>
    </div>

    <!-- 老人列表 -->
    <div class="elderly-list">
      <a-card title="负责的老人" class="list-card">
        <template #extra>
          <a-space>
            <a-input-search
              v-model:value="searchKeyword"
              placeholder="搜索老人姓名"
              style="width: 200px"
              @search="handleSearch"
            />
            <a-button @click="refreshList">
              <ReloadOutlined />
              刷新
            </a-button>
          </a-space>
        </template>
        
        <a-row :gutter="16">
          <a-col :span="8" v-for="elderly in filteredElderlyList" :key="elderly.id">
            <a-card class="elderly-card" hoverable>
              <div class="elderly-info">
                <div class="elderly-avatar">
                  <a-avatar :size="48" style="background-color: #52c41a">
                    {{ elderly.title.charAt(0) }}
                  </a-avatar>
                </div>
                <div class="elderly-details">
                  <h4>{{ elderly.title }}</h4>
                  <p>性别: {{ elderly.sex || '未知' }}</p>
                  <p>年龄: {{ elderly.age || '未知' }}岁</p>
                  <p>房间: {{ elderly.address || '未分配' }}</p>
                </div>
              </div>
              <div class="elderly-actions">
                <a-space>
                  <a-button type="link" size="small" @click="viewElderlyHealth(elderly)">
                    <HeartOutlined />
                    健康记录
                  </a-button>
                  <a-button type="link" size="small" @click="viewElderlyActivities(elderly)">
                    <CalendarOutlined />
                    活动安排
                  </a-button>
                  <a-button type="link" size="small" @click="recordHealth(elderly)">
                    <PlusOutlined />
                    录入数据
                  </a-button>
                </a-space>
              </div>
            </a-card>
          </a-col>
        </a-row>
      </a-card>
    </div>

    <!-- 今日任务 -->
    <div class="today-tasks">
      <a-card title="今日任务" class="tasks-card">
        <a-list
          :data-source="todayTaskList"
          :loading="tasksLoading"
        >
          <template #renderItem="{ item }">
            <a-list-item>
              <template #actions>
                <a-button 
                  type="link" 
                  size="small" 
                  @click="completeTask(item)"
                  :disabled="item.completed"
                >
                  {{ item.completed ? '已完成' : '完成' }}
                </a-button>
              </template>
              <a-list-item-meta>
                <template #title>
                  <span :class="{ 'completed-task': item.completed }">
                    {{ item.title }}
                  </span>
                </template>
                <template #description>
                  <div>
                    <span>老人: {{ item.elderlyName }}</span>
                    <span style="margin-left: 16px">时间: {{ item.time }}</span>
                    <a-tag :color="item.priority === 'high' ? 'red' : 'blue'" style="margin-left: 8px">
                      {{ item.priority === 'high' ? '紧急' : '普通' }}
                    </a-tag>
                  </div>
                </template>
              </a-list-item-meta>
            </a-list-item>
          </template>
        </a-list>
      </a-card>
    </div>

    <!-- 健康数据录入模态框 -->
    <a-modal
      v-model:visible="healthModalVisible"
      :title="`为 ${selectedElderly?.title} 录入健康数据`"
      width="600px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
    >
      <template #footer>
        <a-button @click="healthModalVisible = false">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="submitHealthData">
          保存数据
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
  UserOutlined,
  PlusOutlined,
  HeartOutlined,
  CalendarOutlined,
  ReloadOutlined
} from '@ant-design/icons-vue';
import { listApi as elderlyListApi } from '/@/api/thing';
import { createApi as healthCreateApi, listApi as healthListApi } from '/@/api/health';
import { listApi as activityListApi, updateApi } from '/@/api/tag';

const userStore = useUserStore();
const searchKeyword = ref('');
const healthModalVisible = ref(false);
const submitting = ref(false);
const quickSubmitting = ref(false);
const tasksLoading = ref(false);
const elderlyList = ref([]);
const selectedElderly = ref(null);
const quickFormRef = ref();
const healthFormRef = ref();

// 护工信息
const caregiverName = computed(() => userStore.admin_user_nickname || userStore.admin_user_name || '护工');
const caregiverInfo = reactive({
  id: 'CG001',
  department: '护理部',
  experience: '3年'
});

// 快速录入表单
const quickForm = reactive({
  elderly: '',
  temperature: '',
  pressure: '',
  weight: ''
});

// 健康数据表单
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
  ]
};

// 今日任务列表
const todayTaskList = ref([
  {
    id: 1,
    title: '测量体温',
    elderlyName: '张奶奶',
    time: '09:00',
    priority: 'normal',
    completed: false
  },
  {
    id: 2,
    title: '协助用餐',
    elderlyName: '李爷爷',
    time: '12:00',
    priority: 'high',
    completed: true
  },
  {
    id: 3,
    title: '康复训练',
    elderlyName: '王奶奶',
    time: '15:00',
    priority: 'normal',
    completed: false
  }
]);

// 计算属性
const filteredElderlyList = computed(() => {
  if (!searchKeyword.value) return elderlyList.value;
  return elderlyList.value.filter(elderly => 
    elderly.title.includes(searchKeyword.value)
  );
});

const todayTasks = computed(() => todayTaskList.value.length);
const completedTasks = computed(() => todayTaskList.value.filter(task => task.completed).length);

// 数据加载
const loadElderlyList = async () => {
  try {
    const response = await elderlyListApi({});
    if (response.code === 0) {
      elderlyList.value = response.data;
    }
  } catch (error) {
    message.error('加载老人列表失败');
  }
};

const loadTodayTasks = async () => {
  tasksLoading.value = true;
  try {
    const response = await activityListApi({});
    if (response.code === 0) {
      const currentWorker = userStore.admin_user_nickname || userStore.admin_user_name;
      const today = new Date().toDateString();

      // 过滤当前护工的今日任务
      todayTaskList.value = response.data
        .filter(task => {
          const taskDate = new Date(task.activity_time || task.create_time).toDateString();
          return task.worker === currentWorker && taskDate === today;
        })
        .map(task => ({
          ...task,
          completed: task.status === 'completed',
          elderlyName: task.name,
          time: task.activity_time ? new Date(task.activity_time).toLocaleTimeString() : '未设置',
          priority: task.priority || 'normal'
        }));
    }
  } catch (error) {
    message.error('加载今日任务失败');
    console.error('加载今日任务失败:', error);
  } finally {
    tasksLoading.value = false;
  }
};

// 事件处理
const showQuickHealthEntry = () => {
  message.info('快速录入功能已在页面中显示');
};

const handleSearch = () => {
  // 搜索功能已通过计算属性实现
};

const refreshList = () => {
  loadElderlyList();
  message.success('列表已刷新');
};

const viewElderlyHealth = async (elderly: any) => {
  try {
    console.log('查看老人健康记录:', elderly.title);

    // 使用正确的API路径和参数
    const response = await healthListApi({
      keyword: elderly.title
    });

    console.log('健康记录API响应:', response);

    if (response.code === 0) {
      const healthRecords = response.data.filter(record => record.title === elderly.title);
      console.log('过滤后的健康记录:', healthRecords);

      if (healthRecords.length > 0) {
        const recordsText = healthRecords.map(record =>
          `${record.create_time?.substring(0, 16) || '今日'}: 体温${record.temperature}°C, 血压${record.pressure}, 体重${record.weight}kg`
        ).join('\n');
        message.success(`${elderly.title} 健康记录：\n${recordsText}`);
      } else {
        message.info(`${elderly.title} 暂无健康记录`);
      }
    } else {
      message.error(`获取健康记录失败: ${response.msg}`);
    }
  } catch (error) {
    console.error('获取健康记录失败:', error);
    message.error('获取健康记录失败');
  }
};

const viewElderlyActivities = async (elderly: any) => {
  try {
    console.log('查看老人活动安排:', elderly.title);

    // 使用正确的API
    const response = await activityListApi({
      keyword: elderly.title
    });

    console.log('活动记录API响应:', response);

    if (response.code === 0) {
      const activities = response.data.filter(activity => activity.name === elderly.title);
      console.log('过滤后的活动记录:', activities);

      if (activities.length > 0) {
        const activitiesText = activities.map(activity =>
          `${activity.title} - 护工: ${activity.worker} - 状态: ${getActivityStatusText(activity.status)}`
        ).join('\n');
        message.success(`${elderly.title} 活动安排：\n${activitiesText}`);
      } else {
        message.info(`${elderly.title} 暂无活动安排`);
      }
    } else {
      message.error(`获取活动安排失败: ${response.msg}`);
    }
  } catch (error) {
    console.error('获取活动安排失败:', error);
    message.error('获取活动安排失败');
  }
};

// 添加活动状态文本转换函数
const getActivityStatusText = (status: string) => {
  const statusMap = {
    'pending': '待执行',
    'ongoing': '进行中',
    'completed': '已完成',
    'cancelled': '已取消'
  };
  return statusMap[status] || '未知';
};

const recordHealth = (elderly: any) => {
  selectedElderly.value = elderly;
  healthModalVisible.value = true;
  Object.assign(healthForm, {
    temperature: '',
    pressure: '',
    weight: '',
    height: '',
    remark: ''
  });
};

const submitQuickHealth = async () => {
  if (!quickForm.elderly || !quickForm.temperature) {
    message.warning('请至少填写老人和体温信息');
    return;
  }
  
  quickSubmitting.value = true;
  try {
    const submitData = {
      title: quickForm.elderly,
      temperature: quickForm.temperature,
      pressure: quickForm.pressure || '正常',
      weight: quickForm.weight || '正常',
      height: '正常',
      sex: '未知',
      age: '未知',
      remark: `护工${caregiverName.value}快速录入`
    };
    
    await healthCreateApi(submitData);
    message.success('健康数据录入成功');
    Object.assign(quickForm, { elderly: '', temperature: '', pressure: '', weight: '' });
  } catch (error) {
    message.error('录入失败');
  } finally {
    quickSubmitting.value = false;
  }
};

const submitHealthData = async () => {
  try {
    await healthFormRef.value.validate();
    submitting.value = true;
    
    const submitData = {
      title: selectedElderly.value.title,
      temperature: healthForm.temperature,
      pressure: healthForm.pressure,
      weight: healthForm.weight,
      height: healthForm.height,
      sex: selectedElderly.value.sex || '未知',
      age: selectedElderly.value.age || '未知',
      remark: healthForm.remark
    };
    
    await healthCreateApi(submitData);
    message.success('健康数据保存成功');
    healthModalVisible.value = false;
  } catch (error) {
    message.error('保存失败');
  } finally {
    submitting.value = false;
  }
};

const completeTask = async (task: any) => {
  try {
    // 调用后端API更新任务状态
    await updateApi({ id: task.id }, {
      ...task,
      status: 'completed'
    });

    // 更新本地状态
    task.completed = true;
    task.status = 'completed';

    message.success(`任务"${task.title}"已完成`);

    // 重新加载任务列表以确保数据同步
    loadTodayTasks();
  } catch (error) {
    message.error('更新任务状态失败');
    console.error('更新任务状态失败:', error);
  }
};

onMounted(() => {
  loadElderlyList();
  loadTodayTasks();
});
</script>

<style lang="less" scoped>
.caregiver-elderly-management {
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

.caregiver-info {
  margin-bottom: 24px;
  
  .info-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
    
    .caregiver-profile {
      display: flex;
      align-items: center;
      
      .profile-avatar {
        margin-right: 24px;
      }
      
      .profile-info {
        flex: 1;
        
        h3 {
          margin: 0 0 8px 0;
          font-size: 20px;
          color: #262626;
        }
        
        p {
          margin: 4px 0;
          color: #8c8c8c;
          font-size: 14px;
        }
      }
      
      .profile-stats {
        display: flex;
        gap: 32px;
        
        .stat-item {
          text-align: center;
          
          .stat-number {
            font-size: 24px;
            font-weight: 600;
            color: #1890ff;
          }
          
          .stat-label {
            font-size: 12px;
            color: #8c8c8c;
            margin-top: 4px;
          }
        }
      }
    }
  }
}

.quick-health-entry, .elderly-list, .today-tasks {
  margin-bottom: 24px;
  
  .entry-card, .list-card, .tasks-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.elderly-card {
  margin-bottom: 16px;
  border-radius: 8px;
  
  .elderly-info {
    display: flex;
    align-items: center;
    margin-bottom: 16px;
    
    .elderly-avatar {
      margin-right: 16px;
    }
    
    .elderly-details {
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
  
  .elderly-actions {
    border-top: 1px solid #f0f0f0;
    padding-top: 12px;
  }
}

.completed-task {
  text-decoration: line-through;
  color: #8c8c8c;
}
</style>
