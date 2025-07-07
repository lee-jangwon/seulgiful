import 'package:flutter/material.dart';

class OauthButton extends StatelessWidget {
  const OauthButton({
    super.key,
    required this.provider,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onPressed,
  });

  final String provider;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor, width: 1),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 24, color: textColor), const SizedBox(width: 12), Text('$provider로 계속하기', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))]),
      ),
    );
  }
}
