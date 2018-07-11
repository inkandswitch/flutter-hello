import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'dart:typed_data';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Flutter',
      home: ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool _finished;
  PainterController _controller;

  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = PainterController();

    controller.thickness = 2.0;

    controller.backgroundColor = Colors.white;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions;
    if (_finished) {
      actions = [
        IconButton(
          icon: const Icon(Icons.content_copy),
          tooltip: 'New Painting',
          onPressed: () => setState(() {
                _finished = false;
                _controller = _newController();
              }),
        ),
      ];
    } else {
      actions = [
        IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: _controller.undo),
        IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear',
            onPressed: _controller.clear),
        IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => _show(_controller.finish(), context)),
      ];
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Hello Flutter'),
          actions: actions,
          bottom: PreferredSize(
            child: DrawBar(_controller),
            preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
          )),
      body: Center(child: Painter(_controller)),
    );
  }

  void _show(PictureDetails picture, BuildContext context) {
    setState(() {
      _finished = true;
    });
    Navigator
        .of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('View your image'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: FutureBuilder<Uint8List>(
              future: picture.toPNG(),
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Image.memory(snapshot.data);
                    }
                    break;
                  default:
                    return Container(
                        child: FractionallySizedBox(
                      widthFactor: 0.1,
                      child: const AspectRatio(
                          aspectRatio: 1.0, child: CircularProgressIndicator()),
                      alignment: Alignment.center,
                    ));
                }
              },
            )),
      );
    }));
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Text(_controller.thickness.toStringAsPrecision(2),
                        style: const TextStyle(color: Colors.white))),
                Flexible(
                    child: Container(
                        child: Slider(
                  value: _controller.thickness,
                  onChanged: (double value) => setState(() {
                        _controller.thickness = value;
                      }),
                  min: 1.0,
                  max: 20.0,
                  activeColor: Colors.white,
                ))),
                ColorPickerButton(_controller, false),
                ColorPickerButton(_controller, true),
              ]);
        }));
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(_iconData, color: _color),
        tooltip: widget._background
            ? 'Change background color'
            : 'Change draw color',
        onPressed: _pickColor);
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator
        .of(context)
        .push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Pick color'),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
