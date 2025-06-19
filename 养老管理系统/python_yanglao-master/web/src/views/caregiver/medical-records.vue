<template>
  <div class="caregiver-medical-records">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h1 class="page-title">
          <TabletOutlined class="title-icon" />
          病史查看
        </h1>
        <p class="page-description">查看和管理老人的病史记录</p>
      </div>
      <div class="header-actions">
        <a-button type="primary" size="large" @click="showAddModal">
          <PlusOutlined />
          新增病史
        </a-button>
      </div>
    </div>

    <!-- 搜索筛选 -->
    <div class="search-section">
      <a-card class="search-card">
        <a-row :gutter="16" align="middle">
          <a-col :span="6">
            <a-input-search
              v-model:value="searchForm.keyword"
              placeholder="搜索老人姓名"
              @search="handleSearch"
            />
          </a-col>
          <a-col :span="4">
            <a-select
              v-model:value="searchForm.elderlyName"
              placeholder="选择老人"
              allowClear
              @change="handleSearch"
            >
              <a-select-option value="">全部老人</a-select-option>
              <a-select-option v-for="elderly in elderlyList" :key="elderly.id" :value="elderly.title">
                {{ elderly.title }}
              </a-select-option>
            </a-select>
          </a-col>
          <a-col :span="4">
            <a-button @click="resetSearch">重置</a-button>
          </a-col>
        </a-row>
      </a-card>
    </div>

    <!-- 病史记录列表 -->
    <div class="medical-list">
      <a-card title="病史记录" class="list-card">
        <a-table
          :columns="columns"
          :data-source="filteredMedicalList"
          :loading="loading"
          :pagination="pagination"
          size="middle"
        >
          <template #bodyCell="{ column, record }">
            <template v-if="column.key === 'medical_history'">
              <a-tag color="orange">{{ record.medical_history }}</a-tag>
            </template>
            
            <template v-if="column.key === 'desc'">
              <div class="desc-content">
                {{ record.desc || '无' }}
              </div>
            </template>
            
            <template v-if="column.key === 'create_time'">
              {{ formatDate(record.create_time) }}
            </template>
            
            <template v-if="column.key === 'action'">
              <a-space>
                <a-button type="link" size="small" @click="viewDetails(record)">
                  查看详情
                </a-button>
                <a-button type="link" size="small" @click="editRecord(record)">
                  编辑
                </a-button>
                <a-popconfirm
                  title="确定要删除这条病史记录吗？"
                  @confirm="deleteRecord(record)"
                  ok-text="确定"
                  cancel-text="取消"
                >
                  <a-button type="link" size="small" danger>
                    删除
                  </a-button>
                </a-popconfirm>
              </a-space>
            </template>
          </template>
        </a-table>
      </a-card>
    </div>

    <!-- 新增/编辑病史模态框 -->
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
                show-search
              >
                <a-select-option v-for="elderly in elderlyList" :key="elderly.id" :value="elderly.title">
                  {{ elderly.title }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="病史类型" name="medical_history">
              <a-select v-model:value="formData.medical_history" placeholder="请选择病史类型">
                <a-select-option value="高血压">高血压</a-select-option>
                <a-select-option value="糖尿病">糖尿病</a-select-option>
                <a-select-option value="心脏病">心脏病</a-select-option>
                <a-select-option value="脑血管疾病">脑血管疾病</a-select-option>
                <a-select-option value="骨质疏松">骨质疏松</a-select-option>
                <a-select-option value="关节炎">关节炎</a-select-option>
                <a-select-option value="呼吸系统疾病">呼吸系统疾病</a-select-option>
                <a-select-option value="消化系统疾病">消化系统疾病</a-select-option>
                <a-select-option value="其他">其他</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="详细描述" name="desc">
              <a-textarea
                v-model:value="formData.desc"
                placeholder="请详细描述病史情况、症状、治疗方案等"
                :rows="4"
              />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
    </a-modal>

    <!-- 详情查看模态框 -->
    <a-modal
      v-model:visible="detailModalVisible"
      title="病史详情"
      width="600px"
      :footer="null"
      centered
    >
      <div class="detail-content" v-if="selectedRecord">
        <a-descriptions :column="1" bordered>
          <a-descriptions-item label="老人姓名">
            {{ selectedRecord.title }}
          </a-descriptions-item>
          <a-descriptions-item label="病史类型">
            <a-tag color="orange">{{ selectedRecord.medical_history }}</a-tag>
          </a-descriptions-item>
          <a-descriptions-item label="记录时间">
            {{ formatDate(selectedRecord.create_time) }}
          </a-descriptions-item>
          <a-descriptions-item label="详细描述">
            <div class="desc-detail">
              {{ selectedRecord.desc || '无详细描述' }}
            </div>
          </a-descriptions-item>
        </a-descriptions>
      </div>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import {
  TabletOutlined,
  PlusOutlined
} from '@ant-design/icons-vue';
import { listApi as medicalListApi, createApi, updateApi, deleteApi } from '/@/api/medical';
import { listApi as elderlyListApi } from '/@/api/thing';

const userStore = useUserStore();
const modalVisible = ref(false);
const detailModalVisible = ref(false);
const isEdit = ref(false);
const submitting = ref(false);
const loading = ref(false);
const medicalList = ref([]);
const elderlyList = ref([]);
const selectedRecord = ref(null);
const formRef = ref();

// 搜索表单
const searchForm = reactive({
  keyword: '',
  elderlyName: ''
});

// 表单数据
const formData = reactive({
  id: undefined,
  title: '',
  medical_history: '',
  desc: ''
});

// 表单验证规则
const formRules = {
  title: [{ required: true, message: '请选择老人', trigger: 'change' }],
  medical_history: [{ required: true, message: '请选择病史类型', trigger: 'change' }],
  desc: [{ required: true, message: '请输入详细描述', trigger: 'blur' }]
};

// 表格列定义
const columns = [
  { title: '老人姓名', dataIndex: 'title', key: 'title', width: 120 },
  { title: '病史类型', key: 'medical_history', width: 120, align: 'center' },
  { title: '详细描述', key: 'desc', width: 300 },
  { title: '记录时间', key: 'create_time', width: 160 },
  { title: '操作', key: 'action', width: 200, align: 'center' }
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
const modalTitle = computed(() => isEdit.value ? '编辑病史记录' : '新增病史记录');
const filteredMedicalList = computed(() => {
  let filtered = medicalList.value;
  
  if (searchForm.keyword) {
    filtered = filtered.filter(item => 
      item.title && item.title.includes(searchForm.keyword)
    );
  }
  
  if (searchForm.elderlyName) {
    filtered = filtered.filter(item => item.title === searchForm.elderlyName);
  }
  
  return filtered;
});

// 工具函数
const formatDate = (dateString: string) => {
  if (!dateString) return '';
  return new Date(dateString).toLocaleString('zh-CN');
};

// 数据加载
const loadMedicalList = async () => {
  loading.value = true;
  try {
    const response = await medicalListApi({});
    if (response.code === 0) {
      medicalList.value = response.data;
      pagination.total = response.data.length;
    }
  } catch (error) {
    message.error('加载病史记录失败');
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

// 事件处理
const handleSearch = () => {
  // 搜索逻辑已在计算属性中实现
};

const resetSearch = () => {
  searchForm.keyword = '';
  searchForm.elderlyName = '';
};

const showAddModal = () => {
  isEdit.value = false;
  modalVisible.value = true;
  resetForm();
};

const editRecord = (record: any) => {
  isEdit.value = true;
  modalVisible.value = true;
  Object.assign(formData, record);
};

const viewDetails = (record: any) => {
  selectedRecord.value = record;
  detailModalVisible.value = true;
};

const deleteRecord = async (record: any) => {
  try {
    await deleteApi({ ids: record.id });
    message.success('删除成功');
    loadMedicalList();
  } catch (error) {
    message.error('删除失败');
  }
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
    loadMedicalList();
  } catch (error) {
    message.error(isEdit.value ? '更新失败' : '创建失败');
  } finally {
    submitting.value = false;
  }
};

const resetForm = () => {
  Object.assign(formData, {
    id: undefined,
    title: '',
    medical_history: '',
    desc: ''
  });
  formRef.value?.resetFields();
};

onMounted(() => {
  loadMedicalList();
  loadElderlyList();
});
</script>

<style lang="less" scoped>
.caregiver-medical-records {
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

.search-section, .medical-list {
  margin-bottom: 24px;
  
  .search-card, .list-card {
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  }
}

.desc-content {
  max-width: 300px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.desc-detail {
  white-space: pre-wrap;
  word-break: break-word;
  line-height: 1.6;
}

.detail-content {
  .ant-descriptions-item-content {
    word-break: break-word;
  }
}
</style>
