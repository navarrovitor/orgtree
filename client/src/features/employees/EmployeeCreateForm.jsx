import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { createEmployee } from '../../api/apiService';

function EmployeeCreateForm({ companyId }) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');

  const queryClient = useQueryClient();

  const { mutate, isPending } = useMutation({
    mutationFn: createEmployee,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['company', companyId] });
      setName('');
      setEmail('');
    },
  });

  const handleSubmit = (event) => {
    event.preventDefault();
    const employeeData = { employee: { name, email, picture: `https://i.pravatar.cc/150?u=${email}` } };
    mutate({ companyId, employeeData });
  };

  return (
    <form onSubmit={handleSubmit} style={{ marginBottom: '2rem' }}>
      <h4>Add New Employee</h4>
      <input
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder="Employee name"
        required
      />
      <input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        placeholder="Employee email"
        required
      />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Adding...' : 'Add Employee'}
      </button>
    </form>
  );
}

export default EmployeeCreateForm;