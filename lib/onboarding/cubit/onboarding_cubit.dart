import 'package:analytics_repository/analyitics.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({required AnalyticsService analyticsService})
      : _analyticsService = analyticsService,
        super(const OnboardingState(status: OnboardingStatus.initial));

  final AnalyticsService _analyticsService;

  void initOnboarding() {
    _analyticsService.logEvent(name: 'tutorial_begin');
    emit(state.copyWith(status: OnboardingStatus.initiated));
  }

  void completedOnboarding() {
    _analyticsService.logEvent(name: 'tutorial_complete');
    emit(state.copyWith(status: OnboardingStatus.completed));
  }
}
