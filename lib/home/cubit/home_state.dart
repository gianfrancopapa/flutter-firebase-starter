part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({required this.pageIndex});

  final int pageIndex;

  @override
  List<Object> get props => [pageIndex];

  HomeState copyWith({int? pageIndex}) {
    return HomeState(pageIndex: pageIndex ?? this.pageIndex);
  }
}
