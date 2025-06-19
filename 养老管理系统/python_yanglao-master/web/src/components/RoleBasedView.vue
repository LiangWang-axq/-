<template>
  <div class="role-based-view">
    <!-- 管理员视图 -->
    <component 
      v-if="isAdmin()" 
      :is="adminComponent" 
      :key="componentKey"
    />
    
    <!-- 老人视图 -->
    <component 
      v-else-if="isElderly()" 
      :is="elderlyComponent" 
      :key="componentKey"
    />
    
    <!-- 护工视图 -->
    <component 
      v-else-if="isCaregiver()" 
      :is="caregiverComponent" 
      :key="componentKey"
    />
    
    <!-- 亲属视图 -->
    <component 
      v-else-if="isFamily()" 
      :is="familyComponent" 
      :key="componentKey"
    />
    
    <!-- 默认视图 -->
    <div v-else class="no-permission">
      <a-result
        status="403"
        title="403"
        sub-title="抱歉，您没有权限访问此页面。"
      >
        <template #extra>
          <a-button type="primary" @click="goHome">返回首页</a-button>
        </template>
      </a-result>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useUserStore } from '/@/store';

interface Props {
  adminComponent?: string;
  elderlyComponent?: string;
  caregiverComponent?: string;
  familyComponent?: string;
  moduleType?: string;
}

const props = withDefaults(defineProps<Props>(), {
  adminComponent: '',
  elderlyComponent: '',
  caregiverComponent: '',
  familyComponent: '',
  moduleType: 'default'
});

const router = useRouter();
const userStore = useUserStore();

const componentKey = computed(() => `${props.moduleType}-${getUserRole()}`);

const getUserRole = () => {
  return userStore.admin_user_role || localStorage.getItem('ADMIN_USER_ROLE') || '0';
};

const isAdmin = () => getUserRole() === '0';
const isElderly = () => getUserRole() === '1';
const isCaregiver = () => getUserRole() === '2';
const isFamily = () => getUserRole() === '3';

const goHome = () => {
  router.push('/');
};
</script>

<style lang="less" scoped>
.role-based-view {
  width: 100%;
  height: 100%;
}

.no-permission {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 400px;
}
</style>
