<template>
  <div class="overview-container">
    <h1>系统概览</h1>

    <!-- 数据统计 -->
    <a-row :gutter="16" style="margin-bottom: 24px;">
      <a-col :span="6">
        <a-card>
          <a-statistic title="在住老人" :value="stats.elderly" suffix="人" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card>
          <a-statistic title="健康记录" :value="stats.health" suffix="条" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card>
          <a-statistic title="活动预约" :value="stats.activities" suffix="项" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card>
          <a-statistic title="护工数量" :value="stats.workers" suffix="人" />
        </a-card>
      </a-col>
    </a-row>

    <!-- 快速操作 -->
    <a-card title="快速操作" style="margin-bottom: 24px;">
      <a-space>
        <a-button type="primary" @click="goToPage('thing')">
          新增老人
        </a-button>
        <a-button type="primary" @click="goToPage('classification')">
          健康记录
        </a-button>
        <a-button type="primary" @click="goToPage('tag')">
          活动预约
        </a-button>
        <a-button type="primary" @click="goToPage('worker')">
          护工管理
        </a-button>
      </a-space>
    </a-card>

    <!-- 最近数据 -->
    <a-card title="最近数据">
      <a-tabs>
        <a-tab-pane key="elderly" tab="最新老人">
          <a-table
            :columns="elderlyColumns"
            :data-source="recentElderly"
            :pagination="false"
            size="small"
          />
        </a-tab-pane>
        <a-tab-pane key="health" tab="最新健康记录">
          <a-table
            :columns="healthColumns"
            :data-source="recentHealth"
            :pagination="false"
            size="small"
          />
        </a-tab-pane>
      </a-tabs>
    </a-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { listApi as thingListApi } from '/@/api/thing';
import { listApi as classificationListApi } from '/@/api/classification';
import { listApi as tagListApi } from '/@/api/tag';
import { listApi as workerListApi } from '/@/api/worker';

const router = useRouter();

const stats = reactive({
  elderly: 0,
  health: 0,
  activities: 0,
  workers: 0
});

const recentElderly = ref([]);
const recentHealth = ref([]);

const elderlyColumns = [
  { title: '姓名', dataIndex: 'title', key: 'title' },
  { title: '性别', dataIndex: 'sex', key: 'sex' },
  { title: '年龄', dataIndex: 'age', key: 'age' },
  { title: '房间', dataIndex: 'classification', key: 'classification' }
];

const healthColumns = [
  { title: '姓名', dataIndex: 'title', key: 'title' },
  { title: '体温', dataIndex: 'temperature', key: 'temperature' },
  { title: '血压', dataIndex: 'pressure', key: 'pressure' },
  { title: '记录时间', dataIndex: 'create_time', key: 'create_time' }
];

const loadData = async () => {
  try {
    const [elderlyRes, healthRes, activityRes, workerRes] = await Promise.all([
      thingListApi({}),
      classificationListApi({}),
      tagListApi({}),
      workerListApi({})
    ]);

    stats.elderly = elderlyRes.data?.length || 0;
    stats.health = healthRes.data?.length || 0;
    stats.activities = activityRes.data?.length || 0;
    stats.workers = workerRes.data?.length || 0;

    recentElderly.value = (elderlyRes.data || []).slice(0, 5);
    recentHealth.value = (healthRes.data || []).slice(0, 5);
  } catch (error) {
    console.error('加载数据失败', error);
  }
};

const goToPage = (page: string) => {
  router.push({ name: page });
};

onMounted(() => {
  loadData();
});
</script>

<style lang="less" scoped>
.overview-container {
  padding: 24px;
}

h1 {
  color: #1890ff;
  margin-bottom: 24px;
}
</style>
