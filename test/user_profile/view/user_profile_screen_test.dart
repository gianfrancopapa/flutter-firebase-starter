import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_bench.dart';

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockUserEvent extends Fake implements UserEvent {}

class MockUserState extends Fake implements UserState {}

class MockUser extends Mock implements User {}

void main() {
  group('UserProfileScreen', () {
    late UserBloc mockUserBloc;
    User? mockUser;

    setUp(() {
      mockUserBloc = MockUserBloc();
      mockUser = MockUser();

      when(() => mockUserBloc.state)
          .thenReturn(const UserState(status: UserStatus.initial));

      when(() => mockUser!.firstName).thenReturn('firstName');
      when(() => mockUser!.lastName).thenReturn('lastName');
      when(() => mockUser!.email).thenReturn('email@gmail.com');
      when(() => mockUser!.imageUrl).thenReturn('https://fake-image.com');
    });

    testWidgets(
      'renders an Error Text when UserStatus is failure',
      (tester) async {
        when(() => mockUserBloc.state)
            .thenReturn(const UserState(status: UserStatus.failure));

        await tester.pumpApp(
          BlocProvider.value(
            value: mockUserBloc,
            child: UserProfileScreen(
              bottomNavigationBar: BottomNavigationBar(
                onTap: (_) {},
                items: const [
                  BottomNavigationBarItem(
                    label: 'test1',
                    icon: Icon(Icons.verified_user),
                  ),
                  BottomNavigationBarItem(
                    label: 'test2',
                    icon: Icon(Icons.verified_user),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.byKey(
            const Key('userProfileScreen_userInfoSection_errorText'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders a CircularProgressIndicator when UserStatus is loading',
      (tester) async {
        when(() => mockUserBloc.state)
            .thenReturn(const UserState(status: UserStatus.loading));

        await tester.pumpApp(
          BlocProvider.value(
            value: mockUserBloc,
            child: UserProfileScreen(
              bottomNavigationBar: BottomNavigationBar(
                onTap: (_) {},
                items: const [
                  BottomNavigationBarItem(
                    label: 'test1',
                    icon: Icon(Icons.verified_user),
                  ),
                  BottomNavigationBarItem(
                    label: 'test2',
                    icon: Icon(Icons.verified_user),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.byKey(
            const Key('userProfileScreen_userInfoSection_loadingSpinner'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'renders an UserInfoSection when UserStatus is success',
      (tester) async {
        when(() => mockUserBloc.state).thenReturn(
          UserState(
            status: UserStatus.success,
            user: mockUser,
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockUserBloc,
            child: UserProfileScreen(
              bottomNavigationBar: BottomNavigationBar(
                onTap: (_) {},
                items: const [
                  BottomNavigationBarItem(
                    label: 'test1',
                    icon: Icon(Icons.verified_user),
                  ),
                  BottomNavigationBarItem(
                    label: 'test2',
                    icon: Icon(Icons.verified_user),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(
          find.byKey(
            const Key('userProfileScreen_userInfoSection_section'),
          ),
          findsOneWidget,
        );
      },
    );
  });
}
