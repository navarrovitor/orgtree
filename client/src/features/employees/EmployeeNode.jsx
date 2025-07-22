function EmployeeNode({ employee }) {
  const hasSubordinates = employee.subordinates && employee.subordinates.length > 0;

  return (
    <li style={{ listStyleType: 'none', marginLeft: '20px' }}>
      <div style={{ padding: '5px' }}>
        <img 
          src={employee.picture} 
          alt={employee.name} 
          style={{ width: '30px', height: '30px', borderRadius: '50%', marginRight: '8px', verticalAlign: 'middle' }} 
        />
        <strong>{employee.name}</strong> ({employee.email})
      </div>

      {hasSubordinates && (
        <ul>
          {employee.subordinates.map(subordinate => (
            <EmployeeNode key={subordinate.id} employee={subordinate} />
          ))}
        </ul>
      )}
    </li>
  );
}

export default EmployeeNode;
