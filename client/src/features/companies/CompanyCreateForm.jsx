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