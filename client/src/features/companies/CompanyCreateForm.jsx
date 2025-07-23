// src/features/companies/CompanyCreateForm.jsx
import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createCompany } from '../../api/apiService';

function CompanyCreateForm() {
  const [name, setName] = useState('');
  const queryClient = useQueryClient();
  const { mutate, isPending } = useMutation({
    mutationFn: createCompany,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['companies'] });
      setName('');
    },
  });

  const handleSubmit = (event) => {
    event.preventDefault();
    if (name.trim()) {
      mutate({ company: { name: name.trim() } });
    }
  };

  return (
    <div className="mb-8 p-6 bg-gray-200 dark:bg-gray-700 rounded-lg">
      <form onSubmit={handleSubmit}>
        <h3 className="text-xl font-semibold mb-4">
          Create a new company
        </h3>
        <div className="flex items-center gap-4">
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="New company name"
            disabled={isPending}
            className="flex-grow bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-md px-3 py-2 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-green-500"
          />
          <button
            type="submit"
            disabled={isPending}
            className="bg-green-500 hover:bg-green-600 dark:bg-green-600 dark:hover:bg-green-700 font-bold py-2 px-4 rounded-md transition-colors disabled:bg-slate-500 disabled:cursor-not-allowed"
          >
            {isPending ? 'Creating...' : 'Create Company'}
          </button>
        </div>
      </form>
    </div>
  );
}

export default CompanyCreateForm;