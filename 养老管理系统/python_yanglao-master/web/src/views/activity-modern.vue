<template>
  <div class="activity-management-container">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <CalendarOutlined class="title-icon" />
          活动管理
        </h1>
        <p class="page-description">管理老人活动预约，安排护工服务</p>
      </div>
      <div class="header-actions">

      </div>
    </div>

    <!-- 活动统计卡片 -->
    <div class="stats-section">
      <a-row :gutter="16">
        <a-col :span="8">
          <a-card class="stat-card today-card">
            <div class="card-content">
              <div class="card-icon">
                <CalendarOutlined />
              </div>
              <div class="card-info">
                <div class="card-title-line">
                  <span class="card-title">今日活动：</span>
                  <span class="card-value">{{ activityStats.todayCount }}</span>
                </div>
                <div class="card-desc">已完成：{{ activityStats.todayCompleted }}</div>
              </div>
            </div>
          </a-card>
        </a-col>

        <a-col :span="8">
          <a-card class="stat-card popular-card">
            <div class="card-content">
              <div class="card-icon">
                <StarOutlined />
              </div>
              <div class="card-info">
                <div class="card-title-line">
                  <span class="card-title">热门服务：</span>
                  <span class="card-value">{{ activityStats.popularService }}</span>
                </div>
                <div class="card-desc">预约：{{ activityStats.popularCount }} 次</div>
              </div>
            </div>
          </a-card>
        </a-col>
        <a-col :span="8">
          <a-card class="stat-card total-card">
            <div class="card-content">
              <div class="card-icon">
                <DatabaseOutlined />
              </div>
              <div class="card-info">
                <div class="card-title-line">
                  <div class="card-title">总预约数</div>
                  <div class="card-value">{{ activityStats.totalCount }}</div>
                </div>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    

    <!-- 活动列表 -->
    <div class="table-section">
      <a-card class="table-card">
        <a-table
          rowKey="id"
          :columns="columns"
          :data-source="activityList"
          :loading="loading"
          :row-selection="rowSelection"
          :pagination="pagination"
          :scroll="{ x: 1600 }"
          size="middle"
          class="modern-table"
        >
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'serviceType'">
              <a-tag :color="getServiceTypeColor(record.title)">
                {{ record.title }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'status'">
              <a-tag :color="getStatusColor(record.status)">
                {{ getStatusText(record.status) }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'priority'">
              <a-tag :color="getPriorityColor(record.priority)">
                {{ getPriorityText(record.priority) }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'activity_time'">
              <div class="time-info">
                <div class="date">{{ formatDate(record.activity_time) }}</div>
                <div class="time">{{ formatTime(record.activity_time) }}</div>
              </div>
            </template>
            
            <template v-if="column.key === 'action'">
              <a-space>
                <a-popconfirm
                  title="确定要删除这个活动预约吗？"
                  @confirm="handleDelete(record)"
                  ok-text="确定"
                  cancel-text="取消"
                >
                  <a-button type="link" size="small" danger>
                    <DeleteOutlined />
                    删除
                  </a-button>
                </a-popconfirm>
              </a-space>
            </template>
          </template>
        </a-table>
      </a-card>
    </div>

    <!-- 新增/编辑活动预约模态框 -->
    <a-modal
      v-model:visible="modalVisible"
      :title="modalTitle"
      width="800px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
      class="activity-modal"
    >
      <template #footer>
        <a-button @click="handleCancel">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleSubmit">
          {{ isEdit ? '更新' : '创建' }}
        </a-button>
      </template>
      
      <a-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        layout="vertical"
        class="activity-form"
      >
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="老人姓名" name="name">
              <a-select
                v-model:value="formData.name"
                placeholder="请选择老人"
                size="large"
                show-search
                :filter-option="filterOption"
              >
                <a-select-option v-for="elderly in elderlyList" :key="elderly.id" :value="elderly.title">
                  {{ elderly.title }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="服务类型" name="title">
              <a-select
                v-model:value="formData.title"
                placeholder="请选择服务类型"
                size="large"
              >
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
            <a-form-item label="预约时间" name="activity_time">
              <a-date-picker
                v-model:value="formData.activity_time"
                show-time
                format="YYYY-MM-DD HH:mm"
                placeholder="请选择预约时间"
                size="large"
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
            <a-form-item label="负责护工" name="worker">
              <a-select
                v-model:value="formData.worker"
                placeholder="请选择护工"
                size="large"
                show-search
                :filter-option="filterOption"
              >
                <a-select-option v-for="worker in workerList" :key="worker.id" :value="worker.title">
                  {{ worker.title }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="优先级" name="priority">
              <a-select
                v-model:value="formData.priority"
                placeholder="请选择优先级"
                size="large"
              >
                <a-select-option value="low">低</a-select-option>
                <a-select-option value="normal">普通</a-select-option>
                <a-select-option value="high">高</a-select-option>
                <a-select-option value="urgent">紧急</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          
          <a-col :span="8">
            <a-form-item label="状态" name="status">
              <a-select
                v-model:value="formData.status"
                placeholder="请选择状态"
                size="large"
              >
                <a-select-option value="pending">待执行</a-select-option>
                <a-select-option value="ongoing">进行中</a-select-option>
                <a-select-option value="completed">已完成</a-select-option>
                <a-select-option value="cancelled">已取消</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="特殊要求" name="remark">
              <a-textarea
                v-model:value="formData.remark"
                placeholder="请输入特殊要求或备注信息"
                :rows="3"
                size="large"
              />
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
import {
  CalendarOutlined,
  PlusOutlined,
  EditOutlined,
  DeleteOutlined,
  EyeOutlined,
  ScheduleOutlined,
  StarOutlined,
  DatabaseOutlined,
  DownloadOutlined,
  PlayCircleOutlined,
  CheckCircleOutlined
} from '@ant-design/icons-vue';
import { createApi, listApi, updateApi, deleteApi } from '/@/api/tag';
import { listApi as elderlyListApi } from '/@/api/thing';
import { listApi as workerListApi } from '/@/api/worker';

// 响应式数据
const loading = ref(false);
const modalVisible = ref(false);
const submitting = ref(false);
const isEdit = ref(false);
const selectedRowKeys = ref<string[]>([]);
const activityList = ref([]);
const elderlyList = ref([]);
const workerList = ref([]);
const formRef = ref();

// 搜索表单
const searchForm = reactive({
  keyword: '',
  serviceType: undefined,
  status: undefined,
  date: undefined
});

// 表单数据
const formData = reactive({
  id: undefined,
  name: '',
  title: '',
  activity_time: undefined,
  worker: '',
  priority: 'normal',
  duration: 60,
  status: 'pending',
  remark: ''
});

// 活动统计数据
const activityStats = reactive({
  todayCount: 0,
  todayCompleted: 0,
  weekCount: 0,
  weekCompletionRate: 0,
  popularService: '送餐服务',
  popularCount: 15,
  totalCount: 0,
  monthlyNew: 0
});

// 表单验证规则
const formRules = {
  name: [
    { required: true, message: '请选择老人', trigger: 'change' }
  ],
  title: [
    { required: true, message: '请选择服务类型', trigger: 'change' }
  ],
  activity_time: [
    { required: true, message: '请选择预约时间', trigger: 'change' }
  ],
  worker: [
    { required: true, message: '请选择负责护工', trigger: 'change' }
  ],
  priority: [
    { required: true, message: '请选择优先级', trigger: 'change' }
  ]
};

// 表格列定义
const columns = [
  {
    title: '老人姓名',
    dataIndex: 'name',
    key: 'name',
    width: 100,
    align: 'center'
  },
  {
    title: '服务类型',
    key: 'serviceType',
    width: 120,
    align: 'center'
  },
  {
    title: '预约时间',
    key: 'activity_time',
    width: 100,
    align: 'center'
  },
  {
    title: '负责护工',
    dataIndex: 'worker',
    key: 'worker',
    width: 100,
    align: 'center'
  },
  {
    title: '优先级',
    key: 'priority',
    width: 80,
    align: 'center'
  },
  {
    title: '状态',
    key: 'status',
    width: 100,
    align: 'center'
  },
  {
    title: '创建时间',
    dataIndex: 'create_time',
    key: 'create_time',
    width: 100,
    align: 'center'
  },
  {
    title: '操作',
    key: 'action',
    width: 100,
    fixed: 'right',
    align: 'center'
  }
];

// 分页配置
const pagination = reactive({
  current: 1,
  pageSize: 10,
  total: 0,
  showSizeChanger: true,
  showQuickJumper: true,
  showTotal: (total: number) => `共 ${total} 条记录`,
  onChange: (page: number, pageSize: number) => {
    pagination.current = page;
    pagination.pageSize = pageSize;
    loadActivityList();
  }
});

// 行选择配置
const rowSelection = {
  selectedRowKeys,
  onChange: (keys: string[]) => {
    selectedRowKeys.value = keys;
  }
};

// 计算属性
const modalTitle = computed(() => isEdit.value ? '编辑活动预约' : '新增活动预约');

// 工具函数
const filterOption = (input: string, option: any) => {
  return option.children.toLowerCase().indexOf(input.toLowerCase()) >= 0;
};

const getServiceTypeColor = (serviceType: string) => {
  const colors = {
    '送餐服务': 'blue',
    '房间保洁': 'green',
    '按摩服务': 'orange',
    '医疗检查': 'red',
    '康复训练': 'purple',
    '心理咨询': 'cyan',
    '娱乐活动': 'magenta'
  };
  return colors[serviceType] || 'default';
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

// 修改后的优先级处理函数
const getPriorityColor = (priority: string) => {
  // 添加大小写转换和空值处理
  const cleanPriority = priority?.toString().trim().toLowerCase() || 'normal';
  
  const colors = {
    '低': 'green',
    '中': 'blue',
    '高': 'orange',
    '紧急': 'red'
  };
  
  return colors[cleanPriority] || 'default';
};

const getPriorityText = (priority: string) => {
  // 添加大小写转换和空值处理
  const cleanPriority = priority?.toString().trim().toLowerCase() || 'normal';
  
  const texts = {
    '低': '低',
    '中': '中',
    '高': '高',
    '紧急': '紧急'
  };
  
  return texts[cleanPriority] || '未知'; // 默认显示"普通"
};

const formatDate = (dateTime: string) => {
  if (!dateTime) return '';
  return new Date(dateTime).toLocaleDateString();
};

const formatTime = (dateTime: string) => {
  if (!dateTime) return '';
  return new Date(dateTime).toLocaleTimeString();
};

// 数据加载
// 在 loadActivityList 中确保数据正确性
const loadActivityList = async () => {
  loading.value = true;
  try {
    const response = await listApi({
      keyword: searchForm.keyword,
      page: pagination.current,
      pageSize: pagination.pageSize
    });
    
    if (response.code === 0) {
      // 添加数据验证和转换
      activityList.value = response.data.map(item => {
        // 验证优先级字段是否存在
        if (!item.hasOwnProperty('priority')) {
          console.warn('记录缺少 priority 字段:', item);
        }
        
        return {
          ...item,
          // 确保优先级有默认值
          priority: item.priority || 'normal'
        };
      });
      
      updateActivityStats(response.data);
    }
  } catch (error) {
    message.error('加载活动列表失败');
  } finally {
    loading.value = false;
  }
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

const loadWorkerList = async () => {
  try {
    const response = await workerListApi({});
    if (response.code === 0) {
      workerList.value = response.data;
    }
  } catch (error) {
    console.error('加载护工列表失败');
  }
};

const updateActivityStats = (data: any[]) => {
  activityStats.totalCount = data.length;
  activityStats.todayCount = data.filter(record => {
    const today = new Date().toDateString();
    const recordDate = new Date(record.create_time).toDateString();
    return today === recordDate;
  }).length;
  activityStats.todayCompleted = data.filter(record =>
    record.status === 'completed'
  ).length;
};

// 事件处理
const handleSearch = () => {
  pagination.current = 1;
  loadActivityList();
};

const handleReset = () => {
  searchForm.keyword = '';
  searchForm.serviceType = undefined;
  searchForm.status = undefined;
  searchForm.date = undefined;
  handleSearch();
};

const handleAdd = () => {
  isEdit.value = false;
  modalVisible.value = true;
  resetForm();
};

const handleEdit = (record: any) => {
  isEdit.value = true;
  modalVisible.value = true;
  Object.assign(formData, record);
};

const handleView = (record: any) => {
  message.info(`查看活动预约详情`);
};

const handleStatusChange = (record: any) => {
  message.info(`开始执行活动: ${record.title}`);
};

const handleComplete = (record: any) => {
  message.info(`完成活动: ${record.title}`);
};

const handleDelete = async (record: any) => {
  try {
    await deleteApi({ ids: record.id });
    message.success('删除成功');
    loadActivityList();
  } catch (error) {
    message.error('删除失败');
  }
};

const handleBatchDelete = async () => {
  if (selectedRowKeys.value.length === 0) {
    message.warning('请选择要删除的记录');
    return;
  }

  try {
    await deleteApi({ ids: selectedRowKeys.value.join(',') });
    message.success('批量删除成功');
    selectedRowKeys.value = [];
    loadActivityList();
  } catch (error) {
    message.error('批量删除失败');
  }
};

const handleExport = () => {
  message.info('导出功能开发中');
};

const handleSubmit = async () => {
  try {
    await formRef.value.validate();
    submitting.value = true;

    if (isEdit.value) {
      await updateApi({ id: formData.id }, formData);
      message.success('更新成功');
    } else {
      await createApi(formData);
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

const handleCancel = () => {
  modalVisible.value = false;
  resetForm();
};

const resetForm = () => {
  Object.assign(formData, {
    id: undefined,
    name: '',
    title: '',
    activity_time: undefined,
    worker: '',
    priority: 'normal',
    duration: 60,
    status: 'pending',
    remark: ''
  });
  formRef.value?.resetFields();
};

// 生命周期
onMounted(() => {
  loadActivityList();
  loadElderlyList();
  loadWorkerList();
});
</script>

<style lang="less" scoped>
.activity-modern {
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

.activity-stats {
  margin-bottom: 24px;

  .stats-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.activity-list {
  .list-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}
</style>
