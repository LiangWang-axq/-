import { request } from '/@/utils/request';

const BASE_URL = '/myapp/admin/health';

// 获取健康记录列表
export function listApi(params) {
  return request({
    url: BASE_URL + '/list',
    method: 'get',
    params: params,
  });
}

// 创建健康记录
export function createApi(data) {
  return request({
    url: BASE_URL + '/create',
    method: 'post',
    data: data,
  });
}

// 更新健康记录
export function updateApi(params, data) {
  return request({
    url: BASE_URL + '/update',
    method: 'post',
    params: params,
    data: data,
  });
}

// 删除健康记录
export function deleteApi(params) {
  return request({
    url: BASE_URL + '/delete',
    method: 'post',
    params: params,
  });
}

// 获取健康记录详情
export function detailApi(params) {
  return request({
    url: BASE_URL + '/detail',
    method: 'get',
    params: params,
  });
}

// 获取健康统计数据
export function statsApi(params) {
  return request({
    url: BASE_URL + '/stats',
    method: 'get',
    params: params,
  });
}

// 导出健康记录
export function exportApi(params) {
  return request({
    url: BASE_URL + '/export',
    method: 'get',
    params: params,
    responseType: 'blob',
  });
}
