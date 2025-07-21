import { useQuery } from '@tanstack/react-query';
import { getCompanies } from '../../api/apiService';

function CompanyList() {
  const { data, isLoading, isError } = useQuery({
    queryKey: ['companies'], // A unique key for this data
    queryFn: getCompanies,  // The function to fetch the data
  });

  if (isLoading) {
    return <span>Loading...</span>;
  }

  if (isError) {
    return <span>Error fetching companies!</span>;
  }

  return (
    <div>
      <h2>Companies</h2>
      <ul>
        {data.data.map((company) => (
          <li key={company.id}>{company.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default CompanyList;