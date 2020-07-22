import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:ks_bike_mobile/modules/profile/profile_screen.dart';
import 'package:ks_bike_mobile/modules/manage_stock/list_stock/list_stock_screen.dart';
import 'package:ks_bike_mobile/modules/transaction_report/transaction_report_screen.dart';

import 'cubit/credentials_access_cubit.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen(this.username, {Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CredentialsAccessCubit _accessCubit = CredentialsAccessCubit();
  final ScreenIndexBloc _screenIndexBloc = ScreenIndexBloc(0);
  final List<Widget> _screens = [];
  final List<BottomNavigationBarItem> _bottomNav = [];

  @override
  void initState() {
    super.initState();
    _accessCubit.getCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialsAccessCubit, CredentialsAccessState>(
      cubit: _accessCubit,
      listener: _initial,
      builder: (context, state) {
        if (state is CredentialsAccessLoaded) {
          return Scaffold(
            bottomNavigationBar: _bottomNav.length <= 1
                ? null
                : BlocBuilder<ScreenIndexBloc, int>(
                    cubit: _screenIndexBloc,
                    builder: (context, state) {
                      return BottomNavigationBar(
                        selectedItemColor: Theme.of(context).primaryColor,
                        unselectedItemColor: Colors.black38,
                        currentIndex: state,
                        onTap: (index) {
                          _screenIndexBloc.add(ScreenIndexChange(index));
                        },
                        items: _bottomNav,
                      );
                    }),
            body: BlocBuilder<ScreenIndexBloc, int>(
              cubit: _screenIndexBloc,
              builder: (context, state) {
                return _screens[state];
              },
            ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  _initial(context, state) {
    _screens.clear();
    _bottomNav.clear();
    if (state is CredentialsAccessLoaded) {
      if (state.props[3] || state.props[4]) {
        _screens.add(
          BlocProvider.value(
            value: _accessCubit,
            child: DashboardScreen(widget.username),
          ),
        );
        _bottomNav.add(
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Beranda'),
          ),
        );
      }
      if (state.props[6]) {
        if (state.props[3] || state.props[2]) {
          _bottomNav.add(
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              title: Text('Stok Barang'),
            ),
          );
          _screens.add(
            ListStockScreen(),
          );
        }
      }
      if (state.props[6]) {
        if (state.props[3] || state.props[5] && state.props[6]) {
          _screens.add(
            TransactionReportScreen(),
          );
          _bottomNav.add(
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              title: Text('Lap. Transaksi'),
            ),
          );
        }
      }
      _bottomNav.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profil'),
        ),
      );

      _screens.add(
        BlocProvider.value(
          value: _accessCubit,
          child: ProfileScreen(),
        ),
      );
    }
  }
}

class ScreenIndexChange {
  final int index;

  ScreenIndexChange(this.index);
}

class ScreenIndexBloc extends Bloc<ScreenIndexChange, int> {
  ScreenIndexBloc(int initialState) : super(initialState);

  @override
  Stream<int> mapEventToState(ScreenIndexChange event) async* {
    yield event.index;
  }
}
