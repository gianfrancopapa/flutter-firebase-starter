import 'package:flutter/material.dart';

class WidgetsList extends StatelessWidget {
  final double height;
  final double width;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final List<Widget> children;
  final Axis scrollDirection;

  const WidgetsList({
    this.children,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.scrollDirection,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: padding ?? const EdgeInsets.all(0.0),
        height: height ?? MediaQuery.of(context).size.height,
        width: width ?? MediaQuery.of(context).size.width,
        margin: margin ?? const EdgeInsets.all(0),
        child: ListView.builder(
          scrollDirection: scrollDirection ?? Axis.vertical,
          padding: const EdgeInsets.all(10.0),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
      );
}
