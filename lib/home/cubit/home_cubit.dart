import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(pageIndex: 0));

  void updatePageIndex(int currentIndex) {
    emit(state.copyWith(pageIndex: currentIndex));
  }
}
