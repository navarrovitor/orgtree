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
    <form onSubmit={handleSubmit} style={{ marginBottom: '2rem' }}>
      <h4>Add New Employee</h4>
      <input
        value={name}
        onChange={(e) => {
            setName(e.target.value);
            setApiError(null);
        }}
        placeholder="Employee name"
        required
      />
      <input
        type="email"
        value={email}
        onChange={(e) => {
            setEmail(e.target.value);
            setApiError(null);
        }}
        placeholder="Employee email"
        required
      />
      <button type="submit" disabled={isPending}>
        {isPending ? 'Adding...' : 'Add Employee'}
      </button>

      {apiError && apiError.email && (
        <p style={{ color: 'red' }}>
          Email Error: {apiError.email.join(', ')}
        </p>
      )}
    </form>
  );
}

export default EmployeeCreateForm;