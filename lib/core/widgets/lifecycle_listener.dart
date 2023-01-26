import 'package:flutter/material.dart';

class LifeCycleListener extends StatefulWidget {
  const LifeCycleListener({super.key, required this.child});

  final Widget child;
  @override
  State<LifeCycleListener> createState() => _LifeCycleListenerState();
}

class _LifeCycleListenerState extends State<LifeCycleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
    if (state == AppLifecycleState.inactive) {
      //TODO: CANCEL SUBSRIPTIONS ON REALTIME DATA WHILE IN BACKGROUND
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
