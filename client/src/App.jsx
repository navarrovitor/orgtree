import { createBrowserRouter, RouterProvider } from "react-router-dom";
import HomePage from "./pages/HomePage";
import CompanyDetailPage from "./pages/CompanyDetailPage";
import Layout from "./components/layout/Layout";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Layout />,
    children: [
      {
        index: true,
        element: <HomePage />,
      },
      {
        path: "/companies/:id",
        element: <CompanyDetailPage />,
      },
    ],
  },
]);

function App() {
  return (
    <div className="bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100 transition-colors duration-300 min-h-screen font-sans">
      <RouterProvider router={router} />
    </div>
  );
}

export default App;