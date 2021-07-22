part of 'onboarding_cubit.dart';

enum OnboardingStatus { initial, completed }

class OnboardingState extends Equatable {
  final OnboardingStatus status;

  const OnboardingState({@required this.status}) : assert(status != null);

  @override
  List<Object> get props => [status];

  OnboardingState copyWith({
    OnboardingStatus status,
  }) {
    return OnboardingState(
      status: status ?? this.status,
    );
  }
}
