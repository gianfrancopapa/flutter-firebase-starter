import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/utils/screen_size.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomNavBar extends StatelessWidget {
  final _screenSize = ScreenSize();
  final int index;
  final void Function(int) updateIndex;

  BottomNavBar(this.index, this.updateIndex);

  Widget _item(int idx, IconData icon) => InkWell(
        onTap: () => updateIndex(idx),
        child: SizedBox(
          child: Icon(
            icon,
            color: idx == index ? AppColor.blue : AppColor.grey,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => BottomAppBar(
        elevation: 0.0,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.lightGrey,
            border: Border(
              top: BorderSide(color: Color(0xffC1C1C1), width: 1.0),
            ),
          ),
          height:
              _screenSize.getSize(context: context, designHeight: 110.0).height,
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
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
      );
}
