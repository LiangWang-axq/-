<template>
  <div>
    <!--页面区域-->
    <div class="page-view">
      <div class="table-operations">
        <a-space>
          <a-button type="primary" @click="handleAdd">新增健康记录</a-button>
          <a-button @click="handleBatchDelete">批量删除</a-button>
        </a-space>
      </div>
      <a-table
        size="middle"
        rowKey="id"
        :loading="data.loading"
        :columns="columns"
        :data-source="data.healthList"
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
        v-model:visible="modal.visible"
        :forceRender="true"
        :title="modal.title"
        ok-text="确认"
        cancel-text="取消"
        @cancel="handleCancel"
        @ok="handleOk"
        width="800px"
      >
        <template #footer>
          <a-button key="back" @click="handleCancel">取消</a-button>
          <a-button key="submit" type="primary" :loading="submitting" @click="handleOk">确认</a-button>
        </template>
        <div>
          <a-form ref="myform" :label-col="{ style: { width: '80px' } }" :model="modal.form" :rules="modal.rules">
            <a-row :gutter="24">
              <a-col span="12">
                <a-form-item label="姓名" name="title">
                  <a-input placeholder="请输入老人姓名" v-model:value="modal.form.title" />
                </a-form-item>
              </a-col>
              <a-col span="12">
                <a-form-item label="性别" name="sex">
                  <a-select placeholder="请选择性别" v-model:value="modal.form.sex">
                    <a-select-option value="男">男</a-select-option>
                    <a-select-option value="女">女</a-select-option>
                  </a-select>
                </a-form-item>
              </a-col>
              <a-col span="12">
                <a-form-item label="年龄" name="age">
                  <a-input placeholder="请输入年龄" v-model:value="modal.form.age" />
                </a-form-item>
              </a-col>
              <a-col span="12">
                <a-form-item label="身高(cm)" name="height">
                  <a-input placeholder="请输入身高" v-model:value="modal.form.height" />
                </a-form-item>
              </a-col>
              <a-col span="12">
                <a-form-item label="体重(kg)" name="weight">
                  <a-input placeholder="请输入体重" v-model:value="modal.form.weight" />
                </a-form-item>
              </a-col>
              <a-col span="12">
                <a-form-item label="体温(°C)" name="temperature">
                  <a-input placeholder="请输入体温" v-model:value="modal.form.temperature" />
                </a-form-item>
              </a-col>
              <a-col span="12">
                <a-form-item label="血压" name="pressure">
                  <a-input placeholder="如：120/80" v-model:value="modal.form.pressure" />
                </a-form-item>
              </a-col>
              <a-col span="12">
                <a-form-item label="备注" name="remark">
                  <a-textarea placeholder="请输入备注信息" v-model:value="modal.form.remark" :rows="3" />
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
  import { createApi, listApi, updateApi, deleteApi } from '/@/api/health';

  const columns = reactive([
    {
      title: '姓名',
      dataIndex: 'title',
      key: 'title',
      align: 'center',
    },
    {
      title: '性别',
      dataIndex: 'sex',
      key: 'sex',
      align: 'center',
    },
    {
      title: '年龄',
      dataIndex: 'age',
      key: 'age',
      align: 'center',
    },
    {
      title: '身高(cm)',
      dataIndex: 'height',
      key: 'height',
      align: 'center',
    },
    {
      title: '体重(kg)',
      dataIndex: 'weight',
      key: 'weight',
      align: 'center',
    },
    {
      title: '体温(°C)',
      dataIndex: 'temperature',
      key: 'temperature',
      align: 'center',
    },
    {
      title: '血压',
      dataIndex: 'pressure',
      key: 'pressure',
      align: 'center',
    },
    {
      title: '备注',
      dataIndex: 'remark',
      key: 'remark',
      align: 'center',
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
    healthList: [],
    loading: false,
    currentAdminUserName: '',
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
      title: undefined,
      sex: undefined,
      age: undefined,
      height: undefined,
      weight: undefined,
      temperature: undefined,
      pressure: undefined,
      remark: undefined,
    },
    rules: {
      title: [{ required: true, message: '请输入姓名', trigger: 'change' }],
      sex: [{ required: true, message: '请选择性别', trigger: 'change' }],
      age: [{ required: true, message: '请输入年龄', trigger: 'change' }],
      height: [{ required: true, message: '请输入身高', trigger: 'change' }],
      weight: [{ required: true, message: '请输入体重', trigger: 'change' }],
      temperature: [{ required: true, message: '请输入体温', trigger: 'change' }],
      pressure: [{ required: true, message: '请输入血压', trigger: 'change' }],
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
        data.healthList = res.data;
      })
      .catch((err) => {
        data.loading = false;
        console.log(err);
      });
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
    modal.title = '新增健康记录';
    // 重置
    for (const key in modal.form) {
      modal.form[key] = undefined;
    }
  };
  const handleEdit = (record: any) => {
    resetModal();
    modal.visible = true;
    modal.editFlag = true;
    modal.title = '编辑健康记录';
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
        message.error(err.msg || '删除失败');
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
        message.error(err.msg || '删除失败');
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
              console.log(err);
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
              console.log(err);
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
