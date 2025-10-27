import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String message;
  const NotificationItem(this.message);
  @override
  List<Object?> get props => [message];
}

class NotificationState extends Equatable {
  final List<NotificationItem> items;
  const NotificationState(this.items);
  @override
  List<Object?> get props => [items];
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState([]));

  void addNotification(String message) {
    final updated = List<NotificationItem>.from(state.items)
      ..add(NotificationItem(message));
    emit(NotificationState(updated));
  }
}
