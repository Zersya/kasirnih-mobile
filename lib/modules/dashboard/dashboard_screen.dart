import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/category.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ks_bike_mobile/modules/dashboard/widgets/items_widget/bloc/items_widget_bloc.dart';

import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';
import 'package:ks_bike_mobile/utils/function.dart';
import 'package:ks_bike_mobile/utils/toast.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'widgets/categories_widget/bloc/categories_widget_bloc.dart';

part 'widgets/categories_widget/categories_widget.dart';
part 'widgets/items_widget/items_widget.dart';

class DashboardScreen extends StatefulWidget {
  final String username;
  DashboardScreen(this.username, {Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardBloc _dashboardBloc = DashboardBloc(DashboardInitial());
  final CategoriesWidgetBloc _categoriesWidgetBloc =
      CategoriesWidgetBloc(CategoriesWidgetInitial());
  final ItemsWidgetBloc _itemsWidgetBloc =
      ItemsWidgetBloc(ItemsWidgetInitial());
  final ItemBloc _itemBloc = ItemBloc(ItemState());

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
              if (state is DashboardInitial) {
                final bool isHasStore = state.props[1];
                if (isHasStore) {
                  _categoriesWidgetBloc.add(CategoriesWidgetLoad());
                  _itemsWidgetBloc.add(ItemsWidgetLoad());
                }
              }
            },
            builder: (context, state) {
              final bool isHasStore = state.props[1];
              if (state is DashboardLoading) {
                return Expanded(child: CustomLoading(withBackground: false));
              } else if (isHasStore) {
                return _bodyHasStore(context);
              }

              return Expanded(child: _bodyEmptyStore(context));
            }),
      ],
    );
  }

  Widget _bodyHasStore(BuildContext context) {
    return Expanded(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFf1f1f2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextField(
                    controller: _fieldSearch,
                    onTap: () {},
                    onSubmitted: (value) {
                      _itemsWidgetBloc
                          .add(ItemsWidgetSearch(value.toLowerCase()));
                    },
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: tr('list_stock_screen.search_item'),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            _fieldSearch.clear();
                          },
                          child: Icon(Icons.close)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _categoriesWidgetBloc),
                  BlocProvider.value(value: _itemsWidgetBloc),
                ],
                child: CategoriesWidget(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Align(
                    child: BlocBuilder<ItemBloc, ItemState>(
                  bloc: _itemBloc,
                  builder: (context, state) {
                    return ToggleSwitch(
                      minWidth: 50.0,
                      minHeight: 40.0,
                      initialLabelIndex: state.props[3],
                      cornerRadius: 20.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      labels: ['', ''],
                      icons: [
                        Icons.grid_on,
                        Icons.list,
                      ],
                      iconSize: 21.0,
                      activeBgColors: [Colors.pink, Colors.purple],
                      onToggle: (index) {
                        _itemBloc.add(ItemEvent(selectedList: index));
                      },
                      activeBgColor: Theme.of(context).backgroundColor,
                    );
                  },
                )),
              ),
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _itemsWidgetBloc),
                  BlocProvider.value(value: _itemBloc)
                ],
                child: ItemsWidget(),
              )
            ],
          ),
          BlocBuilder<ItemBloc, ItemState>(
              bloc: _itemBloc,
              builder: (context, state) {
                final List<Item> selectedItems = state.props[2];
                final List<Item> availableItems = selectedItems
                    .where((element) => element.totalStock > 0)
                    .toList();
                final isAnySelected =
                    availableItems.any((element) => element.qty > 0);

                final total = _getSumSelected(availableItems);

                return AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  bottom: isAnySelected ? 0 : -50,
                  left: 50,
                  right: 50,
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 21.0),
                    decoration:
                        BoxDecoration(color: Theme.of(context).accentColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            await Navigator.of(context).pushNamed(
                                RouterHelper.kRouteSummary,
                                arguments: _itemBloc.state.props[2]);
                            _itemBloc.add(ItemEvent(selectedItems: []));
                          },
                          child: Text('Bayar'),
                          textColor: Colors.white,
                        ),
                        Text(
                          currencyFormatter.format(total),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                );
              }),
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

  double _getSumSelected(List<Item> selectedItems) {
    return selectedItems.where((element) => element.qty > 0).fold(
        0.0, (previousValue, element) => previousValue += element.sellPrice);
  }
}
