import 'package:flutter/material.dart';

class ResponsiveCheckbox extends StatelessWidget {
  final String label;
  final Stream<bool> stream;
  final Function(bool) onChanged;

  const ResponsiveCheckbox({this.label, this.stream, this.onChanged});

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        initialData: false,
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => Row(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.green,
              value: snapshot.data,
              onChanged: onChanged,
            ),
          ],
        ),
      );
}
