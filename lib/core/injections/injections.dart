import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kanban_tracker/core/injections/injections.config.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureDependencies() {
  getIt.init();
}
