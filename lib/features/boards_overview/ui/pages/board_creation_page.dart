import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/navigation/app_router.gr.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/boards_overview/logic/boards_overview_cubit/boards_overview_cubit.dart';

class BoardCreationPage extends StatefulWidget {
  const BoardCreationPage({
    super.key,
  });

  @override
  State<BoardCreationPage> createState() => _BoardCreationPageState();
}

class _BoardCreationPageState extends State<BoardCreationPage> {
  final TextEditingController titleController = TextEditingController();

  Future<void> onBoardCreate() async {
    final boardUserId =
        BlocProvider.of<AuthenticationBloc>(context).state.maybeWhen(
              signedIn: (user) => user.id,
              orElse: () => '',
            );

    await BlocProvider.of<BoardsOverviewCubit>(context)
        .createNewBoard(
      boardUserId: boardUserId,
      title: titleController.text.trim(),
    )
        .then((createdBoard) {
      if (createdBoard != null) {
        AutoRouter.of(context).replace(
          BoardRouter(selectedBoard: createdBoard),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Enter board name'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: onBoardCreate,
                child: const Text('Create new board'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
