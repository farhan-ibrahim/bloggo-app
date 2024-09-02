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

  Txt.title(
    this.text, {
    super.key,
    this.size = 25,
    this.color = Colors.black,
    this.weight = FontWeight.w800,
    this.align = TextAlign.left,
  }) {
    style = style.copyWith(fontWeight: weight, fontSize: size, color: color);
  }

  Txt.caption(
    this.text, {
    super.key,
    this.size = 12,
    this.color = Colors.grey,
    this.weight = FontWeight.w200,
    this.align = TextAlign.left,
  }) {
    style = style.copyWith(fontWeight: weight, fontSize: size, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Text(text, textAlign: align, style: style);
  }
}
