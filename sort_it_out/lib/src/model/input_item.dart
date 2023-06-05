import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputItem extends StatefulWidget {
  final int position;
  final Color color;
  final double height;
  final double width;
  final double fontSize;
  final onChangedValue;
  final bool clean;

  const InputItem(
      {Key? key,
      required this.position,
      required this.color,
      this.onChangedValue,
      this.clean = false,
      this.height = 40.0,
      this.width = 40.0,
      this.fontSize = 20.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => InputItemState();
}

class InputItemState extends State<InputItem> {
  String value = '';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: widget.color,
        width: widget.width,
        height: widget.height,
        child: Center(
            child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value) => widget.onChangedValue(value),
                controller:
                    widget.clean ? TextEditingController(text: "") : null,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ])),
      ),
    );
  }
}
