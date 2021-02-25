import 'package:flutter/material.dart';

class ResponsiveDropDownButton<T> extends StatelessWidget {
  final Stream<List<T>> streamList;
  final Stream<T> streamValue;
  final DropdownMenuItem<T> Function(T) mapper;
  final void Function(T) onChanged;

  const ResponsiveDropDownButton({
    @required this.streamList,
    @required this.onChanged,
    @required this.mapper,
    @required this.streamValue,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<List<T>>(
        stream: streamList,
        builder: (BuildContext context, AsyncSnapshot<List<T>> snapshotList) =>
            StreamBuilder<T>(
          stream: streamValue,
          builder: (BuildContext context, AsyncSnapshot<T> snapshotValue) =>
              snapshotList.hasData && snapshotValue.hasData
                  ? DropdownButton<T>(
                      underline: const DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      value: snapshotValue.data,
                      iconEnabledColor: Colors.white,
                      items: snapshotList.data.map(mapper).toList(),
                      onChanged: onChanged,
                    )
                  : const SizedBox(height: 0.0, width: 0.0),
        ),
      );
}
