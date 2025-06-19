// 路由表
const constantRouterMap = [

  {
    path: '/',
    redirect: '/adminLogin',
  },
  {
    path: '/adminLogin',
    name: 'adminLogin',
    component: () => import('/@/views/admin-login.vue'),
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('/@/views/register.vue'),
  },

  // 老人角色页面
  {
    path: '/my-health',
    name: 'my-health',
    component: () => import('/@/views/elderly/my-health.vue'),
  },
  {
    path: '/my-activities',
    name: 'my-activities',
    component: () => import('/@/views/elderly/my-activities.vue'),
  },
  // 护工角色页面
  {
    path: '/my-elderly',
    name: 'my-elderly',
    component: () => import('/@/views/caregiver/elderly-management.vue'),
  },
  {
    path: '/elderly-health',
    name: 'elderly-health',
    component: () => import('/@/views/caregiver/health-records.vue'),
  },
  {
    path: '/elderly-activities',
    name: 'elderly-activities',
    component: () => import('/@/views/caregiver/activity-management.vue'),
  },
  {
    path: '/elderly-medical',
    name: 'elderly-medical',
    component: () => import('/@/views/caregiver/medical-records.vue'),
  },
  // 亲属角色页面 - 删除重复的路由定义，在admin children中已定义
  // 通用页面 - 删除重复的路由定义

  {
    path: '/admin',
    name: 'admin',
    component: () => import('/@/views/main.vue'),
    children: [
      { path: 'overview', name: 'overview', component: () => import('/@/views/overview.vue') },
      { path: 'thing', name: 'thing', component: () => import('/@/views/thing.vue') },
      { path: 'worker', name: 'worker', component: () => import('/@/views/worker.vue') },
      { path: 'family', name: 'family', component: () => import('/@/views/family.vue') },
      { path: 'medical', name: 'medical', component: () => import('/@/views/medical.vue') },
      { path: 'user', name: 'user', component: () => import('/@/views/user.vue') },
      { path: 'user-modern', name: 'user-modern', component: () => import('/@/views/user-modern.vue') },
      { path: 'classification', name: 'classification', component: () => import('/@/views/classification.vue') },
      { path: 'tag', name: 'tag', component: () => import('/@/views/tag.vue') },
      { path: 'activity-modern', name: 'activity-modern', component: () => import('/@/views/activity-modern.vue') },

      // 老人角色页面
      { path: 'my-health', name: 'my-health', component: () => import('/@/views/elderly/my-health.vue') },
      { path: 'health-profile', name: 'health-profile', component: () => import('/@/views/elderly/health-profile.vue') },
      { path: 'my-activities', name: 'my-activities', component: () => import('/@/views/elderly/my-activities.vue') },
      { path: 'my-profile', name: 'my-profile', component: () => import('/@/views/common/profile.vue') },

      // 护工角色页面
      { path: 'my-elderly', name: 'my-elderly', component: () => import('/@/views/caregiver/elderly-management.vue') },
      { path: 'elderly-health', name: 'elderly-health', component: () => import('/@/views/caregiver/health-records.vue') },
      { path: 'elderly-activities', name: 'elderly-activities', component: () => import('/@/views/caregiver/activity-management.vue') },
      { path: 'elderly-medical', name: 'elderly-medical', component: () => import('/@/views/caregiver/medical-records.vue') },

      // 亲属角色页面
      { path: 'family-monitoring', name: 'family-monitoring', component: () => import('/@/views/family/monitoring-dashboard.vue') },
      { path: 'care-center', name: 'care-center', component: () => import('/@/views/family/care-center.vue') },
      { path: 'family-elderly', name: 'family-elderly', component: () => import('/@/views/family/elderly-info.vue') },
      { path: 'family-health', name: 'family-health', component: () => import('/@/views/family/health-status.vue') },
      { path: 'family-activities', name: 'family-activities', component: () => import('/@/views/family/activity-records.vue') },
      { path: 'test', name: 'test', component: () => import('/@/views/test-page.vue') },
      { path: 'loginLog', name: 'loginLog', component: () => import('/@/views/login-log.vue') },
      { path: 'opLog', name: 'opLog', component: () => import('/@/views/op-log.vue') },
      { path: 'errorLog', name: 'errorLog', component: () => import('/@/views/error-log.vue') },
      { path: 'sysInfo', name: 'sysInfo', component: () => import('/@/views/sys-info.vue') },
    ]
  },
];

export default constantRouterMap;
