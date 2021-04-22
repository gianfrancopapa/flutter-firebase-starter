import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';

class MockEmployeesRepository extends Mock
    implements Repository<EmployeeEntity> {}

void main() {
  EmployeesBloc employeesBloc;
  MockEmployeesRepository employeesRepository;

  setUp(() {
    employeesRepository = MockEmployeesRepository();
    employeesBloc = EmployeesBloc(employeesRepository);
  });

  group(
    'Employees BLoC',
    () {
      test('Initial state BLoC', () {
        expect(employeesBloc.state, const EmployeesInitial());
      });

      test('Fetching employees empty', () {
        final expectedResponse = [
          const EmployeesLoadInProgress(),
          const EmployeesLoadEmpty()
        ];

        when(employeesRepository.getAll()).thenAnswer(
          (_) => Future.value([]),
        );

        expectLater(
          employeesBloc.stream,
          emitsInOrder(expectedResponse),
        );

        employeesBloc.add(const EmployeesLoaded());
      });

      test('Fetching employees succeeds', () {
        final employeeEntity = EmployeeEntity(
          id: 'asdlkjz12',
          firstName: 'Test',
          lastName: 'Test',
          address: 'Address',
          age: 23,
          avatarAsset: 'asset',
          description: 'Desc',
          email: 'test@somniosoftware.com',
          phoneNumber: '99999999',
        );
        final employee = Employee.fromEntity(employeeEntity);
        final expectedResponse = [
          const EmployeesLoadInProgress(),
          EmployeesLoadSuccess([employee]),
        ];

        when(employeesRepository.getAll()).thenAnswer(
          (_) => Future.value([employeeEntity]),
        );

        expectLater(
          employeesBloc.stream,
          emitsInOrder(expectedResponse),
        );

        employeesBloc.add(const EmployeesLoaded());
      });

      test('Fetching employees fails', () {
        const errMessage = 'Error: An error occurs while fetching employees.';
        final expectedResponse = [
          const EmployeesLoadInProgress(),
          const EmployeesLoadFailure(errMessage),
        ];

        when(employeesRepository.getAll()).thenAnswer(
          (_) => throw Exception(errMessage),
        );

        expectLater(
          employeesBloc.stream,
          emitsInOrder(expectedResponse),
        );

        employeesBloc.add(const EmployeesLoaded());
      });
    },
  );
}
