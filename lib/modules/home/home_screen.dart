import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/modules/dashboard/dashboard_screen.dart';
import 'package:ks_bike_mobile/modules/profile/profile_screen.dart';
import 'package:ks_bike_mobile/modules/manage_stock/list_stock/list_stock_screen.dart';
import 'package:ks_bike_mobile/modules/transaction_report/transaction_report_screen.dart';


class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen(this.username, {Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScreenIndexBloc _screenIndexBloc = ScreenIndexBloc(0);
  final _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(DashboardScreen(widget.username));
    _screens.add(ListStockScreen());
    _screens.add(TransactionReportScreen());
    _screens.add(ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<ScreenIndexBloc, int>(
          bloc: _screenIndexBloc,
          builder: (context, state) {
            return BottomNavigationBar(
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.black38,
              currentIndex: state,
              onTap: (index) {
                _screenIndexBloc.add(ScreenIndexChange(index));
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('Beranda')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_box), title: Text('Stok Barang')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.trending_up), title: Text('Lap. Transaksi')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), title: Text('Profil')),
              ],
            );
          }),
      body: BlocBuilder<ScreenIndexBloc, int>(
        bloc: _screenIndexBloc,
        builder: (context, state) {
          return _screens[state];
        },
      ),
    );
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
