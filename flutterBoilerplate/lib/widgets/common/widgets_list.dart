import 'package:flutter/material.dart';

class WidgetsList extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final List<Widget> children;

  const WidgetsList({
    this.children,
    this.width,
    this.height,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => Container(
        height: height ?? MediaQuery.of(context).size.height,
        width: width ?? MediaQuery.of(context).size.width,
        margin: margin ?? const EdgeInsets.all(0),
        child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
      );
}
