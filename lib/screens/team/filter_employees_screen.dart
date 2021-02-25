import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_bloc.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_event.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutterBoilerplate/widgets/common/chip_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class FilterEmployeesScreen extends StatefulWidget {
  @override
  _FilterEmployeesScreenState createState() => _FilterEmployeesScreenState();
}

class _FilterEmployeesScreenState extends State<FilterEmployeesScreen> {
  FilterEmployeesBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<FilterEmployeesBloc>(context);
    _bloc.add(const GetFilters());
  }

  void _toggleChip(int id) {
    _bloc.add(ToggleWorkingAreaFilter(id));
  }

  Widget _header() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).filters,
            style: const TextStyle(
              color: Colors.teal,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () => _bloc.add(const ClearFilters()),
            child: Text(
              AppLocalizations.of(context).clear,
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          )
        ],
      );

  Widget _filterEmployeesByCharge() =>
      BlocBuilder<FilterEmployeesBloc, FilterEmployeesState>(
        cubit: _bloc,
        buildWhen: (previous, current) => current.runtimeType == Filters,
        builder: (BuildContext context, FilterEmployeesState state) =>
            state.runtimeType == Filters
                ? ChipSection(
                    showDeleteIcon: false,
                    height: 180.0,
                    activeChipColor: Colors.teal,
                    inactiveChipColor: Colors.grey,
                    toggleChip: _toggleChip,
                    title: AppLocalizations.of(context).workingArea,
                    chips: (state as Filters).chips,
                  )
                : const SizedBox(height: 0),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GestureDetector(
          onVerticalDragEnd: (details) => _bloc.add(const GetEmployees()),
          child: BlocConsumer<FilterEmployeesBloc, FilterEmployeesState>(
            cubit: _bloc,
            listener: (BuildContext context, FilterEmployeesState state) {
              if (state.runtimeType == Employees) {
                Navigator.pop(context);
              } else if (state.runtimeType == Error) {
                showDialog(
                  context: context,
                  builder: (context) => Text((state as Error).message),
                );
              }
            },
            builder: (BuildContext context, FilterEmployeesState state) =>
                ModalProgressHUD(
              inAsyncCall: state.runtimeType == Loading,
              progressIndicator: const CircularProgressIndicator(),
              child: Container(
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(color: Colors.teal),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _header(),
                          _filterEmployeesByCharge(),
                        ],
                      ),
                      Flexible(
                        flex: 1,
                        child: Button(
                          backgroundColor: Colors.teal,
                          textColor: Colors.white,
                          text: AppLocalizations.of(context).applyFilters,
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          onTap: () => _bloc.add(const ApplyFilters()),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
