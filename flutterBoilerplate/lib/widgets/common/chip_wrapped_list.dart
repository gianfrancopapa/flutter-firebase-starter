import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/utils/chip.dart' as my;

class ChipWrappedList extends StatelessWidget {
  final Color activeChipColor;
  final Color activeTextChipColor;
  final Color inactiveChipColor;
  final Color inActiveTextChipColor;
  final List<my.Chip> chips;
  final void Function(my.Chip chip) toggleChip;
  final void Function(my.Chip chip) onDeleted;
  final bool showDeleteIcon;
  final Axis scrollDirection;

  const ChipWrappedList({
    this.onDeleted,
    this.showDeleteIcon = false,
    this.chips,
    this.activeChipColor,
    this.activeTextChipColor = Colors.white,
    this.inactiveChipColor,
    this.inActiveTextChipColor = Colors.white,
    this.toggleChip,
    this.scrollDirection,
  });

  Chip _chip(my.Chip chip) => Chip(
        onDeleted: showDeleteIcon ? () => onDeleted(chip) : null,
        deleteIcon: showDeleteIcon
            ? const Icon(
                Icons.cancel,
                color: Colors.grey,
                size: 18.0,
              )
            : null,
        label: Text(
          chip.text,
          style: TextStyle(
            color: chip.enabled ? activeTextChipColor : inActiveTextChipColor,
          ),
        ),
        backgroundColor: chip.enabled ? activeChipColor : inactiveChipColor,
      );

  @override
  Widget build(BuildContext context) => Wrap(
        children: chips
            .map(
              (chip) => Container(
                margin: const EdgeInsets.all(4.0),
                child: showDeleteIcon
                    ? _chip(chip)
                    : InkWell(
                        onTap: () => toggleChip(chip),
                        child: _chip(chip),
                      ),
              ),
            )
            .toList(),
      );
}
