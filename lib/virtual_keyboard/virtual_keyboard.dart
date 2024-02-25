import 'package:flutter/material.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keys.dart';

class VirtualKeyboard<T extends VirtualKey<R>, R> extends StatelessWidget {
  const VirtualKeyboard({
    super.key,
    required this.virtualKeys,
    required this.onKeyPressed,
    required this.onBackspacePressed,
    this.columns = 3,
  });

  final List<T> virtualKeys;

  final void Function(R value) onKeyPressed;
  final void Function() onBackspacePressed;

  final int columns;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      children: [
        ...virtualKeys.map<Widget>((virtualKey) {
          return TextButton(
            onPressed: () => onKeyPressed(virtualKey.value),
            child: Text(virtualKey.label),
          );
        }),
        ...List.generate(
          (virtualKeys.length + 1) % columns,
          (index) => const SizedBox.shrink(),
        ),
        TextButton(
          onPressed: onBackspacePressed,
          child: const Icon(Icons.backspace_sharp),
        ),
      ],
    );
  }
}
