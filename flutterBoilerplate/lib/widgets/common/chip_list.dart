import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/utils/chip.dart' as my;

class ChipList extends StatelessWidget {
  final Color activeChipColor;
  final Color inactiveChipColor;
  final List<my.Chip> chips;
  final void Function(my.Chip chip) toggleChip;

  const ChipList({
    this.chips,
    this.activeChipColor,
    this.inactiveChipColor,
    this.toggleChip,
  });

  @override
  Widget build(BuildContext context) => Wrap(
        children: chips
            .map(
              (chip) => InkWell(
                onTap: () => toggleChip(chip),
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  child: Chip(
                    deleteIcon: null,
                    label: Text(
                      chip.text,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor:
                        chip.enabled ? activeChipColor : inactiveChipColor,
                  ),
                ),
              ),
            )
            .toList(),
      );
}
