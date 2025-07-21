import CompanyList from '../features/companies/CompanyList';
import CompanyCreateForm from '../features/companies/CompanyCreateForm';

function HomePage() {
  return (
    <div>
      <CompanyCreateForm />
      <hr />

      <h2>Companies</h2>
      <p>Select a company to view its organization chart.</p>
      <CompanyList />
    </div>
  );
}

export default HomePage;