import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirnih_mobile/helpers/route_helper.dart';

import 'cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthCubit _authCubit = AuthCubit();
  @override
  void initState() {
    super.initState();
    _authCubit.checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      cubit: _authCubit,
      listener: (context, state) {
        if (state is AuthInitial) {
          if (state.isLoggedIn) {
            Navigator.of(context).pushReplacementNamed(RouterHelper.kRouteHome,
                arguments: state.username);
          } else {
            Navigator.of(context).pushReplacementNamed(RouterHelper.kRouteAuth);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Text(
                    'KSBike',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                SizedBox(height: 16.0),
                Flexible(
                  flex: 1,
                  child: LinearProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
