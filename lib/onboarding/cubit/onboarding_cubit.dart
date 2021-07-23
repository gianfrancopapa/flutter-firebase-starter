import 'package:bloc/bloc.dart';
import 'package:firebasestarter/services/analytics/analyitics.dart';
import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({@required AnalyticsService analyticsService})
      : assert(analyticsService != null),
        _analyticsService = analyticsService,
        super(const OnboardingState(status: OnboardingStatus.initial));

  final AnalyticsService _analyticsService;

  void initOnboarding() {
    _analyticsService.logTutorialBegin();
    emit(state.copyWith(status: OnboardingStatus.initiated));
  }

  void completedOnboarding() {
    _analyticsService.logTutorialComplete();
    emit(state.copyWith(status: OnboardingStatus.completed));
  }
}