import 'package:firebasestarter/screens/team/team_screen.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import '../common/test_bench_test.dart';
import 'mocks/employees_widget_mocks.dart';

List<EmployeeEntity> employeesList;
EmployeeEntity testEmployee = EmployeeEntity.fromJson({
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

void main() {
  testWidgets('Employees load correctly', (WidgetTester tester) async {
    final mockEmployeesRepository = MockEmployeesRepository();
    employeesList = [testEmployee];

    when(mockEmployeesRepository.getAll())
        .thenAnswer((_) async => employeesList);

    await tester.pumpWidget(TestBench(mockEmployeesRepository, TeamScreen()));

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('testName testLastName'), findsOneWidget);
  });

  testWidgets('Employees load empty', (WidgetTester tester) async {
    final mockEmployeesRepository = MockEmployeesRepository();
    employeesList = [];

    when(mockEmployeesRepository.getAll())
        .thenAnswer((_) async => employeesList);

    await tester.pumpWidget(TestBench(mockEmployeesRepository, TeamScreen()));

    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(EmployeesList), findsNothing);
    expect(find.text('No employees found'), findsOneWidget);
  });
}
