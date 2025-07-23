import { Outlet } from 'react-router-dom';
import Header from './Header';
import Footer from './Footer';

function Layout() {
  return (
    <div>
      <Header />
      <main className="container mx-auto !p-4 !md:p-8 !pt-20 !pb-16">
        <Outlet />
      </main>
      <Footer />
    </div>
  );
}

export default Layout;