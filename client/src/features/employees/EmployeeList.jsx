import { useMutation, useQueryClient } from '@tanstack/react-query';
import { deleteEmployee } from '../../api/apiService';

function EmployeeList({ employees, companyId }) {
  const queryClient = useQueryClient();

  const { mutate } = useMutation({
    mutationFn: deleteEmployee,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['company', companyId] });
    },
  });

  if (!employees || employees.length === 0) {
    return <p>This company has no employees yet.</p>;
  }

  return (
    <div>
      <h3>Organization Chart</h3>
      <ul>
        {employees.map((employee) => (
          <li key={employee.id}>
            <img 
              src={employee.picture} 
              alt={employee.name} 
              style={{ width: '40px', height: '40px', borderRadius: '50%', marginRight: '10px', verticalAlign: 'middle' }} 
            />
            <strong>{employee.name}</strong> ({employee.email})
            <button
              onClick={() => mutate(employee.id)}
              style={{ marginLeft: '1rem' }}
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default EmployeeList;