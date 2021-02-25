abstract class EmployeeEvent {
  const EmployeeEvent();
}

class CreateEmployee extends EmployeeEvent {
  const CreateEmployee();
}

class UpdateEmployee extends EmployeeEvent {
  final String id;
  const UpdateEmployee(this.id);
}

class FetchEmployee extends EmployeeEvent {
  final String id;
  const FetchEmployee(this.id);
}

class DeleteEmployee extends EmployeeEvent {
  final String id;
  const DeleteEmployee(this.id);
}
