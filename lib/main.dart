import 'package:flutter/material.dart';
import 'package:virtual_secure_keyboard/login_thing/login_thing.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll(
              Size(double.infinity, 0),
            ),
            fixedSize: MaterialStatePropertyAll(
              Size.fromHeight(56),
            ),
          ),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginThing(),
    );
  }
}
