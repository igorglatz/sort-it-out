import 'package:flutter/material.dart';

class DraggableListItem extends StatefulWidget {
  final String title;
  final Color color;

  const DraggableListItem({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DraggableListItemState();
}

class DraggableListItemState extends State<DraggableListItem> {
  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      color: widget.color,
      child: Text(
        widget.title,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  void changeColor(Color newColor) {
    setState(() {
      color = newColor;
    });
  }
}
