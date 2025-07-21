import { useParams } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { getCompanyById } from '../api/apiService';
import EmployeeList from '../features/employees/EmployeeList';
import EmployeeCreateForm from '../features/employees/EmployeeCreateForm';

function CompanyDetailPage() {
  const { id } = useParams();

  const { data, isLoading, isError, error } = useQuery({
    queryKey: ['company', id],
    queryFn: () => getCompanyById(id),
  });

  if (isLoading) {
    return <span>Loading company details...</span>;
  }

  if (isError) {
    return <span>Error: {error.message}</span>;
  }

  return (
    <div>
      <h2>{data.name}</h2>
      <hr />
      <EmployeeCreateForm companyId={id} />
      <EmployeeList employees={data.employees} companyId={id} />
    </div>
  );
}

export default CompanyDetailPage;