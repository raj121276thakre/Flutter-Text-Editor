import 'package:flutter/material.dart';

class FontOptions extends StatefulWidget {
  final TextEditingController textController;
  final Function(TextAlign) onAlign;
  final Function(double) onFontSizeChange;
  final Function(bool) onBoldToggle;
  final Function(bool) onItalicToggle;

  const FontOptions({
    Key? key,
    required this.textController,
    required this.onAlign,
    required this.onFontSizeChange,
    required this.onBoldToggle,
    required this.onItalicToggle,
  }) : super(key: key);

  @override
  _FontOptionsState createState() => _FontOptionsState();
}

class _FontOptionsState extends State<FontOptions> {
  bool _isBold = false;
  bool _isItalic = false;
  double _fontSize = 16.0;
  TextAlign _textAlign = TextAlign.left;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.format_bold,
                  color: _isBold ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isBold = !_isBold;
                    widget.onBoldToggle(_isBold);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_italic,
                  color: _isItalic ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isItalic = !_isItalic;
                    widget.onItalicToggle(_isItalic);
                  });
                },
              ),
              DropdownButton<double>(
                value: _fontSize,
                items: [
                  12.0,
                  14.0,
                  16.0,
                  18.0,
                  20.0,
                  24.0,
                ].map((size) {
                  return DropdownMenuItem<double>(
                    value: size,
                    child: Text('$size'),
                  );
                }).toList(),
                onChanged: (size) {
                  if (size != null) {
                    setState(() {
                      _fontSize = size;
                      widget.onFontSizeChange(size);
                    });
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.format_align_left,
                  color: _textAlign == TextAlign.left ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _textAlign = TextAlign.left;
                    widget.onAlign(TextAlign.left);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_center,
                  color: _textAlign == TextAlign.center ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _textAlign = TextAlign.center;
                    widget.onAlign(TextAlign.center);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_right,
                  color: _textAlign == TextAlign.right ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _textAlign = TextAlign.right;
                    widget.onAlign(TextAlign.right);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.format_align_justify,
                  color: _textAlign == TextAlign.justify ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _textAlign = TextAlign.justify;
                    widget.onAlign(TextAlign.justify);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}