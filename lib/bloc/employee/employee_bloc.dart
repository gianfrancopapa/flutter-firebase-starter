import 'package:flutterBoilerplate/bloc/employee/employee_event.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_state.dart';
import 'package:flutterBoilerplate/bloc/forms/employee_form_bloc.dart';
import 'package:flutterBoilerplate/models/observer_interface.dart';
import 'package:flutterBoilerplate/models/subject_interface.dart';
import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/repository/employees_repository.dart';

class EmployeeBloc extends EmployeeFormBloc<EmployeeEvent, EmployeeState>
    implements ISubject {
  final _employeesRepository = EmployeesRepository();
  @override
  final observers = List<IObserver>();

  EmployeeBloc() : super(const NotDetermined());

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    switch (event.runtimeType) {
      case CreateEmployee:
        yield* _postNewEmployee();
        break;
      case FetchEmployee:
        yield* _getEmployee((event as FetchEmployee).id);
        break;
      case UpdateEmployee:
        yield* _updateEmployee((event as UpdateEmployee).id);
        break;
      case DeleteEmployee:
        yield* _deleteEmployee((event as DeleteEmployee).id);
        break;
      default:
        yield const Error(
          'Error: Invalid event [EmployeesBloc.mapEventToState].',
        );
    }
  }

  @override
  void notify() async {
    for (final observer in observers) {
      observer.update();
    }
  }

  @override
  void attach(IObserver observer) {
    observers.add(observer);
  }

  Stream<EmployeeState> _postNewEmployee() async* {
    try {
      yield const Loading();
      await _employeesRepository.addEmployee(
        Employee(
          firstName: firstNameController.value,
          lastName: lastNameController.value,
          email: emailController.value,
          phoneNumber: phoneController.value,
          age: ageController.value.truncate(),
          address: addressController.value,
          description: descriptionController.value,
          workingArea: Employee.determineWorkingArea(
            workingAreaController.value,
          ),
        ),
      );
      yield const EmployeeCreated();
      notify();
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<EmployeeState> _updateEmployee(String id) async* {
    try {
      yield const Loading();
      final employee = await _employeesRepository.getEmployee(id);
      employee.firstName = firstNameController.value;
      employee.lastName = lastNameController.value;
      employee.email = emailController.value;
      employee.phoneNumber = phoneController.value;
      employee.age = ageController.value.truncate();
      employee.address = addressController.value;
      employee.description = descriptionController.value;
      employee.workingArea = Employee.determineWorkingArea(
        workingAreaController.value,
      );
      await _employeesRepository.updateEmployee(employee);
      yield const EmployeeUpdated();
      notify();
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<EmployeeState> _getEmployee(String id) async* {
    try {
      yield const Loading();
      final employee = await _employeesRepository.getEmployee(id);
      firstNameController.sink.add(employee.firstName);
      lastNameController.sink.add(employee.lastName);
      emailController.sink.add(employee.email);
      addressController.sink.add(employee.address);
      ageController.sink.add(employee.age.toDouble());
      phoneController.sink.add(employee.phoneNumber);
      descriptionController.sink.add(employee.description);
      workingAreaController.sink.add(employee.getWorkingArea());
      yield SingleEmployee(employee);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<EmployeeState> _deleteEmployee(String id) async* {
    try {
      yield const Loading();
      await _employeesRepository.deleteEmployee(id);
      yield const EmployeeDeleted();
      notify();
    } catch (err) {
      yield Error(err.toString());
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
