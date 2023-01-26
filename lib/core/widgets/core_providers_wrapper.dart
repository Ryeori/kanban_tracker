import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/injections/injections.dart';
import 'package:kanban_tracker/features/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/boards_overview/boards_overview_cubit/boards_overview_cubit.dart';
import 'package:kanban_tracker/features/settings/logic/cubit/settings_cubit.dart';

class CoreProvidersWrapper extends StatelessWidget {
  const CoreProvidersWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BoardsOverviewCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AuthenticationBloc>()
            ..add(const AuthenticationEvent.started()),
        ),
        BlocProvider(create: (context) => getIt<SettingsCubit>()),
      ],
      child: child,
    );
  }
}
