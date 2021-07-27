import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class StarterBottomNavigationBar extends StatelessWidget {
  const StarterBottomNavigationBar({
    Key key,
    @required this.index,
    @required this.updateIndex,
  })  : assert(index != null),
        assert(updateIndex != null),
        super(key: key);

  final int index;
  final void Function(int) updateIndex;

  Widget _item(int idx, IconData icon) {
    final selectedIndex = idx == index;

    return InkWell(
      onTap: () {
        updateIndex(idx);
      },
      child: SizedBox(
        child: Icon(
          icon,
          color: selectedIndex ? AppColor.blue : AppColor.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        elevation: 0.0,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.lightGrey,
            border: Border(
              top: BorderSide(color: Color(0xffC1C1C1), width: 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _item(0, Feather.home),
                Margin(150.0, 0.0),
                _item(1, Feather.user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
