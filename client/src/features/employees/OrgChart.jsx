import { useMemo } from 'react';
import { buildHierarchy } from '../../utils/hierarchyUtils';
import EmployeeNode from './EmployeeNode';

function OrgChart({ employees }) {
  const hierarchy = useMemo(() => buildHierarchy(employees), [employees]);

  if (!hierarchy || hierarchy.length === 0) {
    return <p>This company has no employees yet.</p>;
  }

  return (
    <div>
      <h3>Organization Chart</h3>
      <ul style={{ paddingLeft: 0 }}>
        {hierarchy.map(employee => (
          <EmployeeNode key={employee.id} employee={employee} />
        ))}
      </ul>
    </div>
  );
}

export default OrgChart;