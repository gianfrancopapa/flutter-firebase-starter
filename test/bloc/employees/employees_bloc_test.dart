import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import '../../widget/test_bench_mocks.dart';

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
        expect(employeesBloc.state.status, EmployeesStatus.initial);
      });

      blocTest(
        'Fetching employees, empty result',
        build: () => EmployeesBloc(employeesRepository),
        act: (bloc) {
          when(employeesRepository.getAll()).thenAnswer((_) async => []);
          bloc.add(const EmployeesLoaded());
        },
        expect: () => [
          const EmployeesState(status: EmployeesStatus.loadInProgress),
          const EmployeesState(status: EmployeesStatus.loadEmpty),
        ],
      );

      blocTest(
        'Fetching employees succeeds',
        build: () => EmployeesBloc(employeesRepository),
        act: (bloc) {
          when(employeesRepository.getAll()).thenAnswer(
            (_) async => [employeeEntity],
          );
          bloc.add(const EmployeesLoaded());
        },
        expect: () => [
          const EmployeesState(status: EmployeesStatus.loadInProgress),
          EmployeesState(
            status: EmployeesStatus.loadSuccess,
            employees: [employee],
          ),
        ],
      );

      blocTest(
        'Fetching employees fails',
        build: () => EmployeesBloc(employeesRepository),
        act: (bloc) {
          when(employeesRepository.getAll()).thenThrow(Exception(errMessage));
          bloc.add(const EmployeesLoaded());
        },
        expect: () => [
          const EmployeesState(status: EmployeesStatus.loadInProgress),
          const EmployeesState(
            status: EmployeesStatus.loadFailure,
            errorMessage: errMessage,
          ),
        ],
      );
    },
  );
}
