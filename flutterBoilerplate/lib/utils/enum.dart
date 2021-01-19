class Enum {
  static String getEnumValue(enumValue) =>
      enumValue.toString().substring(enumValue.toString().indexOf('.') + 1);
}
