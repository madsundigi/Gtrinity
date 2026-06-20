import 'package:flutter/material.dart';

class CKListViewBuilder<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Widget? separator;

  const CKListViewBuilder({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    if (separator != null) {
      return ListView.separated(
        itemCount: items.length,
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap,
        separatorBuilder: (context, index) => separator!,
        itemBuilder: (context, index) =>
            itemBuilder(context, items[index], index),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) =>
          itemBuilder(context, items[index], index),
    );
  }
}
