import axios from 'axios';

const API_URL = import.meta.env.VITE_API_BASE_URL || '';

const apiClient = axios.create({
  baseURL: `${API_URL}/api/v1`,
});

export const getCompanies = async () => {
  const response = await apiClient.get('/companies');
  return response.data;
};

export const getCompanyById = async (companyId) => {
  const response = await apiClient.get(`/companies/${companyId}`);
  return response.data;
};

export const createCompany = async (companyData) => {
  const response = await apiClient.post('/companies', companyData);
  return response.data;
};

export const createEmployee = async ({ companyId, employeeData }) => {
  const response = await apiClient.post(`/companies/${companyId}/employees`, employeeData);
  return response.data;
};

export const deleteEmployee = async (employeeId) => {
  await apiClient.delete(`/employees/${employeeId}`);
};

export const assignManager = async ({ employeeId, managerId }) => {
  const response = await apiClient.post(`/employees/${employeeId}/assign_manager`, {
    manager_id: managerId,
  });
  return response.data;
};