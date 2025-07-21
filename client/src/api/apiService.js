import axios from 'axios';

const apiClient = axios.create({
  baseURL: '/api/v1',
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