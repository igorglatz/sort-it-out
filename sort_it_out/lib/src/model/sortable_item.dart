import 'package:flutter/material.dart';

class SortableItem extends StatefulWidget {
  final String title;
  final Color color;
  final double height;
  final double width;
  final double fontSize;

  const SortableItem(
      {Key? key,
      required this.title,
      required this.color,
      this.height = 40.0,
      this.width = 40.0,
      this.fontSize = 20.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SortableItemState();
}

class SortableItemState extends State<SortableItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: widget.color,
        width: widget.width,
        height: widget.height,
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(fontSize: widget.fontSize),
          ),
        ),
      ),
    );
  }
}
