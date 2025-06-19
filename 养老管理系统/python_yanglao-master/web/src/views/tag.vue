<template>
  <div>
    <!--页面区域-->
    <div class="page-view">
      <div class="table-operations">
        <a-space>
          <a-button type="primary" @click="handleAdd">新增活动预约</a-button>
          <a-button @click="handleBatchDelete">批量删除</a-button>
        </a-space>
      </div>
      <a-table
        size="middle"
        rowKey="id"
        :loading="data.loading"
        :columns="columns"
        :data-source="data.tagList"
        :scroll="{ x: 'max-content' }"
        :row-selection="rowSelection"
        :pagination="{
          size: 'default',
          current: data.page,
          pageSize: data.pageSize,
          onChange: (current) => (data.page = current),
          showSizeChanger: false,
          showTotal: (total) => `共${total}条数据`,
        }"
      >
        <template #bodyCell="{ text, record, index, column }">
          <template v-if="column.key === 'operation'">
            <span>
              <a @click="handleEdit(record)">编辑</a>
              <a-divider type="vertical" />
              <a-popconfirm title="确定删除?" ok-text="是" cancel-text="否" @confirm="confirmDelete(record)">
                <a href="#">删除</a>
              </a-popconfirm>
            </span>
          </template>
        </template>
      </a-table>
    </div>

    <!--弹窗区域-->
    <div>
      <a-modal
        :visible="modal.visile"
        :forceRender="true"
        :title="modal.title"
        ok-text="确认"
        cancel-text="取消"
        @cancel="handleCancel"
        @ok="handleOk"
      >
        <template #footer>
          <a-button key="back" @click="handleCancel">取消</a-button>
          <a-button key="submit" type="primary" :loading="submitting" @click="handleOk">确认</a-button>
        </template>
        <div>
          <a-form ref="myform" :label-col="{ style: { width: '80px' } }" :model="modal.form" :rules="modal.rules">
            <a-row :gutter="24">
              <a-col span="24">
                <a-form-item label="老人姓名" name="name">
                  <a-input placeholder="请输入" v-model:value="modal.form.name"></a-input>
                </a-form-item>
              </a-col>
              <a-col span="24">
                <a-form-item label="活动名称" name="title">
                 <a-input placeholder="请输入" v-model:value="modal.form.title"></a-input>
               </a-form-item>
              </a-col>
               <a-col span="24">
                <a-form-item label="活动时间" name="activity_time">
                 <a-date-picker
                   show-time
                   format="YYYY-MM-DD HH:mm:ss"
                   v-model:value="modal.form.activity_time"
                   style="width: 100%"
                   :show-now="false"
                   :show-today="true"
                   ok-text="确定"
                   :time-picker-props="{
                     format: 'HH:mm:ss',
                     showNow: false
                   }"
                 />
              </a-form-item>
              </a-col>
                <a-col span="24">
                  <a-form-item label="护工" name="worker">
                   <a-input placeholder="请输入" v-model:value="modal.form.worker"></a-input>
                </a-form-item>
              </a-col>
            </a-row>
          </a-form>
        </div>
      </a-modal>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref, reactive, onMounted } from 'vue';
  import { FormInstance, message } from 'ant-design-vue';
  import { createApi, listApi, updateApi, deleteApi } from '/@/api/tag';

  // 定义数据项类型
  interface DataItem {
    id: string | number;
    [key: string]: any;
  }


  const columns = reactive([
    {
      title: '序号',
      dataIndex: 'index',
      key: 'index',
      align: 'center'
    },
    {
      title: '老人姓名',
      dataIndex: 'name',      // 新增字段
      key: 'name',
      align: 'center'
    },
    {
      title: '活动名称',
      dataIndex: 'title',
      key: 'title',
      align: 'center'
    },
    {
    title: '活动时间',
    dataIndex: 'activity_time', // 新增字段
    key: 'activity_time',
    align: 'center'
   },
    {
    title: '护工',
    dataIndex: 'worker',   // 新增字段
    key: 'worker',
    align: 'center'
   },
    {
      title: '操作',
      dataIndex: 'action',
      key: 'operation',
      align: 'center',
      fixed: 'right',
      width: 140,
    },
  ]);

  // 页面数据
  const data = reactive({
    tagList: [],
    loading: false,
    keyword: '',
    selectedRowKeys: [] as any[],
    pageSize: 10,
    page: 1,
  });

  // 弹窗数据源
  const modal = reactive({
    visible: false,
    editFlag: false,
    title: '',
    form: {
      id: undefined,
      name: undefined,
      title: undefined,
      activity_time: undefined,
      worker: undefined,
    },
    rules: {
          name: [{ required: true, message: '请输入姓名', trigger: 'change' }],
          title: [{ required: true, message: '请输入', trigger: 'change' }],
          activity_time: [{ required: true, message: '请选择活动时间', trigger: 'change' }],
          worker: [{ required: true, message: '请输入护工姓名', trigger: 'change' }],
           },
  });

  const myform = ref<FormInstance>();
  const submitting = ref<boolean>(false);

  onMounted(() => {
    getDataList();
  });

  const getDataList = () => {
    data.loading = true;
    listApi({
      keyword: data.keyword,
    })
      .then((res) => {
        data.loading = false;
        console.log(res);
        res.data.forEach((item: any, index: any) => {
          item.index = index + 1;
        });
        data.tagList = res.data;
      })
      .catch((err) => {
        data.loading = false;
        console.log(err);
      });
  };

  const onSearchChange = (e: Event) => {
    data.keyword = e?.target?.value;
    console.log(data.keyword);
  };

  const onSearch = () => {
    getDataList();
  };

  const rowSelection = ref({
    onChange: (selectedRowKeys: (string | number)[], selectedRows: DataItem[]) => {
      console.log(`selectedRowKeys: ${selectedRowKeys}`, 'selectedRows: ', selectedRows);
      data.selectedRowKeys = selectedRowKeys;
    },
  });

  const handleAdd = () => {
    resetModal();
    modal.visible = true;
    modal.editFlag = false;
    modal.title = '新增活动预约';
    // 重置
    for (const key in modal.form) {
      modal.form[key] = undefined;
    }
  };
  const handleEdit = (record: any) => {
    resetModal();
    modal.visible = true;
    modal.editFlag = true;
    modal.title = '编辑活动预约';
    // 重置
    for (const key in modal.form) {
      modal.form[key] = undefined;
    }
    for (const key in record) {
      modal.form[key] = record[key];
    }
  };

  const confirmDelete = (record: any) => {
    console.log('delete', record);
    deleteApi({ ids: record.id })
      .then((res) => {
        getDataList();
      })
      .catch((err) => {
        message.error(err.msg || '操作失败');
      });
  };

  const handleBatchDelete = () => {
    console.log(data.selectedRowKeys);
    if (data.selectedRowKeys.length <= 0) {
      console.log('hello');
      message.warn('请勾选删除项');
      return;
    }
    deleteApi({ ids: data.selectedRowKeys.join(',') })
      .then((res) => {
        message.success('删除成功');
        data.selectedRowKeys = [];
        getDataList();
      })
      .catch((err) => {
        message.error(err.msg || '操作失败');
      });
  };

  const handleOk = () => {
    myform.value
      ?.validate()
      .then(() => {
        submitting.value = true;
        if (modal.editFlag) {
          updateApi({ id: modal.form.id }, modal.form)
            .then((res) => {
              submitting.value = false;
              message.success('更新成功');
              hideModal();
              getDataList();
            })
            .catch((err) => {
              submitting.value = false;
              message.error(err.msg || '操作失败');
            });
        } else {
          createApi(modal.form)
            .then((res) => {
              submitting.value = false;
              message.success('创建成功');
              hideModal();
              getDataList();
            })
            .catch((err) => {
              submitting.value = false;
              message.error(err.msg || '操作失败');
            });
        }
      })
      .catch((err) => {
        console.log('不能为空');
      });
  };

  const handleCancel = () => {
    hideModal();
  };

  // 恢复表单初始状态
  const resetModal = () => {
    myform.value?.resetFields();
  };

  // 关闭弹窗
  const hideModal = () => {
    modal.visible = false;
  };
</script>

<style scoped lang="less">
  .page-view {
    min-height: 100%;
    background: #fff;
    padding: 24px;
    display: flex;
    flex-direction: column;
  }

  .table-operations {
    margin-bottom: 16px;
    text-align: right;
  }

  .table-operations > button {
    margin-right: 8px;
  }
</style>
