import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

abstract class Validators {
  static String Function(String) compose(
          List<String Function(String)> validators) =>
      FormBuilderValidators.compose(validators);

  static String Function(String) onlyLetters(BuildContext context,
          {String error}) =>
      FormBuilderValidators.match(
        context,
        '^[a-zA-Z]+\$',
        errorText: error,
      );

  static String Function(String) required(BuildContext context,
          {String error}) =>
      FormBuilderValidators.required(context, errorText: error);

  static String Function(String) match(BuildContext context, String expression,
          {String error}) =>
      FormBuilderValidators.match(context, expression, errorText: error);

  static String Function(String) onlyNumbers(BuildContext context,
          {String error}) =>
      FormBuilderValidators.numeric(context, errorText: error);

  static String Function(String) minValue(BuildContext context, int minimum,
          {String error}) =>
      FormBuilderValidators.min(context, minimum, errorText: error);

  static String Function(String) maxValue(BuildContext context, int maximum,
          {String error}) =>
      FormBuilderValidators.max(context, maximum, errorText: error);

  static String Function(String) minLength(BuildContext context, int minimum,
          {String error}) =>
      FormBuilderValidators.maxLength(context, minimum, errorText: error);

  static String Function(String) maxLength(BuildContext context, int maximum,
          {String error}) =>
      FormBuilderValidators.maxLength(context, maximum, errorText: error);

  static String Function(String) email(BuildContext context, {String error}) =>
      FormBuilderValidators.email(context, errorText: error);

  static String Function(String) url(BuildContext context, {String error}) =>
      FormBuilderValidators.url(context, errorText: error);

  static String Function(String) integer(BuildContext context,
          {String error}) =>
      FormBuilderValidators.integer(context, errorText: error);

  static String Function(String) creditCard(BuildContext context,
          {String error}) =>
      FormBuilderValidators.creditCard(context, errorText: error);

  static String Function(String) ip(BuildContext context, {String error}) =>
      FormBuilderValidators.ip(context, errorText: error);

  static String Function(String) date(BuildContext context, {String error}) =>
      FormBuilderValidators.dateString(context, errorText: error);
}
