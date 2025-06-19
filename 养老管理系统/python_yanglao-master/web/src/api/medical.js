import { get, post } from '/@/utils/http/axios';

const BASE_URL = '/myapp/admin/medical';

export const listApi = (params) => get({ url: BASE_URL + '/list', params });
export const createApi = (data) => post({ url: BASE_URL + '/create', data });
export const updateApi = (params, data) => post({ url: BASE_URL + '/update', params, data });
export const deleteApi = (params) => post({ url: BASE_URL + '/delete', params });
export const detailApi = (params) => get({ url: BASE_URL + '/detail', params });
