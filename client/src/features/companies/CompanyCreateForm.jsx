import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createCompany } from '../../api/apiService';

function CompanyCreateForm() {
  // 1. A simple state to hold the value of the input field
  const [name, setName] = useState('');

  // 2. Get access to the React Query client
  const queryClient = useQueryClient();

  // 3. Set up the mutation
  const { mutate, isPending } = useMutation({
    mutationFn: createCompany, // The function to call when we want to mutate data
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
    <form onSubmit={handleSubmit}>
      <h3>Create a New Company</h3>
      <input
        type="text"
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder="New company name"
        disabled={isPending}
      />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Creating...' : 'Create Company'}
      </button>
    </form>
  );
}

export default CompanyCreateForm;