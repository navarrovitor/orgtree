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
    <div className="mt-4">
      <ul className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {data.data.map((company) => (
          <li key={company.id}>
            <Link 
              to={`/companies/${company.id}`} 
              className="block p-4 bg-green-400 hover:bg-green-500 dark:bg-green-600 dark:hover:bg-green-700 rounded-lg text-center"
            >
              <span className="font-semibold text-lg">{company.name}</span>
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default CompanyList;