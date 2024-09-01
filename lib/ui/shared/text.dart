import 'package:flutter/material.dart';

class Txt extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign align;
  final TextStyle style = const TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );

  const Txt(
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
    this.size = 16,
    this.color = Colors.black,
    this.weight = FontWeight.bold,
    this.align = TextAlign.left,
  }) {
    style.copyWith(fontWeight: weight);
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: align, style: style);
  }
}
