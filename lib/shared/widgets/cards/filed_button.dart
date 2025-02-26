import 'package:flutter/material.dart';

class GradientButtonRed extends StatelessWidget {
  const GradientButtonRed({
    super.key,
    this.onPressed,
    this.text,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = 8,
    this.textStyle,
  });

  final VoidCallback? onPressed;
  final String? text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 225, 10, 81),
              Color.fromARGB(255, 88, 17, 12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: Colors.white, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
          ),
          child: Text(
            text!,
            style: textStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}




class GradientButtonBlack extends StatelessWidget {
  const GradientButtonBlack({
    super.key,
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
    this.height = 60,
    this.borderRadius = 8,
    this.textStyle,
  });

  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 60, 5, 22),
              Color.fromARGB(255, 0, 0, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: Colors.white, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
          ),
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}