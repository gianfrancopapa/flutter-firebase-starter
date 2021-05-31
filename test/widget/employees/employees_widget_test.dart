import 'package:firebasestarter/screens/team/team_screen.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import '../test_bench.dart';
import 'mocks/employees_widget_mocks.dart';

void main() {
  EmployeesRepository employeesRepository;
  List<EmployeeEntity> employeesList;
  EmployeeEntity testEmployee;

  setUp(() {
    employeesRepository = MockEmployeesRepository();
    testEmployee = EmployeeEntity.fromJson({
      'firstName': 'testName',
      'lastName': 'testLastName',
      'email': 'testEmail',
      'avatarAsset': 'testAvatar',
      'role': 'user',
      'age': 20,
      'address': 'testAddress',
      'phoneNumber': '098123456',
      'description': 'testDescription',
    });
  });

  testWidgets('Employees load correctly', (WidgetTester tester) async {
    employeesList = [testEmployee];

    when(employeesRepository.getAll()).thenAnswer((_) async => employeesList);

    await tester.pumpApp(TeamScreen(),
        employeesRepository: employeesRepository);

    expect(find.text('testName testLastName'), findsOneWidget);
  });

  testWidgets('Employees load empty', (WidgetTester tester) async {
    employeesList = [];

    when(employeesRepository.getAll()).thenAnswer((_) async => employeesList);

    await tester.pumpApp(TeamScreen(),
        employeesRepository: employeesRepository);

    expect(find.byType(EmployeesList), findsNothing);
    expect(find.text('No employees found'), findsOneWidget);
  });
}
