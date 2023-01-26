import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/navigation/app_router.gr.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/board/models/board/board.dart';
import 'package:kanban_tracker/features/boards_overview/boards_overview_cubit/boards_overview_cubit.dart';
import 'package:kanban_tracker/features/boards_overview/ui/widgets/board_overview_list_item.dart';

class BoardsOverviewPage extends StatefulWidget {
  const BoardsOverviewPage({super.key});

  @override
  State<BoardsOverviewPage> createState() => _BoardsOverviewPageState();
}

class _BoardsOverviewPageState extends State<BoardsOverviewPage> {
  Future<void> onBoardCreationTap() async {
    await AutoRouter.of(context).navigate(const BoardCreationPageRoute());
  }

  Future<void> onBoardTap(Board selectedBoard) async {
    await AutoRouter.of(context).replace(
      BoardRouter(selectedBoard: selectedBoard),
    );
  }

  void onSignOutTap() {
    BlocProvider.of<AuthenticationBloc>(context)
        .add(const AuthenticationEvent.signOut());
  }

  @override
  void initState() {
    BlocProvider.of<AuthenticationBloc>(context).state.whenOrNull(
      signedIn: (user) {
        BlocProvider.of<BoardsOverviewCubit>(context)
            .loadUserBoards(userId: user.id);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select working board'),
        leading:
            IconButton(onPressed: onSignOutTap, icon: Icon(Icons.exit_to_app)),
      ),
      body: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding,
          appPrimaryPadding + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<BoardsOverviewCubit, BoardsOverviewState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    loaded: (userBoards) {
                      if (userBoards.isEmpty) {
                        return const Center(
                          child: Text(
                            'You dont have any boards created or added yet',
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: userBoards.length,
                        itemBuilder: (context, index) {
                          return BoardOverviewListItem(
                            board: userBoards[index],
                            onTap: () => onBoardTap(userBoards[index]),
                          );
                        },
                      );
                    },
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onBoardCreationTap,
                child: const Text('Create new board'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
