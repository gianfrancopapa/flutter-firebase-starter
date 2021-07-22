import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/services/analytics/analyitics.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter/widgets.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final AnalyticsService _analyticsService;
  OnboardingCubit({AnalyticsService analyticsService})
      : _analyticsService = analyticsService,
        super(const OnboardingState(status: OnboardingStatus.initial));

  void initOnboarding() {
    emit(state.copyWith(status: OnboardingStatus.initial));
    _analyticsService.logTutorialBegin();
  }

  void completedOnboarding() {
    emit(state.copyWith(status: OnboardingStatus.completed));
    _analyticsService.logTutorialComplete();
  }
}
