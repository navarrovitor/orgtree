function EmployeeList({ employees }) {
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
          </li>
        ))}
      </ul>
    </div>
  );
}

export default EmployeeList;