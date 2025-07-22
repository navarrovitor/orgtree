import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { assignManager, deleteEmployee } from '../../api/apiService';

function EmployeeNode({ employee, allEmployees, companyId }) {
  const [selectedManagerId, setSelectedManagerId] = useState(employee.manager?.id || '');
  const queryClient = useQueryClient();

  const assignManagerMutation = useMutation({
    mutationFn: assignManager,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['company', companyId] });
    },
    onError: (error) => {
      alert(`Error assigning manager: ${error.response?.data?.errors?.join(', ') || error.message}`);
      setSelectedManagerId(employee.manager?.id || '');
    },
  });

  const deleteEmployeeMutation = useMutation({
    mutationFn: deleteEmployee,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['company', companyId] });
    },
  });

  const handleAssignManager = () => {
    if (selectedManagerId === (employee.manager?.id || '')) return; 

    assignManagerMutation.mutate({
      employeeId: employee.id,
      managerId: selectedManagerId,
    });
  };

  const potentialManagers = allEmployees.filter((e) => e.id !== employee.id);
  const hasSubordinates = employee.subordinates && employee.subordinates.length > 0;

  return (
    <li style={{ listStyleType: 'none', marginLeft: '20px' }}>
      <div style={{ padding: '5px', borderLeft: '1px solid #ccc', marginTop: '5px' }}>
        <div>
          <img
            src={employee.picture}
            alt={employee.name}
            style={{ width: '30px', height: '30px', borderRadius: '50%', marginRight: '8px', verticalAlign: 'middle' }}
          />
          <strong>{employee.name}</strong> ({employee.email})
        </div>
        <div style={{ display: 'inline-block', marginLeft: '38px', marginTop: '5px' }}>
          <select
            value={selectedManagerId}
            onChange={(e) => setSelectedManagerId(e.target.value)}
          >
            <option value="">-- No Manager --</option>
            {potentialManagers.map((m) => (
              <option key={m.id} value={m.id}>
                {m.name}
              </option>
            ))}
          </select>
          <button onClick={handleAssignManager} disabled={assignManagerMutation.isPending} style={{ marginLeft: '0.5rem' }}>
            {assignManagerMutation.isPending ? 'Saving...' : 'Assign'}
          </button>
          <button
            onClick={() => deleteEmployeeMutation.mutate(employee.id)}
            style={{ marginLeft: '0.5rem', color: 'red' }}
            disabled={deleteEmployeeMutation.isPending}
          >
            {deleteEmployeeMutation.isPending ? 'Deleting...' : 'Delete'}
          </button>
        </div>
      </div>

      {hasSubordinates && (
        <ul>
          {employee.subordinates.map((basicSubordinate) => {
            const fullSubordinate = allEmployees.find(
              (e) => e.id === basicSubordinate.id
            );

            return fullSubordinate ? (
              <EmployeeNode
                key={fullSubordinate.id}
                employee={fullSubordinate}
                allEmployees={allEmployees}
                companyId={companyId}
              />
            ) : null;
          })}
        </ul>
      )}
    </li>
  );
}

export default EmployeeNode;