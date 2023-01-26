import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/navigation/app_router.gr.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/core/styles/durations.dart';
import 'package:kanban_tracker/features/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/settings/logic/settings_cubit/settings_cubit.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late final SettingsCubit settingsCubit;

  @override
  void didChangeDependencies() {
    settingsCubit = BlocProvider.of<SettingsCubit>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  TextButton(
                    onPressed: () async {
                      widget.scaffoldKey.currentState?.closeDrawer();
                      await Future<void>.delayed(navigationTimeoutDuration)
                          .then(
                        (value) => AutoRouter.of(context)
                            .navigate(const CompletedTaskHistoryPageRoute()),
                      );
                    },
                    child: const Text('Board history'),
                  ),
                  TextButton(
                    onPressed: () async {
                      widget.scaffoldKey.currentState?.closeDrawer();
                      await Future<void>.delayed(navigationTimeoutDuration)
                          .then(
                        (value) => AutoRouter.of(context)
                            .replace(const BoardsOverviewRouter()),
                      );
                    },
                    child: const Text('Board selection'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Theme switcher'),
                      CupertinoSwitch(
                        activeColor: settingsCubit.state.whenOrNull(
                          loaded: (isDarkMode) =>
                              isDarkMode ? Colors.black : Colors.white,
                        ),
                        value: settingsCubit.state.maybeWhen(
                          orElse: () => false,
                          loaded: (isDarkMode) => isDarkMode,
                        ),
                        onChanged: (setDarkMode) {
                          settingsCubit.updateTheme(setDarkMode: setDarkMode);
                          setState(() {});
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(const AuthenticationEvent.signOut());
              },
              label: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }
}
