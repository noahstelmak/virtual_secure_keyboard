import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keyboard.dart';
import 'package:virtual_secure_keyboard/virtual_keyboard/virtual_keys.dart';
import 'package:http/http.dart' as http;

/// A thing that log ins
class LoginThing extends StatefulWidget {
  const LoginThing({super.key});

  @override
  State<LoginThing> createState() => _LoginThingState();
}

class _LoginThingState extends State<LoginThing> {
  bool isLoading = false;

  final username = TextEditingController();
  final password = TextEditingController();

  final focusPassword = FocusNode();
  final focusUsername = FocusNode();

  List<List<int>> keys = [];
  List<List<int>> passwordKeys = [];

  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    focusUsername.addListener(() async {
      if (!focusUsername.hasFocus) {
        passwordKeys = [];
        password.text = "";

        try {
          keys = await sendUsername(username.text) ?? [];
          if (mounted) {
            FocusScope.of(context).requestFocus(focusPassword);
          }
        } catch (_) {}
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Form(
            key: formKey,
            autovalidateMode: autovalidateMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  focusNode: focusUsername,
                  controller: username,
                  validator: (value) => value == null || value.isEmpty
                      ? "Preencha o campo"
                      : null,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.person),
                    label: Text(AppLocalizations.of(context)!.usenameLabel),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  validator: (value) => value == null || value.isEmpty
                      ? "Preencha o campo"
                      : null,
                  focusNode: focusPassword,
                  enabled: keys.isNotEmpty,
                  controller: password,
                  obscureText: true,
                  readOnly: false,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock),
                    label: Text(
                      AppLocalizations.of(context)!.passwordLabel,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFieldTapRegion(
                  child: VirtualKeyboard(
                    enabled: keys.isNotEmpty,
                    virtualKeys: keys.isNotEmpty
                        ? List.generate(5, (index) {
                            final key = keys[index];

                            return IndexedVirtualKey(
                              label: "${key[0]} ou ${key[1]}",
                              value: key,
                            );
                          })
                        : IndexedVirtualKey.indexedKeys([
                            "0 ou 1",
                            "2 ou 3",
                            "4 ou 5",
                            "6 ou 7",
                            "8 ou 9",
                          ]),
                    onKeyPressed: (value) {
                      password.text += "A";
                      passwordKeys.add(value as List<int>);
                    },
                    onBackspacePressed: () {
                      if (passwordKeys.isNotEmpty) {
                        password.text = password.text.substring(
                          0,
                          password.text.length - 1,
                        );
                        passwordKeys.removeLast();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: !isLoading ? () => submitForm(context) : () {},
                  icon: isLoading
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const SizedBox(),
                  label: const Text(
                    "Entrar",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitForm(context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final r = await sendCredentials(username.text, passwordKeys);

      if (r != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginThing(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
              body: Center(
                child: Text(
                  r["username"].toString(),
                ),
              ),
            ),
          ),
        );
      } else {
        passwordKeys = [];
        password.text = "";
        keys = [];
        focusUsername.requestFocus();
        isLoading = false;
        setState(() {});
      }
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Future<dynamic> sendCredentials(
      String username, List<List<int>> password) async {
    final r = await http.post(
      Uri.parse("http://localhost:8080/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": passwordKeys,
      }),
    );
    print(passwordKeys);

    if (r.statusCode == 200) {
      final body = jsonDecode(r.body);
      print(body);
      if (body["user"] != null) {
        return body["user"];
      }
    }

    return null;
  }

  Future<List<List<int>>?> sendUsername(String username) async {
    final r = await http.post(
      Uri.parse("http://localhost:8080/auth/startSession?username=$username"),
    );

    if (r.statusCode == 200) {
      return convertEncodedKeys(r.body);
    } else {
      return null;
    }
  }
}

List<List<int>> convertEncodedKeys(String json) {
  return (jsonDecode(json)["keys"] as String)
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
}

List<String> generateKeys() {
  final numbers = List.generate(10, (index) => index)..shuffle(Random.secure());
  return List.generate(
    5,
    (index) => "${numbers[index]} ou ${numbers[index + 1]}",
  );
}
