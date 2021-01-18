import 'package:flutter/material.dart';

class ResponsiveSlider extends StatelessWidget {
  final Stream<double> stream;
  final Function(double) onChanged;
  final int max;
  final int min;
  final String label;

  const ResponsiveSlider({
    this.stream,
    this.onChanged,
    this.max,
    this.min,
    this.label,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<double>(
        initialData: 0.0,
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) =>
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ${snapshot.data.truncate()}',
              style: const TextStyle(color: Colors.white, fontSize: 15.0),
            ),
            Slider(
              value: snapshot.data,
              onChanged: onChanged,
              max: 100,
            ),
          ],
        ),
      );
}
