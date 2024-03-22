import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keyboard.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keys.dart';
import 'package:http/http.dart' as http;

class LoginThing extends StatefulWidget {
  const LoginThing({super.key});

  @override
  State<LoginThing> createState() => _LoginThingState();
}

class _LoginThingState extends State<LoginThing> {
  final passwordField = FocusNode();
  final controller = TextEditingController();

  List<String>? get keys => realKeys?.map((e) => "${e[0]} ou ${e[1]}").toList();
  List<List<int>>? realKeys = [];

  List<List<int>> password = [];
  @override
  void initState() {
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
                onFieldSubmitted: (value) async {
                  final r = await http.post(
                    Uri.parse(
                        "http://localhost:8080/auth/startSession?username=$value"),
                  );

                  if (r.statusCode == 200) {
                    realKeys = (jsonDecode(r.body)["keys"] as String)
                        .split(";")
                        .map(
                          (e) => e
                              .split(",")
                              .map(
                                (e) => int.parse(e),
                              )
                              .toList(),
                        )
                        .toList();
                  } else {
                    realKeys = null;
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                autofocus: true,
                obscureText: true,
                focusNode: passwordField,
                readOnly: true,
                controller: controller,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  label: Text(AppLocalizations.of(context)!.passwordLabel),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFieldTapRegion(
                onTapInside: (event) {
                  passwordField.requestFocus();
                },
                child: VirtualKeyboard(
                  enabled: passwordField.hasFocus,
                  virtualKeys: IndexedVirtualKey.indexedKeys(
                    keys ?? _generateKeys(),
                    realKeys!,
                  ),
                  onKeyPressed: (value) {
                    controller.text = controller.text + "F";
                    password.add(value as List<int>);
                  },
                  onBackspacePressed: () {
                    controller.text = controller.text
                        .substring(0, controller.text.length - 1);
                    password = List.generate(
                      password.length - 1,
                      (index) => password[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final r = await http.post(
                    Uri.parse("http://localhost:8080/auth/login"),
                    headers: {"Content-Type": "application/json"},
                    body: jsonEncode({
                      "username": "Martin",
                      "password": password,
                    }),
                  );

                  if (r.statusCode == 200) {
                    print(jsonDecode(r.body));
                  } else {
                    print(jsonDecode(r.body));
                  }
                  setState(() {});
                },
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

List<String> _generateKeys() {
  final numbers = List.generate(10, (index) => index)..shuffle(Random.secure());
  return List.generate(
    5,
    (index) => "${numbers[index]} ou ${numbers[index + 1]}",
  );
}
