import CompanyList from '../features/companies/CompanyList';
import CompanyCreateForm from '../features/companies/CompanyCreateForm';

function HomePage() {
  return (
    <div>
      <CompanyCreateForm />
      <div>
        <h2 className="text-3xl font-bold">
          Companies
        </h2>
        <p className="mt-2 text-lg">
          Select a company to view its hierarchy.
        </p>
      </div>
      <CompanyList />
    </div>
  );
}

export default HomePage;