import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_bloc.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_event.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_state.dart';
import 'package:flutterBoilerplate/widgets/common/chip_list.dart';
import 'package:flutterBoilerplate/widgets/employee_list.dart';
import 'package:flutterBoilerplate/widgets/filter_icon.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeesListScreen extends StatefulWidget {
  final bool isAdmin;
  const EmployeesListScreen(this.isAdmin);
  @override
  _EmployeesListScreenState createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  FilterEmployeesBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<FilterEmployeesBloc>(context)
      ..add(const GetAppliedFilters());
    super.didChangeDependencies();
  }

  void _toggleChip(int id) {
    _bloc.add(ToggleWorkingAreaFilter(id));
  }

  void _removeChip(int id) {
    _bloc.add(RemoveWorkingAreaFilter(id));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context).employees,
          ),
          actions: <Widget>[FilterIcon()],
        ),
        body: Column(
          children: [
            BlocBuilder<FilterEmployeesBloc, FilterEmployeesState>(
              cubit: _bloc,
              buildWhen: (previous, current) =>
                  current.runtimeType == AppliedFilters,
              builder: (BuildContext context, FilterEmployeesState state) =>
                  state.runtimeType == AppliedFilters
                      ? Container(
                          decoration: const BoxDecoration(color: Colors.teal),
                          height: (state as AppliedFilters).chips.length > 0
                              ? 50.0
                              : 0.0,
                          child: ChipList(
                            scrollDirection: Axis.horizontal,
                            onDeleted: _removeChip,
                            showDeleteIcon: true,
                            activeChipColor: Colors.white,
                            activeTextChipColor: Colors.teal,
                            inactiveChipColor: Colors.grey,
                            toggleChip: _toggleChip,
                            chips: (state as AppliedFilters).chips,
                          ),
                        )
                      : const SizedBox(height: 0.0),
            ),
            Expanded(child: EmployeeList(widget.isAdmin))
          ],
        ),
      );
}
