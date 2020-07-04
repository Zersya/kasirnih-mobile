import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/models/item.dart';
import 'package:ks_bike_mobile/models/transaction.dart';
import 'package:ks_bike_mobile/modules/manage_stock/list_stock/bloc/list_stock_bloc.dart';
import 'package:ks_bike_mobile/utils/function.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ks_bike_mobile/utils/extensions/string_extension.dart';

class ListStockScreen extends StatefulWidget {
  ListStockScreen({Key key}) : super(key: key);

  @override
  _ListStockScreenState createState() => _ListStockScreenState();
}

class _ListStockScreenState extends State<ListStockScreen>
    with TickerProviderStateMixin {
  final TextEditingController _fieldSearch = TextEditingController();
  final ListStockBloc _bloc = ListStockBloc(ListStockInitial());
  PersistentBottomSheetController bottomSheetController;

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, vsync: this, length: 3);
    _bloc.add(ListStockLoad(0));

    _tabController.addListener(() {
      _bloc.add(ListStockLoad(_tabController.index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('list_stock_screen.list_stock_item').tr(),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFf1f1f2),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextField(
                            controller: _fieldSearch,
                            onTap: () {
                              if (bottomSheetController != null) {
                                bottomSheetController.close();
                                bottomSheetController = null;
                              }
                            },
                            onSubmitted: (value) {
                              _bloc.add(ListStockSearch(value));
                              bottomSheetController =
                                  buildShowBottomSheet(context);
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
                      Flexible(
                        flex: 1,
                        child: FlatButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(RouterHelper.kRouteStockForm);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFF8E8E93),
                  tabs: <Widget>[
                    Tab(text: tr('list_stock_screen.available')),
                    Tab(text: tr('list_stock_screen.sold_today')),
                    Tab(text: tr('list_stock_screen.not_available'))
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                BlocConsumer<ListStockBloc, ListStockState>(
                    bloc: _bloc,
                    listener: (context, state) {},
                    builder: (context, state) {
                      final streamItems = state.props[1];

                      return ListItems(streamItems: streamItems);
                    }),
                BlocConsumer<ListStockBloc, ListStockState>(
                    bloc: _bloc,
                    listener: (context, state) {},
                    builder: (context, state) {
                      final streamItems = state.props[2];

                      return ListItems(
                          streamItems: streamItems, isSoldToday: true);
                    }),
                BlocConsumer<ListStockBloc, ListStockState>(
                    bloc: _bloc,
                    listener: (context, state) {},
                    builder: (context, state) {
                      final streamItems = state.props[3];

                      return ListItems(streamItems: streamItems);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  PersistentBottomSheetController buildShowBottomSheet(BuildContext context) {
    return showBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: BlocConsumer<ListStockBloc, ListStockState>(
                bloc: _bloc,
                listener: (context, state) {},
                builder: (context, state) {
                  final streamItems = state.props[4];

                  return ListItems(streamItems: streamItems);
                }),
          );
        });
  }
}

class ListItems extends StatelessWidget {
  const ListItems({
    Key key,
    @required this.streamItems,
    this.isSoldToday = false,
  }) : super(key: key);

  final Object streamItems;
  final bool isSoldToday;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
        stream: streamItems,
        initialData: [],
        builder: (context, snapshot) {
          final List<Item> items = snapshot.data;

          if (items.isEmpty) {
            return Center(child: Text('messages.no_data').tr());
          }
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final bool stockEmpty = items[index].totalStock == 0;
                return InkWell(
                  onTap: () {
                    buildShowDialog(context, items[index]);
                  },
                  child: Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: items[index].urlImage,
                          fit: BoxFit.fitWidth,
                          width: 150,
                          height: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(items[index].itemName.capitalize(),
                                  style: Theme.of(context).textTheme.subtitle1),
                              SizedBox(height: 16.0),
                              if (isSoldToday)
                                Text(
                                    'Terjual Hari ini : ${items[index].soldToday}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey)),
                              if (!isSoldToday)
                                Text(
                                  stockEmpty
                                      ? tr(
                                          'list_stock_screen.item_not_available')
                                      : '${tr('list_stock_screen.stock_available')} ${items[index].totalStock}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: stockEmpty
                                              ? Colors.red
                                              : Colors.grey),
                                ),
                              SizedBox(height: 4.0),
                              Text(
                                '${currencyFormatter.format(items[index].sellPrice)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: Colors.green),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Future buildShowDialog(BuildContext context, Item item) {
    return showDialog(
        context: context,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'list_stock_screen.detail_item',
                      style: Theme.of(context).textTheme.subtitle1,
                    ).tr(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                ),
                Divider(height: 16.0),
                Text(
                  '${tr('list_stock_screen.buy_price')} : ${currencyFormatter.format(item.buyPrice)}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 4.0),
                Text(
                  '${tr('list_stock_screen.category')} : ${item.categoryName}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 4.0),
                Text(
                  '${tr('list_stock_screen.supplier')} : ${item.supplierName}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
        ));
  }
}
