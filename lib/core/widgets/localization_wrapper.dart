import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kanban_tracker/core/utils/localization_utils.dart';

class LocalizationWrapper extends StatefulWidget {
  const LocalizationWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<LocalizationWrapper> createState() => _LocalizationWrapperState();
}

class _LocalizationWrapperState extends State<LocalizationWrapper> {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: supportedLocales,
      fallbackLocale: supportedLocales.first,
      path: localeAssetsPath,
      child: widget.child,
    );
  }
}
