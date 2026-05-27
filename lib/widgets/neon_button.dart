import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class NeonButton extends StatefulWidget {
  const NeonButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon = Icons.play_arrow_rounded,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 90),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: widget.onPressed,
              child: Ink(
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.startYellow,
                      AppColors.startOrange,
                      AppColors.startPink,
                    ],
                  ),
                  border: Border.all(color: AppColors.startBorder, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.startGlow,
                      blurRadius: 22,
                      offset: Offset(0, 5),
                    ),
                    BoxShadow(
                      color: Color(0x99000000),
                      blurRadius: 0,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: Colors.white, size: 34),
                    const SizedBox(width: 8),
                    Text(widget.label, style: AppTextStyles.startButton),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
