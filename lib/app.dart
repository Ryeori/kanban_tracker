import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/navigation/app_router.gr.dart';
import 'package:kanban_tracker/core/widgets/core_providers_wrapper.dart';
import 'package:kanban_tracker/core/widgets/lifecycle_listener.dart';
import 'package:kanban_tracker/features/authentication/ui/widgets/authentication_listener.dart';
import 'package:kanban_tracker/features/settings/logic/cubit/settings_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// auto_route package
  /// for more details go to lib/core/navigation/app_router.dart
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = ThemeData.light();
    return CoreProvidersWrapper(
      child: LifeCycleListener(
        child: AuthenticationListener(
          appRouter: appRouter,
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              state.whenOrNull(
                loaded: (isDarkMode) {
                  currentTheme =
                      isDarkMode ? ThemeData.dark() : ThemeData.light();
                },
              );

              return MaterialApp.router(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routerDelegate: appRouter.delegate(),
                routeInformationParser: appRouter.defaultRouteParser(),
                theme: currentTheme,
              );
            },
          ),
        ),
      ),
    );
  }
}
