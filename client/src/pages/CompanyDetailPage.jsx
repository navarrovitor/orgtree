import { useParams } from 'react-router-dom';
import { useQuery } from '@tanstack/react-query';
import { getCompanyById } from '../api/apiService';
import EmployeeCreateForm from '../features/employees/EmployeeCreateForm';
import OrgChart from '../features/employees/OrgChart';

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
      <h2 className="text-3xl font-bold text-center">
        {data.name}
      </h2>
      <EmployeeCreateForm companyId={id} />
      <OrgChart employees={data.employees} companyId={id} />
    </div>
  );
}

export default CompanyDetailPage;