import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Txt extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign align;
  TextStyle style = const TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );

  Txt(
    this.text, {
    super.key,
    this.size = 14,
    this.color = Colors.black,
    this.weight = FontWeight.normal,
    this.align = TextAlign.left,
  });

  Txt.bold(
    this.text, {
    super.key,
    this.size = 20,
    this.color = Colors.black,
    this.weight = FontWeight.bold,
    this.align = TextAlign.center,
  }) {
    style = style.copyWith(fontWeight: weight);
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: align, style: style);
  }
}
