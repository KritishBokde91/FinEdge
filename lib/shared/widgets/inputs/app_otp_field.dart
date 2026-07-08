import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../core/theme/app_radius.dart';

/// Reusable multi-box OTP / PIN input field with focus auto-advancing.
/// Implemented as a HookWidget to encapsulate focus node and controller lifecycles.
class AppOtpField extends HookWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const AppOtpField({required this.onCompleted, this.length = 4, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Create controllers and focus nodes matching OTP length
    final controllers = List.generate(
      length,
      (_) => useTextEditingController(),
    );
    final focusNodes = List.generate(length, (_) => useFocusNode());

    // Gather code sequence changes
    void checkPin() {
      final code = controllers.map((c) => c.text).join();
      if (code.length == length) {
        onCompleted(code);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(length, (index) {
        return SizedBox(
          width: 56,
          height: 64,
          child: TextFormField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.borderMd,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.borderMd,
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2.0,
                ),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                // Focus next input box
                if (index < length - 1) {
                  focusNodes[index + 1].requestFocus();
                } else {
                  focusNodes[index].unfocus();
                }
              } else {
                // Focus previous input box on backspace deletion
                if (index > 0) {
                  focusNodes[index - 1].requestFocus();
                }
              }
              checkPin();
            },
          ),
        );
      }),
    );
  }
}
