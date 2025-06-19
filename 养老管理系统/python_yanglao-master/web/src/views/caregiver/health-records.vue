<template>
  <div class="caregiver-health-records">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <HeartOutlined class="title-icon" />
          健康记录管理
        </h1>
        <p class="page-description">管理老人健康数据，监控健康状况</p>
      </div>
      <div class="header-actions">
        <a-button type="primary" size="large" @click="showAddModal">
          <PlusOutlined />
          新增健康记录
        </a-button>
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-section">
      <a-row :gutter="16">
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="今日记录"
              :value="stats.todayRecords"
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
              title="异常记录"
              :value="stats.abnormalRecords"
              :value-style="{ color: '#ff4d4f' }"
            >
              <template #prefix>
                <ExclamationCircleOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="负责老人"
              :value="stats.elderlyCount"
              :value-style="{ color: '#52c41a' }"
            >
              <template #prefix>
                <UserOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
        <a-col :span="6">
          <a-card class="stat-card">
            <a-statistic
              title="总记录数"
              :value="stats.totalRecords"
              :value-style="{ color: '#722ed1' }"
            >
              <template #prefix>
                <DatabaseOutlined />
              </template>
            </a-statistic>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 搜索和筛选 -->
    <div class="search-section">
      <a-card class="search-card">
        <a-row :gutter="16" align="middle">
          <a-col :span="6">
            <a-input-search
              v-model:value="searchForm.keyword"
              placeholder="搜索老人姓名"
              @search="handleSearch"
              size="large"
            />
          </a-col>
          <a-col :span="4">
            <a-date-picker
              v-model:value="searchForm.date"
              placeholder="选择日期"
              size="large"
              style="width: 100%"
              @change="handleSearch"
            />
          </a-col>
          <a-col :span="4">
            <a-select
              v-model:value="searchForm.status"
              placeholder="健康状态"
              size="large"
              allowClear
              @change="handleSearch"
            >
              <a-select-option value="normal">正常</a-select-option>
              <a-select-option value="warning">预警</a-select-option>
              <a-select-option value="abnormal">异常</a-select-option>
            </a-select>
          </a-col>
          <a-col :span="6">
            <a-space>
              <a-button @click="handleReset">重置</a-button>
              <a-button type="primary" @click="handleSearch">搜索</a-button>
            </a-space>
          </a-col>
          <a-col :span="4" class="text-right">
            <a-button @click="exportRecords">
              <DownloadOutlined />
              导出记录
            </a-button>
          </a-col>
        </a-row>
      </a-card>
    </div>

    <!-- 健康记录列表 -->
    <div class="records-section">
      <a-card class="records-card">
        <a-table
          :columns="columns"
          :data-source="healthRecords"
          :loading="loading"
          :pagination="pagination"
          :scroll="{ x: 1200 }"
          size="middle"
          class="records-table"
        >
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'healthStatus'">
              <a-tag :color="getHealthStatusColor(record)">
                {{ getHealthStatusText(record) }}
              </a-tag>
            </template>
            
            <template v-if="column.key === 'temperature'">
              <span :class="getTemperatureClass(record.temperature)">
                {{ record.temperature }}°C
              </span>
            </template>
            
            <template v-if="column.key === 'pressure'">
              <span :class="getPressureClass(record.pressure)">
                {{ record.pressure }}
              </span>
            </template>
            
            <template v-if="column.key === 'bmi'">
              <span :class="getBMIClass(calculateBMI(record.height, record.weight))">
                {{ calculateBMI(record.height, record.weight) }}
              </span>
            </template>
            
            <template v-if="column.key === 'action'">
              <a-space>
                <a-button type="link" size="small" @click="viewRecord(record)">
                  <EyeOutlined />
                  查看
                </a-button>
                <a-button type="link" size="small" @click="editRecord(record)">
                  <EditOutlined />
                  编辑
                </a-button>
                <a-popconfirm
                  title="确定要删除这条记录吗？"
                  @confirm="deleteRecord(record)"
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

    <!-- 新增/编辑健康记录模态框 -->
    <a-modal
      v-model:visible="modalVisible"
      :title="modalTitle"
      width="800px"
      :mask-closable="false"
      :destroy-on-close="true"
      centered
    >
      <template #footer>
        <a-button @click="handleCancel">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleSubmit">
          {{ isEdit ? '更新' : '保存' }}
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
            <a-form-item label="老人姓名" name="title">
              <a-select
                v-model:value="formData.title"
                placeholder="请选择老人"
                size="large"
                show-search
              >
                <a-select-option v-for="elderly in elderlyList" :key="elderly.id" :value="elderly.title">
                  {{ elderly.title }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="性别" name="sex">
              <a-select v-model:value="formData.sex" placeholder="性别" size="large">
                <a-select-option value="男">男</a-select-option>
                <a-select-option value="女">女</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="年龄" name="age">
              <a-input v-model:value="formData.age" placeholder="年龄" size="large" />
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="身高(cm)" name="height">
              <a-input v-model:value="formData.height" placeholder="170" size="large" />
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="体重(kg)" name="weight">
              <a-input v-model:value="formData.weight" placeholder="65" size="large" />
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="体温(°C)" name="temperature">
              <a-input v-model:value="formData.temperature" placeholder="36.5" size="large" />
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="血压" name="pressure">
              <a-input v-model:value="formData.pressure" placeholder="120/80" size="large" />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="备注" name="remark">
              <a-textarea
                v-model:value="formData.remark"
                placeholder="请输入健康状况备注"
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
import { useUserStore } from '/@/store';
import {
  HeartOutlined,
  PlusOutlined,
  CalendarOutlined,
  ExclamationCircleOutlined,
  UserOutlined,
  DatabaseOutlined,
  DownloadOutlined,
  EyeOutlined,
  EditOutlined,
  DeleteOutlined
} from '@ant-design/icons-vue';
import { listApi, createApi, updateApi, deleteApi } from '/@/api/health';
import { listApi as elderlyListApi } from '/@/api/thing';

const userStore = useUserStore();
const loading = ref(false);
const modalVisible = ref(false);
const submitting = ref(false);
const isEdit = ref(false);
const healthRecords = ref([]);
const elderlyList = ref([]);
const formRef = ref();

// 搜索表单
const searchForm = reactive({
  keyword: '',
  date: undefined,
  status: undefined
});

// 表单数据
const formData = reactive({
  id: undefined,
  title: '',
  sex: undefined,
  age: '',
  height: '',
  weight: '',
  temperature: '',
  pressure: '',
  remark: ''
});

// 统计数据
const stats = reactive({
  todayRecords: 0,
  abnormalRecords: 0,
  elderlyCount: 0,
  totalRecords: 0
});

// 表单验证规则
const formRules = {
  title: [{ required: true, message: '请选择老人', trigger: 'change' }],
  temperature: [{ required: true, message: '请输入体温', trigger: 'blur' }],
  pressure: [{ required: true, message: '请输入血压', trigger: 'blur' }],
  weight: [{ required: true, message: '请输入体重', trigger: 'blur' }],
  height: [{ required: true, message: '请输入身高', trigger: 'blur' }]
};

// 表格列定义
const columns = [
  { title: '老人姓名', dataIndex: 'title', key: 'title', width: 100, fixed: 'left' },
  { title: '性别', dataIndex: 'sex', key: 'sex', width: 60, align: 'center' },
  { title: '年龄', dataIndex: 'age', key: 'age', width: 60, align: 'center' },
  { title: '身高(cm)', dataIndex: 'height', key: 'height', width: 80, align: 'center' },
  { title: '体重(kg)', dataIndex: 'weight', key: 'weight', width: 80, align: 'center' },
  { title: 'BMI', key: 'bmi', width: 80, align: 'center' },
  { title: '体温(°C)', dataIndex: 'temperature', key: 'temperature', width: 90, align: 'center' },
  { title: '血压', dataIndex: 'pressure', key: 'pressure', width: 100, align: 'center' },
  { title: '健康状态', key: 'healthStatus', width: 100, align: 'center' },
  { title: '记录时间', dataIndex: 'create_time', key: 'create_time', width: 160 },
  { title: '操作', key: 'action', width: 180, fixed: 'right', align: 'center' }
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
    loadHealthRecords();
  }
});

// 计算属性
const modalTitle = computed(() => isEdit.value ? '编辑健康记录' : '新增健康记录');

// 工具函数
const calculateBMI = (height: string, weight: string) => {
  const h = parseFloat(height) / 100;
  const w = parseFloat(weight);
  if (h && w) {
    return (w / (h * h)).toFixed(1);
  }
  return '--';
};

const getHealthStatusColor = (record: any) => {
  // 简单的健康状态判断
  const temp = parseFloat(record.temperature);
  if (temp < 36.0 || temp > 37.5) return 'warning';
  return 'success';
};

const getHealthStatusText = (record: any) => {
  const temp = parseFloat(record.temperature);
  if (temp < 36.0 || temp > 37.5) return '异常';
  return '正常';
};

const getTemperatureClass = (temperature: string) => {
  const temp = parseFloat(temperature);
  if (temp < 36.0 || temp > 37.5) return 'abnormal-value';
  return 'normal-value';
};

const getPressureClass = (pressure: string) => {
  return 'normal-value';
};

const getBMIClass = (bmi: string) => {
  const bmiValue = parseFloat(bmi);
  if (bmiValue < 18.5 || bmiValue > 24.9) return 'abnormal-value';
  return 'normal-value';
};

// 数据加载
const loadHealthRecords = async () => {
  loading.value = true;
  try {
    const response = await listApi({
      keyword: searchForm.keyword,
      page: pagination.current,
      pageSize: pagination.pageSize
    });
    if (response.code === 0) {
      healthRecords.value = response.data;
      updateStats(response.data);
    }
  } catch (error) {
    message.error('加载健康记录失败');
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

const updateStats = (data: any[]) => {
  stats.totalRecords = data.length;
  stats.todayRecords = data.filter(record => {
    const today = new Date().toDateString();
    const recordDate = new Date(record.create_time).toDateString();
    return today === recordDate;
  }).length;
  stats.abnormalRecords = data.filter(record => {
    const temp = parseFloat(record.temperature);
    return temp < 36.0 || temp > 37.5;
  }).length;
  stats.elderlyCount = elderlyList.value.length;
};

// 事件处理
const handleSearch = () => {
  pagination.current = 1;
  loadHealthRecords();
};

const handleReset = () => {
  searchForm.keyword = '';
  searchForm.date = undefined;
  searchForm.status = undefined;
  handleSearch();
};

const showAddModal = () => {
  isEdit.value = false;
  modalVisible.value = true;
  resetForm();
};

const viewRecord = (record: any) => {
  message.info(`查看 ${record.title} 的健康记录详情`);
};

const editRecord = (record: any) => {
  isEdit.value = true;
  modalVisible.value = true;
  Object.assign(formData, record);
};

const deleteRecord = async (record: any) => {
  try {
    await deleteApi({ ids: record.id });
    message.success('删除成功');
    loadHealthRecords();
  } catch (error) {
    message.error('删除失败');
  }
};

const exportRecords = () => {
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
    loadHealthRecords();
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
    title: '',
    sex: undefined,
    age: '',
    height: '',
    weight: '',
    temperature: '',
    pressure: '',
    remark: ''
  });
  formRef.value?.resetFields();
};

onMounted(() => {
  loadHealthRecords();
  loadElderlyList();
});
</script>

<style lang="less" scoped>
.caregiver-health-records {
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

.stats-section, .search-section, .records-section {
  margin-bottom: 24px;
  
  .stat-card, .search-card, .records-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.records-table {
  :deep(.ant-table-thead > tr > th) {
    background: #fafafa;
    font-weight: 600;
    color: #262626;
  }
  
  .normal-value {
    color: #52c41a;
    font-weight: 500;
  }
  
  .abnormal-value {
    color: #ff4d4f;
    font-weight: 500;
  }
}

.text-right {
  text-align: right;
}
</style>
