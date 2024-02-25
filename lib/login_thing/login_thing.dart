import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keyboard.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keys.dart';

class LoginThing extends StatefulWidget {
  const LoginThing({super.key});

  @override
  State<LoginThing> createState() => _LoginThingState();
}

class _LoginThingState extends State<LoginThing> {
  bool frontSide = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 400,
          width: 300,
          child: getSide(),
        ),
      ),
    );
  }

  late final Widget userSide = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          icon: const Icon(Icons.person),
          label: Text(AppLocalizations.of(context)!.usenameLabel),
          border: const OutlineInputBorder(),
        ),
        onEditingComplete: () {
          setState(() {
            frontSide = false;
          });
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        obscureText: true,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          icon: const Icon(Icons.lock),
          label: Text(AppLocalizations.of(context)!.passwordLabel),
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
        onTap: () {
          setState(() {
            frontSide = false;
          });
        },
        onFieldSubmitted: (value) {},
      ),
    ],
  );

  late final Widget passwordSide = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AspectRatio(
        aspectRatio: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: TextFormField(
            autofocus: true,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock),
              label: Text(AppLocalizations.of(context)!.passwordLabel),
              border: const OutlineInputBorder(),
            ),
            onFieldSubmitted: (value) {
              setState(() {
                frontSide = true;
              });
            },
          ),
        ),
      ),
      AspectRatio(
        aspectRatio: 3 / 2,
        child: TextFieldTapRegion(
          onTapInside: (event) {
            /*  focusNode.requestFocus(); */
          },
          child: VirtualKeyboard(
            virtualKeys: IndexedVirtualKey.indexedKeys([
              "0 ou 1",
              "2 ou 3",
              "4 ou 5",
              "6 ou 7",
              "8 ou 9",
            ]),
            onKeyPressed: (value) {
              /*  String text = controller.text;
                          TextSelection textSelection = controller.selection;

                          String newText = text.replaceRange(
                              textSelection.start,
                              textSelection.end,
                              value.toString());
                          controller.text = newText;
                          controller.selection = textSelection.copyWith(
                            baseOffset: textSelection.start + 1,
                            extentOffset: textSelection.start + 1,
                          ); */
            },
            onBackspacePressed: () {
              /*  String text = controller.text;
                          final textSelection = controller.selection;
                          if (textSelection.baseOffset > 0) {
                            String newText = text.replaceRange(
                              textSelection.start - 1,
                              textSelection.end,
                              "",
                            );

                            controller.text = newText;
                            controller.selection = textSelection.copyWith(
                              baseOffset: textSelection.start - 1,
                              extentOffset: textSelection.start - 1,
                            );
                          } */
            },
          ),
        ),
      ),
      AspectRatio(
        aspectRatio: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: FilledButton(
            onPressed: () {
              setState(() {
                frontSide = true;
              });
            },
            child: const Text(
              "Entrar",
            ),
          ),
        ),
      ),
    ],
  );

  Widget getSide() {
    if (frontSide) {
      return userSide;
    } else {
      return passwordSide;
    }
  }
}
