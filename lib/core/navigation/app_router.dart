import 'package:auto_route/annotations.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:kanban_tracker/features/authentication/ui/pages/sign_in_page.dart';
import 'package:kanban_tracker/features/authentication/ui/pages/sign_up_page.dart';
import 'package:kanban_tracker/features/board/ui/pages/board_home_page.dart';
import 'package:kanban_tracker/features/board/ui/pages/board_wrapper.dart';
import 'package:kanban_tracker/features/board/ui/pages/completed_tasks_history_page.dart';
import 'package:kanban_tracker/features/board/ui/pages/task_detailed_page.dart';
import 'package:kanban_tracker/features/board/ui/pages/task_editing_page.dart';
import 'package:kanban_tracker/features/boards_overview/ui/pages/board_creation_page.dart';
import 'package:kanban_tracker/features/boards_overview/ui/pages/boards_overview_page.dart';
import 'package:kanban_tracker/features/splash/ui/splash_page.dart';

@CupertinoAutoRouter(
  routes: [
    AutoRoute(page: SplashPage, initial: true, path: '/'),
    AutoRoute(
      page: EmptyRouterPage,
      name: 'authRouter',
      path: '/auth',
      initial: true,
      children: [
        AutoRoute(path: 'signin', page: SignInPage, initial: true),
        AutoRoute(path: 'signup', page: SignUpPage),
      ],
    ),
    AutoRoute(
      page: EmptyRouterPage,
      name: 'boardsOverviewRouter',
      path: '/boardsOverview',
      children: [
        AutoRoute(path: '', page: BoardsOverviewPage, initial: true),
        AutoRoute(path: 'create', page: BoardCreationPage, initial: true),
      ],
    ),
    AutoRoute(
      page: BoardWrapper,
      path: '/board',
      name: 'boardRouter',
      children: [
        AutoRoute(
          page: BoardHomePage,
          initial: true,
          path: '',
        ),
        AutoRoute(page: TaskEditingPage, path: 'edit'),
        AutoRoute(page: TaskDetailedPage, path: 'detailed'),
        AutoRoute(page: CompletedTaskHistoryPage, path: 'history')
      ],
    ),
  ],
)

///auto_route package
class $AppRouter {}
