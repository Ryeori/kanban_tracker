import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/navigation/app_router.gr.dart';
import 'package:kanban_tracker/core/services/toast_service/toast_service.dart';
import 'package:kanban_tracker/features/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/boards_overview/logic/boards_overview_cubit/boards_overview_cubit.dart';

class AuthenticationListener extends StatefulWidget {
  const AuthenticationListener({
    super.key,
    required this.child,
    required this.appRouter,
  });

  final Widget child;
  final AppRouter appRouter;

  @override
  State<AuthenticationListener> createState() => _AuthenticationListenerState();
}

class _AuthenticationListenerState extends State<AuthenticationListener> {
  Future<void> onUserSignedIn({required String userId}) async {
    await BlocProvider.of<BoardsOverviewCubit>(context)
        .loadUserBoards(userId: userId);
    await widget.appRouter.replace(const BoardsOverviewRouter());

    //todo: NAVIGATE TO BOARDS OVERVIEW PAGE WITH SOME LITTLE DELAY
  }

  Future<void> onUserSignedOut() async {
    await widget.appRouter.replace(const AuthRouter());
  }

  Future<void> onInitialState() async {
    await widget.appRouter.replace(const AuthRouter());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (errorMessage) {
            ToastService.showMessage(context, errorMessage: errorMessage);
          },
          signedIn: (appUser) => onUserSignedIn(userId: appUser.id),
          signedOut: onUserSignedOut,
          initial: onInitialState,
        );
      },
      child: widget.child,
    );
  }
}
