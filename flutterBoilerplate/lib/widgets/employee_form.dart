import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_bloc.dart';
import 'package:flutterBoilerplate/widgets/common/dropdown_button.dart';
import 'package:flutterBoilerplate/widgets/common/responsive_button.dart';
import 'package:flutterBoilerplate/widgets/common/slider.dart';
import 'package:flutterBoilerplate/widgets/common/text_field_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeeForm extends StatelessWidget {
  final bool editEmployee;
  final VoidCallback execute;
  final EmployeeBloc bloc;

  const EmployeeForm({
    this.bloc,
    this.editEmployee,
    this.execute,
  });

  Row _chargeInput(BuildContext context) => Row(
        children: [
          const Text(
            'Charge: ',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          ResponsiveDropDownButton<String>(
            streamList: bloc.workingAreaList,
            streamValue: bloc.workingArea,
            onChanged: bloc.onWorkingAreaChanged,
            mapper: (String text) => DropdownMenuItem<String>(
              value: text,
              child: Text(
                text,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFieldBuilder(
              withInitialValue: editEmployee,
              labelText: AppLocalizations.of(context).name,
              stream: bloc.firstName,
              onChanged: bloc.onFirstNameChanged,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFieldBuilder(
              withInitialValue: editEmployee,
              labelText: AppLocalizations.of(context).lastName,
              stream: bloc.lastName,
              onChanged: bloc.onLastNameChanged,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFieldBuilder(
              withInitialValue: editEmployee,
              labelText: AppLocalizations.of(context).email,
              stream: bloc.email,
              onChanged: bloc.onEmailChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextFieldBuilder(
              withInitialValue: editEmployee,
              prefix: '+598 ',
              labelText: AppLocalizations.of(context).phone,
              stream: bloc.phone,
              onChanged: bloc.onPhoneChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextFieldBuilder(
              withInitialValue: editEmployee,
              labelText: AppLocalizations.of(context).address,
              stream: bloc.address,
              onChanged: bloc.onAddressChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ResponsiveSlider(
              stream: bloc.age,
              onChanged: bloc.onAgeChanged,
              max: 100,
              min: 1,
              label: AppLocalizations.of(context).age,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            _chargeInput(context),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextFieldBuilder(
              maxLines: 5,
              withInitialValue: editEmployee,
              labelText: AppLocalizations.of(context).description,
              stream: bloc.description,
              onChanged: bloc.onDescriptionChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            ResponsiveButton(
              width: MediaQuery.of(context).size.width * 0.9,
              activeColorButton: Colors.white,
              disabledColorButton: Colors.grey[400],
              activeColorText: Colors.teal,
              disabledColorText: Colors.white,
              stream: bloc.activateButton,
              action: execute,
              title: editEmployee
                  ? AppLocalizations.of(context).update
                  : AppLocalizations.of(context).create,
            )
          ],
        ),
      );
}
