import { useQuery } from '@tanstack/react-query';
import { getCompanies } from '../../api/apiService';
import { Link } from 'react-router-dom';

function CompanyList() {
  const { data, isLoading, isError } = useQuery({
    queryKey: ['companies'],
    queryFn: getCompanies,
  });

  if (isLoading) {
    return <span>Loading...</span>;
  }

  if (isError) {
    return <span>Error fetching companies!</span>;
  }

  return (
    <div>
      <ul>
        {data.data.map((company) => (
          <li key={company.id}>
            <Link to={`/companies/${company.id}`}>{company.name}</Link>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default CompanyList;