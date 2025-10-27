import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class PointsState extends Equatable {
  final int points;
  const PointsState(this.points);
  @override
  List<Object?> get props => [points];
}

class PointsCubit extends Cubit<PointsState> {
  PointsCubit() : super(const PointsState(0));

  void setPoints(int value) => emit(PointsState(value));
}
