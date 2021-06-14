import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';

class MockEmployeesRepository extends Mock
    implements Repository<EmployeeEntity> {}
