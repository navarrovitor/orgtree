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
    <li className="pl-6">
      <div className="bg-slate-800 p-4 rounded-lg my-2 max-w-sm">
        <div className="flex items-center justify-between">
          <div className="flex items-center">
            <img
              src={employee.picture}
              alt={employee.name}
              className="w-10 h-10 rounded-full mr-4 ring-2 ring-white"
            />
            <div>
              <p className="font-bold text-white">{employee.name}</p>
              <p className="text-sm text-slate-400">{employee.email}</p>
            </div>
          </div>
        </div>
        
        <div className="mt-3 flex items-center gap-2 text-white">
          <select
            value={selectedManagerId}
            onChange={(e) => setSelectedManagerId(e.target.value)}
            className="bg-slate-700 border border-slate-600 rounded px-2 py-1 text-sm"
          >
            <option value="">-- No Manager --</option>
            {potentialManagers.map((m) => (
              <option key={m.id} value={m.id}>
                {m.name}
              </option>
            ))}
          </select>
          
          <button onClick={handleAssignManager} disabled={assignManagerMutation.isPending} className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-1 px-3 text-sm rounded transition-colors disabled:bg-slate-500">
            {assignManagerMutation.isPending ? 'Saving...' : 'Assign'}
          </button>
          <button onClick={() => deleteEmployeeMutation.mutate(employee.id)} disabled={deleteEmployeeMutation.isPending} className="bg-red-600 hover:bg-red-700 text-white font-bold py-1 px-3 text-sm rounded transition-colors disabled:bg-slate-500">
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