import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  DashboardScreen(this.username, {Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardBloc _dashboardBloc = DashboardBloc();
  final TextEditingController _fieldSearch = TextEditingController();
  @override
  void initState() {
    super.initState();
    _dashboardBloc.add(DashboardHasStore());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Text('dashboard_screen.hi',
                  style: Theme.of(context).textTheme.headline6)
              .tr(args: [widget.username.capitalize()]),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        BlocBuilder<DashboardBloc, DashboardState>(
            bloc: _dashboardBloc,
            builder: (context, state) {
              final bool isHasStore = state.props[0];
              if (state is DashboardLoading) {
                return CustomLoading(withBackground: false);
              } else if (isHasStore) {
                return _bodyHasStore(context);
              }

              return Expanded(child: _bodyEmptyStore(context));
            }),
      ],
    );
  }

  Widget _bodyHasStore(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _fieldSearch,
            decoration: InputDecoration(
                hintText: 'Cari Barang', suffixIcon: Icon(Icons.search)),
          ),
          SizedBox(height: 16.0,),
          ChoiceChip(label: Text('test'), selected: true)
        ],
      ),
    );
  }

  Column _bodyEmptyStore(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width - 64,
            height: MediaQuery.of(context).size.width - 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              color: Color(0xFFfbfbfb),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: Color(0xFFf8f8f8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'dashboard_screen.no_profile_store',
                    style: Theme.of(context).textTheme.subtitle1,
                  ).tr(),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context)
                          .pushNamed(RouterHelper.kRouteStoreFormState);
                      _dashboardBloc.add(DashboardHasStore());
                    },
                    child: Text(
                      'dashboard_screen.register_your_store',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: Color(0xFF035AA6),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                    ).tr(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
