<template>
  <div class="my-activities-container">
    <!-- 快速预约卡片 -->
    <div class="quick-booking">
      <a-row :gutter="16">
        <a-col :span="6" v-for="service in quickServices" :key="service.key">
          <a-card class="service-card" @click="quickBook(service)">
            <div class="service-item">
              <div class="service-icon">
                <component :is="service.icon" :style="{ color: service.color, fontSize: '32px' }" />
              </div>
              <div class="service-info">
                <div class="service-name">{{ service.name }}</div>
                <div class="service-desc">{{ service.desc }}</div>
              </div>
            </div>
          </a-card>
        </a-col>
      </a-row>
    </div>

    <!-- 我的预约记录 -->
    <a-card title="我的活动预约" class="activities-records">
      <template #extra>
        <a-button type="primary" @click="showBookingModal">
          <PlusOutlined />
          新增预约
        </a-button>
      </template>
      
      <a-table
        :columns="columns"
        :data-source="activities"
        :loading="loading"
        row-key="id"
        :pagination="{ pageSize: 10 }"
      >
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'action'">
            <a-space>
              <a-button type="link" @click="viewActivity(record)">查看</a-button>
              <a-button type="link" @click="editActivity(record)" v-if="canEdit(record)">编辑</a-button>
              <a-button type="link" danger @click="cancelActivity(record)" v-if="canCancel(record)">取消</a-button>
            </a-space>
          </template>
          <template v-if="column.key === 'status'">
            <a-tag :color="getStatusColor(record)">
              {{ getStatusText(record) }}
            </a-tag>
          </template>
        </template>
      </a-table>
    </a-card>

    <!-- 预约模态框 -->
    <a-modal
      v-model:visible="modalVisible"
      :title="modalTitle"
      width="600px"
      @ok="handleSubmit"
      @cancel="handleCancel"
    >
      <template #footer>
        <a-button @click="handleCancel">取消</a-button>
        <a-button type="primary" :loading="submitting" @click="handleSubmit">确认</a-button>
      </template>
      <a-form
        ref="formRef"
        :model="formData"
        :rules="rules"
        layout="vertical"
      >
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="服务类型" name="title">
              <a-select v-model:value="formData.title" placeholder="请选择服务类型">
                <a-select-option value="送餐服务">送餐服务</a-select-option>
                <a-select-option value="保洁服务">保洁服务</a-select-option>
                <a-select-option value="按摩理疗">按摩理疗</a-select-option>
                <a-select-option value="医疗陪护">医疗陪护</a-select-option>
                <a-select-option value="康复训练">康复训练</a-select-option>
                <a-select-option value="心理咨询">心理咨询</a-select-option>
                <a-select-option value="其他服务">其他服务</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="预约时间" name="activity_time">
              <a-date-picker
                v-model:value="formData.activity_time"
                show-time
                format="YYYY-MM-DD HH:mm"
                placeholder="选择预约时间"
                style="width: 100%"
                :disabled-date="disabledDate"
                :disabled-time="disabledTime"
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
            <a-form-item label="指定护工" name="worker">
              <a-select v-model:value="formData.worker" placeholder="请选择护工" allow-clear>
                <a-select-option v-for="worker in workers" :key="worker.id" :value="worker.title">
                  {{ worker.title }} - {{ worker.skill }}
                </a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="紧急程度" name="priority">
              <a-select v-model:value="formData.priority" placeholder="请选择紧急程度">
                <a-select-option value="低">低</a-select-option>
                <a-select-option value="中">中</a-select-option>
                <a-select-option value="高">高</a-select-option>
                <a-select-option value="紧急">紧急</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="特殊要求" name="remark">
              <a-textarea v-model:value="formData.remark" :rows="3" placeholder="请输入特殊要求或备注" />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { message, Modal } from 'ant-design-vue';
import dayjs from 'dayjs';
import {
  PlusOutlined,
  CarOutlined,
  CleaningServicesOutlined,
  MedicineBoxOutlined,
  HeartOutlined
} from '@ant-design/icons-vue';
import { listApi as tagListApi, createApi as tagCreateApi, updateApi as tagUpdateApi, deleteApi as tagDeleteApi } from '/@/api/tag';
import { listApi as workerListApi } from '/@/api/worker';
import { useUserStore } from '/@/store';

const userStore = useUserStore();
const loading = ref(false);
const modalVisible = ref(false);
const modalTitle = ref('');
const isEdit = ref(false);
const formRef = ref();
const submitting = ref(false);

const activities = ref([]);
const workers = ref([]);

const quickServices = [
  {
    key: 'meal',
    name: '送餐服务',
    desc: '营养配餐送达',
    icon: 'CarOutlined',
    color: '#ff7875'
  },
  {
    key: 'cleaning',
    name: '保洁服务', 
    desc: '房间清洁整理',
    icon: 'CleaningServicesOutlined',
    color: '#40a9ff'
  },
  {
    key: 'massage',
    name: '按摩理疗',
    desc: '专业按摩护理',
    icon: 'HeartOutlined',
    color: '#73d13d'
  },
  {
    key: 'medical',
    name: '医疗陪护',
    desc: '就医陪同服务',
    icon: 'MedicineBoxOutlined',
    color: '#b37feb'
  }
];

const formData = reactive({
  id: undefined,
  title: '',
  activity_time: undefined,
  worker: '',
  priority: '中',
  remark: ''
});

const rules = {
  title: [{ required: true, message: '请选择服务类型', trigger: 'change' }],
  activity_time: [{ required: true, message: '请选择预约时间', trigger: 'change' }]
};

const columns = [
  {
    title: '服务类型',
    dataIndex: 'title',
    key: 'title',
    width: 120
  },
  {
    title: '预约时间',
    dataIndex: 'activity_time',
    key: 'activity_time',
    width: 150
  },
  {
    title: '指定护工',
    dataIndex: 'worker',
    key: 'worker',
    width: 100
  },
  {
    title: '状态',
    key: 'status',
    width: 80
  },
  {
    title: '特殊要求',
    dataIndex: 'remark',
    key: 'remark',
    customRender: ({ text }) => text || '无'

  },
  {
    title: '操作',
    key: 'action',
    width: 150,
    fixed: 'right'
  }
];

const disabledDate = (current: any) => {
  return current && current < dayjs().startOf('day');
};

const disabledTime = () => {
  const now = dayjs();
  return {
    disabledHours: () => {
      const hours = [];
      for (let i = 0; i < now.hour(); i++) {
        hours.push(i);
      }
      return hours;
    }
  };
};

const getStatusColor = (record: any) => {
  const activityTime = dayjs(record.activity_time);
  const now = dayjs();
  
  if (activityTime.isBefore(now)) {
    return 'default';
  } else if (activityTime.diff(now, 'hour') < 2) {
    return 'orange';
  } else {
    return 'blue';
  }
};

const getStatusText = (record: any) => {
  const activityTime = dayjs(record.activity_time);
  const now = dayjs();
  
  if (activityTime.isBefore(now)) {
    return '已完成';
  } else if (activityTime.diff(now, 'hour') < 2) {
    return '即将开始';
  } else {
    return '已预约';
  }
};

const canEdit = (record: any) => {
  return dayjs(record.activity_time).isAfter(dayjs().add(1, 'hour'));
};

const canCancel = (record: any) => {
  return dayjs(record.activity_time).isAfter(dayjs().add(2, 'hour'));
};

const loadActivities = async () => {
  loading.value = true;
  try {

activities.value = [
      {
        id: 'test1',
        title: '测试送餐',
        activity_time: '2025-06-21 12:00:00',
        worker: '王护工',
        priority: '中',
        remark: '需要低糖餐食' // 明确包含测试数据
      },
    ];

    const response = await tagListApi({});
    console.log('完整API响应:', response); 
    if (response.code === 0) {
      const currentUser = userStore.admin_user_nickname || userStore.admin_user_name;
      activities.value = response.data.filter((activity: any) => 
        activity.name === currentUser).map((item: any) => ({ 
          ...item,
          remark: item.remark || '无' // 确保remark有值
        })).sort((a: any, b: any) => new Date(b.activity_time).getTime() - new Date(a.activity_time).getTime());
    }
  } catch (error) {
    message.error('加载活动记录失败');
  } finally {
    loading.value = false;
  }
};

const loadWorkers = async () => {
  try {
    const response = await workerListApi({});
    if (response.code === 0) {
      workers.value = response.data;
    }
  } catch (error) {
    console.error('加载护工列表失败');
  }
};

const quickBook = (service: any) => {
  modalVisible.value = true;
  modalTitle.value = `预约${service.name}`;
  isEdit.value = false;
  resetForm();
  formData.title = service.name;
  formData.activity_time = dayjs().add(1, 'hour');
};

const showBookingModal = () => {
  modalVisible.value = true;
  modalTitle.value = '新增预约';
  isEdit.value = false;
  resetForm();
};

const editActivity = (record: any) => {
  modalVisible.value = true;
  modalTitle.value = '编辑预约';
  isEdit.value = true;
  formData.id = record.id;
  formData.title = record.title;
  formData.activity_time = dayjs(record.activity_time);
  formData.worker = record.worker || '';
  formData.priority = record.priority || '中';
  formData.remark = record.remark || '';
};

const viewActivity = (record: any) => {
  // 显示详细的预约信息
  const content = `
    服务类型：${record.title}
    预约时间：${record.activity_time}
    指定护工：${record.worker || '未指定'}
    紧急程度：${record.priority || '中'}
    特殊要求：${record.remark || '无'}
    状态：${getStatusText(record)}
  `;

  Modal.info({
    title: '预约详情',
    content: content,
    width: 500,
    okText: '确定'
  });
};

const cancelActivity = async (record: any) => {
  Modal.confirm({
    title: '确认取消预约',
    content: `确定要取消"${record.title}"的预约吗？取消后不可恢复。`,
    okText: '确认取消',
    cancelText: '保留预约',
    okType: 'danger',
    onOk: async () => {
      try {
        // 调用删除API
        await tagDeleteApi({ ids: record.id });
        message.success('预约已取消');
        loadActivities();
      } catch (error) {
        message.error('取消预约失败');
      }
    }
  });
};

const resetForm = () => {
  Object.assign(formData, {
    id: undefined,
    title: '',
    activity_time: undefined,
    worker: '',
    priority: '中',
    remark: ''
  });
};

const handleSubmit = async () => {
  try {
    await formRef.value.validate();
    submitting.value = true;

    const submitData = {
      id: formData.id,
      title: formData.title,
      activity_time: formData.activity_time.format('YYYY-MM-DD HH:mm:ss'),
      worker: formData.worker,
      priority: formData.priority,
      remark: formData.remark || '', // 明确提交remark
      name: userStore.admin_user_nickname || userStore.admin_user_name
    };

    if (isEdit.value) {
      await tagUpdateApi({ id: formData.id }, submitData);
      message.success('预约更新成功');
    } else {
      await tagCreateApi(submitData);
      message.success('预约创建成功');
    }

    modalVisible.value = false;
    loadActivities();
  } catch (error) {
    message.error('操作失败');
  } finally {
    submitting.value = false;
  }
};

const handleCancel = () => {
  modalVisible.value = false;
  resetForm();
};

onMounted(() => {
  loadActivities();
  loadWorkers();
});
</script>

<style lang="less" scoped>
.my-activities-container {
  padding: 24px;
  background: #f5f7fa;
  min-height: 100vh;
}

.quick-booking {
  margin-bottom: 24px;
}

.service-card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  cursor: pointer;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  }
}

.service-item {
  display: flex;
  align-items: center;
  padding: 16px 0;
}

.service-icon {
  margin-right: 16px;
}

.service-info {
  flex: 1;
}


.service-name {
  font-size: 16px;
  font-weight: 600;
  color: #262626;
  margin-bottom: 4px;
}

.service-desc {
  font-size: 12px;
  color: #8c8c8c;
}

.activities-records {
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
</style>
