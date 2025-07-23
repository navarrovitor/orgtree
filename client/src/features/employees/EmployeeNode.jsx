import { useState } from 'react';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { assignManager, deleteEmployee } from '../../api/apiService';

function EmployeeNode({ employee, allEmployees, companyId }) {
  const [selectedManagerId, setSelectedManagerId] = useState(employee.manager?.id || '');
  const [isExpanded, setIsExpanded] = useState(false);
  
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
    <li>
      <div className="bg-gray-200 dark:bg-gray-700 p-4 rounded-lg my-2 shadow-md/30 dark:shadow-green-600 max-w-sm">
        <div className="flex items-center justify-between">
          <div className="flex items-center">
            {hasSubordinates && (
              <button
                onClick={() => setIsExpanded(!isExpanded)}
                className="mr-2 text-lg font-mono"
              >
                {isExpanded ? '[-]' : '[+]'}
              </button>
            )}
            <img
              src={employee.picture}
              alt={employee.name}
              className="w-8 h-8 rounded-full mr-2"
            />
            <div>
              <p className="font-bold text-sm">{employee.name}</p>
              <p className="text-xs text-slate-600 dark:text-slate-400">{employee.email}</p>
            </div>
          </div>
        </div>
        
        <div className="mt-2 flex flex-wrap items-center gap-2">
          <select
            value={selectedManagerId}
            onChange={(e) => setSelectedManagerId(e.target.value)}
            className="bg-white dark:bg-slate-700 border border-slate-300 dark:border-slate-600 rounded-md px-2 py-1 text-sm text-slate-900 dark:text-white focus:outline-none focus:ring-2 focus:ring-green-600"
          >
            <option value="">-- No Manager --</option>
            {potentialManagers.map((m) => (
              <option key={m.id} value={m.id}>
                {m.name}
              </option>
            ))}
          </select>
          <button
            onClick={handleAssignManager}
            disabled={assignManagerMutation.isPending}
            className="bg-green-500 hover:bg-green-600 dark:bg-green-600 dark:hover:bg-green-700 text-white font-bold py-1 px-3 text-sm rounded-md transition-colors"
          >
            {assignManagerMutation.isPending ? 'Saving...' : 'Assign'}
          </button>
          <button
            onClick={() => deleteEmployeeMutation.mutate(employee.id)}
            disabled={deleteEmployeeMutation.isPending}
            className="bg-red-600 hover:bg-red-700 text-white font-bold py-1 px-3 text-sm rounded-md transition-colors"
          >
            {deleteEmployeeMutation.isPending ? 'Deleting...' : 'Delete'}
          </button>
        </div>
      </div>

      {hasSubordinates && isExpanded && (
        <ul>
          {employee.subordinates.map((basicSubordinate) => {
            const fullSubordinate = allEmployees.find(e => e.id === basicSubordinate.id);
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