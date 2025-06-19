<template>
  <a-layout id="components-layout-demo-custom-trigger">
    <a-layout-header style="background: #fff; padding: 0">
      <div class="header">
        <img class="header-logo" :src="logo" />
        <span class="header-title">天目湖社区养老管理系统</span>
        <div class="empty"></div>
        <span>{{ getRoleText() }}[{{ userStore.admin_user_nickname || userStore.admin_user_name }}]</span>
        <a class="header-quit" @click="handleLogout">退出</a>
      </div>
    </a-layout-header>
    <a-layout>
      <a-layout-sider v-model="collapsed" collapsible>
        <a-menu
          style="overflow: auto; overflow-x: hidden"
          v-model:selectedKeys="selectedKeys"
          theme="dark"
          mode="inline"
          @click="handleClick"
        >
          <!-- 管理员菜单 -->
          <template v-if="isAdmin()">
            <a-sub-menu>
              <template #icon>
                <home-outlined />
              </template>
              <template #title>核心管理</template>
              <a-menu-item key="thing">
                <home-outlined />
                <span>老人管理</span>
              </a-menu-item>
              <a-menu-item key="worker">
                <RobotOutlined />
                <span>护工管理</span>
              </a-menu-item>
              <a-menu-item key="family">
                <ScheduleOutlined />
                <span>亲属管理</span>
              </a-menu-item>
            </a-sub-menu>

            <a-sub-menu>
              <template #icon>
                <layout-outlined />
              </template>
              <template #title>健康管理</template>
              <a-menu-item key="classification">
                <layout-outlined />
                <span>健康管理</span>
              </a-menu-item>
              <a-menu-item key="medical">
                <TabletOutlined />
                <span>病史管理</span>
              </a-menu-item>
            </a-sub-menu>

            <a-sub-menu>
              <template #icon>
                <layout-outlined />
              </template>
              <template #title>活动管理</template>

              <a-menu-item key="activity-modern">
                <layout-outlined />
                <span>活动管理</span>
              </a-menu-item>
            </a-sub-menu>

            <a-sub-menu>
              <template #icon>
                <user-outlined />
              </template>
              <template #title>用户管理</template>

              <a-menu-item key="user-modern">
                <user-outlined />
                <span>用户管理</span>
              </a-menu-item>
            </a-sub-menu>
          </template>

          <!-- 老人菜单 -->
          <template v-if="isElderly()">
            <a-menu-item key="health-profile">
              <layout-outlined />
              <span>健康档案</span>
            </a-menu-item>
            <a-menu-item key="my-activities">
              <layout-outlined />
              <span>活动预约</span>
            </a-menu-item>
            <a-menu-item key="my-profile">
              <user-outlined />
              <span>个人信息</span>
            </a-menu-item>
          </template>

          <!-- 护工菜单 -->
          <template v-if="isCaregiver()">
            <a-menu-item key="my-elderly">
              <home-outlined />
              <span>老人管理</span>
            </a-menu-item>
            <a-menu-item key="elderly-health">
              <HeartOutlined />
              <span>健康记录</span>
            </a-menu-item>
            <a-menu-item key="elderly-activities">
              <CalendarOutlined />
              <span>活动管理</span>
            </a-menu-item>
            <a-menu-item key="elderly-medical">
              <TabletOutlined />
              <span>病史管理</span>
            </a-menu-item>
            <a-menu-item key="my-profile">
              <user-outlined />
              <span>个人信息</span>
            </a-menu-item>
          </template>

          <!-- 亲属菜单 -->
          <template v-if="isFamily()">
            <a-menu-item key="care-center">
              <HeartOutlined />
              <span>关爱中心</span>
            </a-menu-item>
            <a-menu-item key="family-elderly">
              <home-outlined />
              <span>家人信息</span>
            </a-menu-item>
            <a-menu-item key="family-activities">
              <CalendarOutlined />
              <span>活动记录</span>
            </a-menu-item>
            <a-menu-item key="my-profile">
              <user-outlined />
              <span>个人信息</span>
            </a-menu-item>
          </template>
        </a-menu>
      </a-layout-sider>
      <a-layout-content :style="{ margin: '16px 16px', minHeight: '200px' }">
        <router-view />
      </a-layout-content>
    </a-layout>
  </a-layout>
</template>
<script setup lang="ts">
  import { useRouter, useRoute } from 'vue-router';
  import logo from '/@/assets/images/k-logo.png';

  import {
    HomeOutlined,
    AppstoreOutlined,
    FolderOutlined,
    UserOutlined,
    CommentOutlined,
    InfoCircleOutlined,
    TagOutlined,
    PieChartOutlined,
    DollarOutlined,
    LayoutOutlined,
    DatabaseOutlined,
    RobotOutlined,
    ScheduleOutlined,
    TabletOutlined,
    DashboardOutlined,
    HeartOutlined,
    CalendarOutlined
  } from '@ant-design/icons-vue';

  import { ref, onMounted, computed } from 'vue';
  import { useUserStore } from '/@/store';

  const userStore = useUserStore();

  const selectedKeys = ref<any[]>([]);
  const collapsed = ref<boolean>(false);

  const router = useRouter();
  const route = useRoute();

  const handleClick = ({ item, key, keyPath }) => {
    console.log('点击路由===>', key);

    // 根据角色和菜单项决定跳转的路由
    const role = getUserRole();
    let routeName = key;

    // 直接使用key作为路由名，因为路由已经正确配置
    router.push({
      name: routeName,
    });
  };

  const handlePreview = () => {
    let text = router.resolve({ name: 'index' });
    window.open(text.href, '_blank');
  };

  onMounted(() => {
    console.log('当前路由===>', route.name);
    selectedKeys.value = [route.name];
  });

  const handleLogout = () => {
    userStore.adminLogout().then((res) => {
      router.push({ name: 'adminLogin' });
    });
  };

  // 角色判断方法
  const getUserRole = () => {
    const role = userStore.admin_user_role || localStorage.getItem('ADMIN_USER_ROLE') || '0';
    console.log('当前用户角色:', role);
    return role;
  };

  const isAdmin = () => {
    const result = getUserRole() === '0';
    console.log('是否管理员:', result);
    return result;
  };

  const isElderly = () => {
    const result = getUserRole() === '1';
    console.log('是否老人:', result);
    return result;
  };

  const isCaregiver = () => {
    const result = getUserRole() === '2';
    console.log('是否护工:', result);
    return result;
  };

  const isFamily = () => {
    const result = getUserRole() === '3';
    console.log('是否亲属:', result);
    return result;
  };

  const getRoleText = () => {
    const role = getUserRole();
    switch (role) {
      case '0': return '管理员';
      case '1': return '老人';
      case '2': return '护工';
      case '3': return '亲属';
      default: return '用户';
    }
  };
</script>
<style scoped lang="less">
  // header样式
  .header {
    display: flex;
    flex-direction: row;
    align-items: center; // 垂直居中
    padding-left: 24px;
    padding-right: 24px;

    .header-logo {
      width: 32px;
      height: 32px;
      cursor: pointer;
    }

    .header-title {
      margin-left: 16px;
      font-size: 20px;
      font-weight: bold;
      text-align: center;
    }

    .empty {
      flex: 1;
    }

    .header-quit {
      margin-left: 12px;
    }
  }

  #components-layout-demo-custom-trigger {
    height: 100%;
  }

  #components-layout-demo-custom-trigger .trigger {
    font-size: 18px;
    line-height: 64px;
    padding: 0 24px;
    cursor: pointer;
    transition: color 0.3s;
  }

  #components-layout-demo-custom-trigger .trigger:hover {
    color: #1890ff;
  }

  :deep(.ant-layout-content) {
    overflow-x: hidden;
  }

  :deep(.ant-layout-sider) {
    padding: 16px 0;
    background-color: #f0f2f5;
  }

  :deep(.ant-menu) {
    padding-top: 16px;
    height: 100%;
  }

  //:deep(.ant-layout-sider-trigger) {
  //  background-color: #fff;
  //  height: 0px; // 设置0 隐藏
  //}
</style>
