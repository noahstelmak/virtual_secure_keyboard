import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keyboard.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keys.dart';

class LoginThing extends StatefulWidget {
  const LoginThing({super.key});

  @override
  State<LoginThing> createState() => _LoginThingState();
}

class _LoginThingState extends State<LoginThing> {
  final passwordField = FocusNode();

  @override
  void initState() {
    passwordField.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  label: Text(AppLocalizations.of(context)!.usenameLabel),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                autofocus: true,
                obscureText: true,
                focusNode: passwordField,
                readOnly: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  label: Text(AppLocalizations.of(context)!.passwordLabel),
                  border: const OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {},
              ),
              const SizedBox(height: 16),
              TextFieldTapRegion(
                onTapInside: (event) {
                  passwordField.requestFocus();
                },
                child: VirtualKeyboard(
                  enabled: passwordField.hasFocus,
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
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {},
                child: const Text(
                  "Entrar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
