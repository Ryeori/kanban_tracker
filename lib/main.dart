import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kanban_tracker/app.dart';
import 'package:kanban_tracker/core/injections/injections.dart';
import 'package:kanban_tracker/core/widgets/localization_wrapper.dart';
import 'package:kanban_tracker/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();

  await EasyLocalization.ensureInitialized();

  runApp(const LocalizationWrapper(child: App()));
}
