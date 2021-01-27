import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_bloc.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_event.dart';
import 'package:flutterBoilerplate/utils/chip.dart' as Model;
import 'package:flutterBoilerplate/widgets/employee_list.dart';
import 'package:flutterBoilerplate/widgets/common/enabled_chips_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesListWithFilter extends StatefulWidget {
  final bool isAdmin;
  const EmployeesListWithFilter(this.isAdmin);

  @override
  _EmployeesListWithFilterState createState() =>
      _EmployeesListWithFilterState();
}

class _EmployeesListWithFilterState extends State<EmployeesListWithFilter> {
  FilterEmployeesBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<FilterEmployeesBloc>(context);
    super.didChangeDependencies();
  }

  void _onDeleted(Model.Chip chip) {
    _bloc.onWorkingAreaChipChanged(chip);
    _bloc.add(const GetEmployees(true));
  }

  void _toggleChip(Model.Chip chip) {
    _bloc.onWorkingAreaChipChanged(chip);
  }

  @override
  Widget build(BuildContext context) => EnabledChipsList(
        scrollDirection: Axis.horizontal,
        height: MediaQuery.of(context).size.height,
        onDeletedChip: _onDeleted,
        stream: _bloc.enabledWorkingAreaChipList,
        toggleChip: _toggleChip,
        child: EmployeeList(widget.isAdmin),
      );
}
