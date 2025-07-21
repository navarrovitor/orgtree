import { createBrowserRouter, RouterProvider } from "react-router-dom";
import HomePage from "./pages/HomePage";
import CompanyDetailPage from "./pages/CompanyDetailPage";

const router = createBrowserRouter([
  {
    path: "/",
    element: <HomePage />, 
  },
  {
    path: "/companies/:id",
    element: <CompanyDetailPage />, 
  },
]);

function App() {
  return (
    <div style={{ padding: '2rem' }}>
      <RouterProvider router={router} />
    </div>
  );
}

export default App;