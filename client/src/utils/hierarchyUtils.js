export const buildHierarchy = (employees) => {
  if (!employees || employees.length === 0) return [];

  const employeeMap = {};
  employees.forEach(employee => {
    employeeMap[employee.id] = { ...employee, subordinates: [] };
  });

  const hierarchy = [];
  employees.forEach(employee => {
    if (employee.manager) {
      const manager = employeeMap[employee.manager.id];
      if (manager) {
        manager.subordinates.push(employeeMap[employee.id]);
      }
    } else {
      hierarchy.push(employeeMap[employee.id]);
    }
  });

  return hierarchy;
};