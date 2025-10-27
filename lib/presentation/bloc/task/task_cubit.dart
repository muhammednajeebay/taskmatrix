import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class TaskState extends Equatable {
  final List<String> tasks; // placeholder
  const TaskState({this.tasks = const []});
  @override
  List<Object?> get props => [tasks];
}

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState());

  void loadTasks() {
    // TODO: integrate with Supabase in Phase 3
    emit(TaskState(tasks: List.generate(10, (i) => 'Task #$i')));
  }
}
