import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/utils/chip.dart' as Model;

class EnabledChipsList extends StatelessWidget {
  final double height;
  final double width;
  final void Function(Model.Chip) onDeletedChip;
  final void Function(Model.Chip) toggleChip;
  final Stream<List<Model.Chip>> stream;
  final Widget child;
  final Axis scrollDirection;

  const EnabledChipsList({
    this.child,
    this.stream,
    this.onDeletedChip,
    this.toggleChip,
    this.height,
    this.width,
    this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height ?? 300.0,
        width: width ?? MediaQuery.of(context).size.height,
        child: Stack(
          overflow: Overflow.visible,
          children: [
            child,
          ],
        ),
      );
}
