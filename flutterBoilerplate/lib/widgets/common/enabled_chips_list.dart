import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/utils/chip.dart' as Model;
import 'package:flutterBoilerplate/widgets/common/chip_list.dart';

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
            Container(
              decoration: const BoxDecoration(color: Colors.teal),
              height: 60.0,
              child: StreamBuilder<List<Model.Chip>>(
                stream: stream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Model.Chip>> snapshot,
                ) =>
                    snapshot.hasData
                        ? snapshot.data.length > 0
                            ? ChipList(
                                scrollDirection: scrollDirection,
                                onDeleted: onDeletedChip,
                                showDeleteIcon: true,
                                activeChipColor: Colors.white,
                                activeTextChipColor: Colors.teal,
                                inactiveChipColor: Colors.grey,
                                toggleChip: toggleChip,
                                chips: snapshot.data,
                              )
                            : const SizedBox(
                                height: 0.0,
                              )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
              ),
            ),
          ],
        ),
      );
}
