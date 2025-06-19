<template>
  <div class="caregiver-activity-management">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <CalendarOutlined class="title-icon" />
          活动管理
        </h1>
        <p class="page-description">管理老人的活动安排和执行情况</p>
      </div>
      <div class="header-actions">
        <a-button type="primary" size="large" @click="showAddModal">
          <PlusOutlined />
          新增活动
        </a-button>
      </div>
    </div>

    <!-- 活动统计 -->
    <div class="activity-stats">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="今日活动"
              :value="activityStats.todayTotal"
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
              title="完成率"
              :value="activityStats.completionRate"
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

    <!-- 今日活动安排 -->
    <div class="today-activities">
      <a-card title="今日活动安排" class="activities-card">
        <template #extra>
          <a-button type="link" @click="refreshData">
            <ReloadOutlined />
            刷新
          </a-button>
        </template>
        
        <div class="activity-timeline">
          <a-timeline>
            <a-timeline-item
              v-for="activity in todayActivities"
              :key="activity.id"
              :color="getActivityColor(activity.status)"
            >
              <div class="activity-item">
                <div class="activity-header">
                  <!-- 使用格式化后的时间 -->
                  <div class="activity-time">{{ activity.formattedTime }}</div>
                  <div class="activity-status">
                    <a-tag :color="getStatusColor(activity.status)">
                      {{ getStatusText(activity.status) }}
                    </a-tag>
                  </div>
                </div>
                
                <div class="activity-content">
                  <h4>{{ activity.title }}</h4>
                  <p>老人: {{ activity.name }}  </p>
                  <div class="activity-meta">

                    <span class="meta-item">
                      <TagOutlined />
                      {{ activity.priority }}
                    </span>
                  </div>
                </div>
                
                <div class="activity-actions">
                  <a-space>
                    <a-button type="primary" size="small" @click="startActivity(activity)" v-if="activity.status === 'pending'">
                      开始执行
                    </a-button>
                    <a-button type="primary" size="small" @click="completeActivity(activity)" v-if="activity.status === 'ongoing'">
                      完成活动
                    </a-button>
                    <a-button size="small" @click="viewDetails(activity)">
                      查看详情
                    </a-button>
                    <a-button size="small" @click="editActivity(activity)" v-if="activity.status === 'pending'">
                      编辑
                    </a-button>
                  </a-space>
                </div>
              </div>
            </a-timeline-item>
          </a-timeline>
        </div>
      </a-card>
    </div>

    <!-- 活动列表 -->
    <div class="activity-list">
      <a-card title="活动列表" class="list-card">
        <template #extra>
          <a-space>
            <a-select
              v-model:value="filterStatus"
              placeholder="筛选状态"
              style="width: 120px"
              allowClear
              @change="handleFilter"
            >
              <a-select-option value="">全部状态</a-select-option>
              <a-select-option value="pending">待执行</a-select-option>
              <a-select-option value="ongoing">进行中</a-select-option>
              <a-select-option value="completed">已完成</a-select-option>
              <a-select-option value="cancelled">已取消</a-select-option>
            </a-select>
            <a-input-search
              v-model:value="searchKeyword"
              placeholder="搜索老人姓名"
              style="width: 200px"
              @search="handleSearch"
            />
          </a-space>
        </template>
        
        <a-table
          :columns="columns"
          :data-source="filteredActivityList"
          :loading="loading"
          :pagination="pagination"
          size="middle"
        >
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'status'">
              <a-tag :color="getStatusColor(record.status)">
                {{ getStatusText(record.status) }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'priority'">
              <a-tag :color="getPriorityColor(record.priority)">
                {{ record.priority }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'action'">
              <a-space>
                <a-button type="link" size="small" @click="viewDetails(record)">
                  查看
                </a-button>
                <a-button type="link" size="small" @click="editActivity(record)" v-if="record.status === 'pending'">
                  编辑
                </a-button>
                <a-popconfirm
                  title="确定要删除这个活动吗？"
                  @confirm="deleteActivity(record)"
                  ok-text="确定"
                  cancel-text="取消"
                >
                  <a-button type="link" size="small" danger v-if="record.status === 'pending'">
                    删除
                  </a-button>
                </a-popconfirm>
              </a-space>
            </template>
          </template>
        </a-table>
      </a-card>
    </div>

    <!-- 新增/编辑活动模态框 -->
    <a-modal
      v-model:visible="modalVisible"
      :title="modalTitle"
      width="600px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
    >
      <template #footer>
        <a-button @click="modalVisible = false">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleSubmit">
          {{ isEdit ? '更新' : '创建' }}
        </a-button>
      </template>
      
      <a-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        layout="vertical"
      >
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="老人姓名" name="elderlyName">
              <a-select
                v-model:value="formData.elderlyName"
                placeholder="请选择老人"
                show-search
              >
                <a-select-option v-for="elderly in elderlyList" :key="elderly.id" :value="elderly.title">
                  {{ elderly.title }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="活动类型" name="title">
              <a-select v-model:value="formData.title" placeholder="请选择活动类型">
                <a-select-option value="送餐服务">送餐服务</a-select-option>
                <a-select-option value="房间保洁">房间保洁</a-select-option>
                <a-select-option value="按摩服务">按摩服务</a-select-option>
                <a-select-option value="医疗检查">医疗检查</a-select-option>
                <a-select-option value="康复训练">康复训练</a-select-option>
                <a-select-option value="心理咨询">心理咨询</a-select-option>
                <a-select-option value="娱乐活动">娱乐活动</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="活动时间" name="activity_time">
              <a-date-picker
                v-model:value="formData.activity_time"
                show-time
                format="YYYY-MM-DD HH:mm"
                placeholder="选择活动时间"
                style="width: 100%"
                :show-now="false"
                :show-today="true"
                ok-text="确定"
                :time-picker-props="{
                  format: 'HH:mm',
                  showNow: false
                }"
              />
            </a-form-item>
          </a-col>
         
          <a-col :span="12">
            <a-form-item label="优先级" name="priority">
              <a-select v-model:value="formData.priority" placeholder="请选择优先级">
                <a-select-option value="低">低</a-select-option>
                <a-select-option value="普通">普通</a-select-option>
                <a-select-option value="高">高</a-select-option>
                <a-select-option value="紧急">紧急</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>

          <a-col :span="24">
            <a-form-item label="备注" name="remark">
              <a-textarea v-model:value="formData.remark" placeholder="活动备注" :rows="3" />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import {
  CalendarOutlined,
  PlusOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  TrophyOutlined,
  ReloadOutlined,
  TagOutlined
} from '@ant-design/icons-vue';
import { listApi as activityListApi, createApi, updateApi, deleteApi } from '/@/api/tag';
import { listApi as elderlyListApi } from '/@/api/thing';

const userStore = useUserStore();
const modalVisible = ref(false);
const isEdit = ref(false);
const submitting = ref(false);
const loading = ref(false);
const searchKeyword = ref('');
const filterStatus = ref('');
const activityList = ref([]);
const elderlyList = ref([]);
const formRef = ref();

// 护工姓名
const caregiverName = computed(() => userStore.admin_user_nickname || userStore.admin_user_name || '护工');

// 表单数据
const formData = reactive({
  id: undefined,
  elderlyName: '',
  title: '',
  activity_time: undefined,
  duration: 60,
  priority: '普通',
  room: '',
  remark: ''
});

// 活动统计
const activityStats = reactive({
  todayTotal: 8,
  completed: 5,
  ongoing: 2,
  completionRate: 85
});

// 今日活动
const todayActivities = ref([
  {
    id: 1,
    title: '送餐服务',
    elderlyName: '张奶奶',
    room: 'A101',
    time: '08:00',
    duration: 30,
    priority: '普通',
    status: 'completed'
  },
  {
    id: 2,
    title: '康复训练',
    elderlyName: '李爷爷',
    room: 'B205',
    time: '10:00',
    duration: 60,
    priority: '高',
    status: 'ongoing'
  },
  {
    id: 3,
    title: '按摩服务',
    elderlyName: '王奶奶',
    room: 'C302',
    time: '14:00',
    duration: 45,
    priority: '普通',
    status: 'pending'
  }
]);

// 表单验证规则
const formRules = {
  elderlyName: [{ required: true, message: '请选择老人', trigger: 'change' }],
  title: [{ required: true, message: '请选择活动类型', trigger: 'change' }],
  activity_time: [{ required: true, message: '请选择活动时间', trigger: 'change' }],
  duration: [{ required: true, message: '请输入预计时长', trigger: 'blur' }],
  priority: [{ required: true, message: '请选择优先级', trigger: 'change' }]
};

// 表格列定义
const columns = [
  { title: '老人姓名', dataIndex: 'name', key: 'name', width: 100 },
  { title: '活动类型', dataIndex: 'title', key: 'title', width: 120 },
  { title: '活动时间', dataIndex: 'activity_time', key: 'activity_time', width: 160 },
  
  { title: '优先级', key: 'priority', width: 80, align: 'center' },
  { title: '状态', key: 'status', width: 100, align: 'center' },


];

// 分页配置
const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showSizeChanger: true,
  showQuickJumper: true,
  showTotal: (total: number) => `共 ${total} 条记录`
});

// 计算属性
const modalTitle = computed(() => isEdit.value ? '编辑活动' : '新增活动');
const filteredActivityList = computed(() => {
  let filtered = activityList.value;
  
  if (filterStatus.value) {
    filtered = filtered.filter(item => item.status === filterStatus.value);
  }
  
  if (searchKeyword.value) {
    filtered = filtered.filter(item => 
      item.elderlyName && item.elderlyName.includes(searchKeyword.value)
    );
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

const getPriorityColor = (priority: string) => {
  const colors = {
    '低': 'green',
    '普通': 'blue',
    '高': 'orange',
    '紧急': 'red'
  };
  return colors[priority] || 'default';
};

// 数据加载
// 在 loadActivityList 方法中更新统计逻辑
const loadActivityList = async () => {
  loading.value = true;
  try {
    const response = await activityListApi({});
    if (response.code === 0) {
      // 筛选当前护工负责的活动并格式化时间
      activityList.value = response.data
        .filter(activity => activity.worker === caregiverName.value)
        .map(activity => ({
          ...activity,
          formattedTime: formatTime(activity.activity_time)
        }));
      
      // 计算统计数据
      calculateActivityStats(response.data);
    } else {
      activityList.value = [];
      resetActivityStats();
    }
  } catch (error) {
    message.error('加载活动列表失败');
    activityList.value = [];
    resetActivityStats();
  } finally {
    loading.value = false;
  }
};

// 新增计算统计数据的函数
const calculateActivityStats = (activities) => {
  const today = new Date();
  const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
  
  // 筛选今天的活动
  const todayActivities = activities.filter(activity => {
    if (!activity.activity_time) return false;
    
    try {
      const activityDate = new Date(activity.activity_time);
      if (isNaN(activityDate.getTime())) return false;
      
      const activityDateStr = `${activityDate.getFullYear()}-${String(activityDate.getMonth() + 1).padStart(2, '0')}-${String(activityDate.getDate()).padStart(2, '0')}`;
      return activityDateStr === todayStr;
    } catch (e) {
      return false;
    }
  });
  
  // 计算各种状态的数量
  const completed = todayActivities.filter(a => a.status === 'completed').length;
  const ongoing = todayActivities.filter(a => a.status === 'ongoing').length;
  const pending = todayActivities.filter(a => a.status === 'pending').length;
  const total = todayActivities.length;
  
  // 更新统计数据
  activityStats.todayTotal = total;
  activityStats.completed = completed;
  activityStats.ongoing = ongoing;
  activityStats.completionRate = total > 0 ? Math.round((completed / total) * 100) : 0;
};

// 重置统计数据
const resetActivityStats = () => {
  activityStats.todayTotal = 0;
  activityStats.completed = 0;
  activityStats.ongoing = 0;
  activityStats.completionRate = 0;
};

const loadElderlyList = async () => {
  try {
    const response = await elderlyListApi({});
    if (response.code === 0) {
      elderlyList.value = response.data;
    }
  } catch (error) {
    console.error('加载老人列表失败');
  }
};

// 事件处理
const refreshData = () => {
  loadActivityList();
  loadTodayActivities(); // 新增
  message.success('数据已刷新');
};

const handleFilter = () => {
  // 筛选逻辑已在计算属性中实现
};

const handleSearch = () => {
  // 搜索逻辑已在计算属性中实现
};

const showAddModal = () => {
  isEdit.value = false;
  modalVisible.value = true;
  resetForm();
};

const editActivity = (record: any) => {
  isEdit.value = true;
  modalVisible.value = true;
  Object.assign(formData, record);
};

const viewDetails = (record: any) => {
  message.info(`查看活动详情: ${record.title}`);
};

const startActivity = async (activity: any) => {
  try {
    await updateApi({ id: activity.id }, {
      ...activity,
      status: 'ongoing'
    });

    activity.status = 'ongoing';
    message.success(`开始执行活动: ${activity.title}`);

    // 重新加载活动列表以确保数据同步
    loadActivityList();
  } catch (error) {
    message.error('更新活动状态失败');
    console.error('更新活动状态失败:', error);
  }
};

const completeActivity = async (activity: any) => {
  try {
    await updateApi({ id: activity.id }, {
      ...activity,
      status: 'completed'
    });

    activity.status = 'completed';
    message.success(`完成活动: ${activity.title}`);

    // 重新加载活动列表以确保数据同步
    loadActivityList();
  } catch (error) {
    message.error('更新活动状态失败');
    console.error('更新活动状态失败:', error);
  }
};

const deleteActivity = async (record: any) => {
  try {
    await deleteApi({ ids: record.id });
    message.success('删除成功');
    loadActivityList();
  } catch (error) {
    message.error('删除失败');
  }
};

const handleSubmit = async () => {
  try {
    await formRef.value.validate();
    submitting.value = true;
    
    const submitData = {
      ...formData,
      worker: caregiverName.value,
      name: formData.elderlyName,
      activity_time: formData.activity_time.format('YYYY-MM-DD HH:mm:ss')
    };
    
    if (isEdit.value) {
      await updateApi({ id: formData.id }, submitData);
      message.success('更新成功');
    } else {
      await createApi(submitData);
      message.success('创建成功');
    }
    
    modalVisible.value = false;
    loadActivityList();
  } catch (error) {
    message.error(isEdit.value ? '更新失败' : '创建失败');
  } finally {
    submitting.value = false;
  }
};

const resetForm = () => {
  Object.assign(formData, {
    id: undefined,
    elderlyName: '',
    title: '',
    activity_time: undefined,
    duration: 60,
    priority: '普通',
    room: '',
    remark: ''
  });
  formRef.value?.resetFields();
};

const loadTodayActivities = async () => {
  try {
    // 获取今天的日期（格式化为 YYYY-MM-DD）
    const today = new Date();
    const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;
    
    const response = await activityListApi({});
    if (response.code === 0) {
      // 筛选出今天的活动并格式化时间
      todayActivities.value = response.data
        .filter(activity => {
          if (!activity.activity_time) return false;
          
          try {
            const activityDate = new Date(activity.activity_time);
            if (isNaN(activityDate.getTime())) return false;
            
            const activityDateStr = `${activityDate.getFullYear()}-${String(activityDate.getMonth() + 1).padStart(2, '0')}-${String(activityDate.getDate()).padStart(2, '0')}`;
            return activityDateStr === todayStr;
          } catch (e) {
            return false;
          }
        })
        .map(activity => ({
          ...activity,
          formattedTime: formatTime(activity.activity_time)
        }));
    } else {
      todayActivities.value = [];
    }
  } catch (error) {
    message.error('加载今日活动失败');
    todayActivities.value = [];
  }
};

// 在 setup 中定义 formatTime 函数
const formatTime = (dateString) => {
  if (!dateString) return '未设置';
  
  try {
    const date = new Date(dateString);
    if (isNaN(date.getTime())) return '无效时间';
    
    return `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
  } catch (e) {
    return '格式错误';
  }
};

onMounted(() => {
  loadActivityList();
  loadElderlyList();
  loadTodayActivities(); // 新增
});
</script>

<style lang="less" scoped>
.caregiver-activity-management {
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

.activity-stats, .today-activities, .activity-list {
  margin-bottom: 24px;
  
  .stat-card, .activities-card, .list-card {
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
    
    .activity-time {
      font-size: 16px;
      font-weight: 600;
      color: #1890ff;
    }
  }
  
  .activity-content {
    margin-bottom: 12px;
    
    h4 {
      margin: 0 0 8px 0;
      font-size: 16px;
      color: #262626;
    }
    
    p {
      margin: 0 0 8px 0;
      color: #8c8c8c;
      font-size: 14px;
    }
    
    .activity-meta {
      .meta-item {
        display: inline-flex;
        align-items: center;
        margin-right: 16px;
        color: #8c8c8c;
        font-size: 12px;
        
        .anticon {
          margin-right: 4px;
        }
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
