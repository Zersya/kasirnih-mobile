import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';
import 'package:ks_bike_mobile/utils/function.dart';
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
        BlocConsumer<DashboardBloc, DashboardState>(
            bloc: _dashboardBloc,
            listener: (context, state) {
              if (state is DashboardInitialHasStore) {
                final bool isHasStore = state.props[1];
                if (isHasStore) {
                  _dashboardBloc.add(DashboardLoadStore());
                }
              }
            },
            builder: (context, state) {
              final bool isHasStore = state.props[1];
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
    final streamCategories = _dashboardBloc.state.props[3];
    final streamItems = _dashboardBloc.state.props[2];

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _fieldSearch,
            decoration: InputDecoration(
                hintText: 'Cari Barang', suffixIcon: Icon(Icons.search)),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        StreamBuilder<List<Category>>(
            stream: streamCategories,
            initialData: [],
            builder: (context, snapshot) {
              final List<Category> categories = snapshot.data;

              if (categories.isEmpty) {
                return Center(child: Text('messages.no_data').tr());
              }
              return SizedBox(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final element = categories[index];
                      return CategoryWidget(element: element);
                    }),
              );
            }),
        StreamBuilder<List<Item>>(
            stream: streamItems,
            initialData: [],
            builder: (context, snapshot) {
              final List<Item> items = snapshot.data;

              if (items.isEmpty) {
                return Center(child: Text('messages.no_data').tr());
              }
              final Orientation orientation =
                  MediaQuery.of(context).orientation;
              return GridView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 3),
                  itemBuilder: (context, index) {
                    final element = items[index];
                    final bool stockEmpty = items[index].totalStock == 0;

                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.network(
                            element.urlImage,
                            height: 150,
                            fit: BoxFit.fitWidth,
                          ),
                          Text(element.itemName),
                          Text(
                            currencyFormatter.format(element.sellPrice),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                  color: stockEmpty ? Colors.red : Colors.green,
                                ),
                          )
                        ],
                      ),
                    );
                  });
            })
      ],
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

class CategoryWidget extends StatelessWidget {
  CategoryWidget({
    Key key,
    @required this.element,
  }) : super(key: key);

  final Category element;

  @override
  Widget build(BuildContext context) {
    final CategoryBloc _bloc = CategoryBloc(element);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<CategoryBloc, CategoryState>(
          bloc: _bloc,
          builder: (context, state) {
            Category category = state.category;

            return ChoiceChip(
              label: Text(category.name),
              selected: category.isSelected,
              onSelected: (value) {
                category.isSelected = value;
                _bloc.add(category);
              },
            );
          }),
    );
  }
}
