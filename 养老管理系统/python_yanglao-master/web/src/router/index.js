import { createRouter, createWebHistory } from 'vue-router';
import root from './root';

import { ADMIN_USER_TOKEN, USER_TOKEN } from '/@/store/constants';

// 路由权限白名单
const allowList = ['adminLogin', 'login', 'register', 'portal', 'search', 'detail', '403', '404'];
// 前台登录地址
const loginRoutePath = '/index/login';
// 后台登录地址
const adminLoginRoutePath = '/adminLogin';

const router = createRouter({
  history: createWebHistory(),
  routes: root,
});

router.beforeEach(async (to, from, next) => {
  console.log('路由跳转:', to.path, '来自:', from.path);

  // 简化的路由权限控制
  const hasToken = localStorage.getItem(ADMIN_USER_TOKEN);

  // 如果是登录页面
  if (to.path === adminLoginRoutePath) {
    if (hasToken) {
      // 已登录，跳转到管理页面
      next({ path: '/admin' });
    } else {
      // 未登录，允许访问登录页
      next();
    }
    return;
  }

  // 如果是需要登录的页面
  if (to.path.startsWith('/admin') || to.path === '/') {
    if (hasToken) {
      // 已登录，允许访问
      next();
    } else {
      // 未登录，跳转到登录页
      next({ path: adminLoginRoutePath });
    }
    return;
  }

  // 其他页面直接放行
  next();
});

// 检查路由权限的函数
function checkRoutePermission(path, userRole) {
  // 管理员可以访问所有页面
  if (userRole === '0') return true;

  // 老人角色权限
  if (userRole === '1') {
    const elderlyRoutes = ['/admin/my-health', '/admin/my-activities', '/admin/my-profile'];
    return elderlyRoutes.some(route => path.startsWith(route)) || path === '/admin';
  }

  // 护工角色权限
  if (userRole === '2') {
    const caregiverRoutes = ['/admin/my-elderly', '/admin/elderly-health', '/admin/elderly-activities', '/admin/elderly-medical'];
    return caregiverRoutes.some(route => path.startsWith(route)) || path === '/admin';
  }

  // 亲属角色权限
  if (userRole === '3') {
    const familyRoutes = ['/admin/family-monitoring', '/admin/family-elderly', '/admin/family-health', '/admin/family-activities'];
    return familyRoutes.some(route => path.startsWith(route)) || path === '/admin';
  }

  return false;
}

router.afterEach((_to) => {
  // 回到顶部
  let html = document.getElementById('html');
  if (html) {
    html.scrollTo(0, 0);
  }
});

export default router;
