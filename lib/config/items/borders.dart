import 'package:flutter/material.dart';

class Borders {
  static Border kContainerBase = Border.all(
    color: const Color(0xFFCDD1DC),
    width: 1,
    style: BorderStyle.solid,
  );

  static Border kContainerFocused = Border.all(
    color: const Color(0xFF8C92AB),
    width: 1,
    style: BorderStyle.solid,
  );

  static Border kContainerError = Border.all(
    color: const Color(0xFFFB2047),
    width: 1,
    style: BorderStyle.solid,
  );

  static Border kContainerSuccess = Border.all(
    color: const Color(0xFF00D99A),
    width: 1,
    style: BorderStyle.solid,
  );

  static Border kContainerDisabled = Border.all(
    color: const Color(0xFFCDD1DC),
    width: 1,
    style: BorderStyle.solid,
  );

  static OutlineInputBorder kTextInputBase = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFFCDD1DC),
      width: 1,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(8), // Kenarları yuvarlatmak istersen
  );

  static OutlineInputBorder kTextInputFocused = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFF8C92AB),
      width: 1,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(8), // Kenarları yuvarlatmak istersen
  );

  static OutlineInputBorder kTextInputError = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFFFB2047),
      width: 1,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(8), // Kenarları yuvarlatmak istersen
  );

  static OutlineInputBorder kTextInputSuccess = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFF00D99A),
      width: 1,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(8), // Kenarları yuvarlatmak istersen
  );

  static OutlineInputBorder kTextInputDisabled = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Color(0xFFCDD1DC),
      width: 1,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.circular(8), // Kenarları yuvarlatmak istersen
  );
}
