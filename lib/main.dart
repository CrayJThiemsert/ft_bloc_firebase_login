import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ft_bloc_firebase_login/authentication_bloc/authentication_bloc.dart';
import 'package:ft_bloc_firebase_login/login/login_screen.dart';
import 'package:ft_bloc_firebase_login/simple_bloc_observer.dart';
import 'package:ft_bloc_firebase_login/splash_screen.dart';
import 'package:ft_bloc_firebase_login/user_repository.dart';

import 'home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AuthenticationStarted()),
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;


  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        top: true,
        bottom: true,
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if(state is AuthenticationInitial) {
              return SplashScreen();
            }
            if(state is AuthenticationFailure) {
              return LoginScreen(userRepository: _userRepository);
            }
            if(state is AuthenticationSuccess) {
              return HomeScreen(name: state.displayName);
            }
            return Container();
          },
        ),
      ),
    );
  }
}


