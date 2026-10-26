import 'dart:async';

import 'package:flutter/material.dart';
import 'package:navigations/core/motion/app_motion.dart';

class AddToCartButton extends StatefulWidget {
  const AddToCartButton({super.key, required this.onAdd});

  final VoidCallback onAdd;

  /// قد إيه علامة ✓ تفضل ظاهرة قبل ما الزرار يرجع
  static const confirmDuration = Duration(milliseconds: 1200);

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  Timer? _resetTimer;

  bool _added = false;

  void _handleTap() {
    widget.onAdd();

    _resetTimer?.cancel();

    setState(() => _added = true);

    _resetTimer = Timer(AddToCartButton.confirmDuration, () {
      if (mounted) setState(() => _added = false);
    });

  }

  @override
  void dispose() {
    _resetTimer?.cancel(); // من غيره: setState بعد ما الصفحة تتقفل
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // AnimatedContainer مبيعرفش يتحرك من وإلى double.infinity — لازم رقم حقيقي
        final fullWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 320.0;

        return Align(
          child: Semantics(
            button: true,
            child: GestureDetector(
              onTap: _handleTap,
              child: AnimatedContainer(
                duration: AppMotion.medium,
                curve: AppMotion.standard,
                width: _added ? 56 : fullWidth,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _added ? colors.tertiary : colors.primary,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: AnimatedSwitcher(
                  duration: AppMotion.medium,
                  child: _added
                      ? Icon(
                          Icons.check_rounded,
                          key: const ValueKey('added'),
                          color: colors.onTertiary,
                          semanticLabel: 'اتضاف للسلة',
                        )
                      : Text(
                          'ضيف للسلة',
                          key: const ValueKey('add'),
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: colors.onPrimary),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
