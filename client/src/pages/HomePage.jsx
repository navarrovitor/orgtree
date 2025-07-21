import CompanyList from '../features/companies/CompanyList';

function HomePage() {
  return (
    <div>
      <h2>Companies</h2>
      <p>Select a company to view its organization chart.</p>
      <hr />
      <CompanyList />
    </div>
  );
}

export default HomePage;