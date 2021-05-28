import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import '../../widget/employees/mocks/employees_widget_mocks.dart';

void main() {
  EmployeesBloc employeesBloc;
  MockEmployeesRepository employeesRepository;

  final employeeEntity = EmployeeEntity(
    id: 'testId',
    firstName: 'testFirstName',
    lastName: 'testLastName',
    address: 'testAddress',
    age: 20,
    avatarAsset: 'testAsset',
    description: 'testDescription',
    email: 'test@somniosoftware.com',
    phoneNumber: '098123456',
  );
  final employee = Employee.fromEntity(employeeEntity);
  const errMessage = 'Error: An error occurs while fetching employees.';

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

      blocTest(
        'Fetching employees, empty result',
        build: () => EmployeesBloc(employeesRepository),
        act: (bloc) {
          when(employeesRepository.getAll()).thenAnswer(
            (_) => Future.value([]),
          );
          bloc.add(const EmployeesLoaded());
        },
        expect: () =>
            [const EmployeesLoadInProgress(), const EmployeesLoadEmpty()],
      );

      blocTest(
        'Fetching employees succeeds',
        build: () => EmployeesBloc(employeesRepository),
        act: (bloc) {
          when(employeesRepository.getAll()).thenAnswer(
            (_) => Future.value([employeeEntity]),
          );
          bloc.add(const EmployeesLoaded());
        },
        expect: () => [
          const EmployeesLoadInProgress(),
          EmployeesLoadSuccess([employee]),
        ],
      );

      blocTest(
        'Fetching employees fails',
        build: () => EmployeesBloc(employeesRepository),
        act: (bloc) {
          when(employeesRepository.getAll()).thenAnswer(
            (_) => throw Exception(errMessage),
          );
          bloc.add(const EmployeesLoaded());
        },
        expect: () => [
          const EmployeesLoadInProgress(),
          const EmployeesLoadFailure(errMessage),
        ],
      );
    },
  );
}
