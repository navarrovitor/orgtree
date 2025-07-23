import EmployeeNode from './EmployeeNode';

function OrgChart({ employees, companyId }) {
  const topLevelEmployees = employees.filter(employee => !employee.manager);

  if (!employees || employees.length === 0) {
    return <p>This company has no employees yet.</p>;
  }

  return (
    <div className="org-tree">
      <h3 className="text-xl font-bold mb-4">Company's Hierarchy</h3>
      <ul className="pl-0">
        {topLevelEmployees.map(employee => (
          <EmployeeNode
            key={employee.id}
            employee={employee}
            allEmployees={employees}
            companyId={companyId}
          />
        ))}
      </ul>
    </div>
  );
}

export default OrgChart;