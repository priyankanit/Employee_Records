import 'package:employee_records/utils/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isSelected;
  

  const CustomButton({super.key,
  required this.text,
    required this.onPressed,
    this.width = 200,
    this.height = 50,
    this.color = AppPallete.lightBlue,
    this.textColor = AppPallete.primaryBlue,
    required this.borderRadius,
    required this.fontSize,
    required this.fontWeight,
    this.isSelected = false,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppPallete.primaryBlue : color,
          foregroundColor: isSelected ? AppPallete.white : textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: isSelected ? AppPallete.white : textColor,
          ),
        ),
      ),
    );
  }
}