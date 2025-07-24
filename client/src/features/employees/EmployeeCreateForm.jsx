// src/features/employees/EmployeeCreateForm.jsx
import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createEmployee } from '../../api/apiService';

function EmployeeCreateForm({ companyId }) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [apiError, setApiError] = useState(null);

  const queryClient = useQueryClient();

  const { mutate, isPending } = useMutation({
    mutationFn: createEmployee,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['company', companyId] });
      setName('');
      setEmail('');
      setApiError(null);
    },
    onError: (error) => {
      setApiError(error.response.data);
    },
  });

  const handleSubmit = (event) => {
    event.preventDefault();
    setApiError(null);
    const employeeData = { employee: { name, email, picture: `https://i.pravatar.cc/150?u=${email}` } };
    mutate({ companyId, employeeData });
  };

  return (
    <div className="mb-8 p-6 bg-gray-200 dark:bg-gray-700 rounded-lg">
      <form onSubmit={handleSubmit}>
        <h4 className="text-xl font-semibold mb-4">
          Add a new employee to this company
        </h4>
        <div className="flex flex-col lg:flex-row items-center gap-4">
          <input
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Employee name"
            required
            className="w-full lg:w-auto flex-grow bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-md px-3 py-2 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Employee email"
            required
            className="w-full lg:w-auto flex-grow bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-md px-3 py-2 text-slate-900 dark:text-white placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
          <button
            type="submit"
            disabled={isPending}
            className="w-full lg:w-auto bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-md transition-colors disabled:bg-slate-500 disabled:cursor-not-allowed"
          >
            {isPending ? 'Adding...' : 'Add Employee'}
          </button>
        </div>
        {apiError && apiError.email && (
          <p className="text-red-500 mt-2">
            Email Error: {apiError.email.join(', ')}
          </p>
        )}
      </form>
    </div>
  );
}

export default EmployeeCreateForm;