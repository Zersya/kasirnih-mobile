part of '../../dashboard_screen.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemsWidgetBloc itemsWidgetBloc =
        BlocProvider.of<ItemsWidgetBloc>(context);
    final ItemBloc itemBloc = BlocProvider.of<ItemBloc>(context);

    return BlocBuilder<ItemsWidgetBloc, ItemsWidgetState>(
      bloc: itemsWidgetBloc,
      builder: (context, state) {
        final stream = itemsWidgetBloc.state.props[1];
        return StreamBuilder<List<Item>>(
            stream: stream,
            initialData: [],
            builder: (context, snapshot) {
              final List<Item> items = snapshot.data;
              itemBloc.add(ItemEvent(items));

              if (items.isEmpty) {
                return Expanded(
                    child: Center(child: Text('messages.no_data').tr()));
              }

              final Orientation orientation =
                  MediaQuery.of(context).orientation;

              return BlocBuilder<ItemBloc, ItemState>(
                  bloc: itemBloc,
                  builder: (context, state) {
                    final items = state.items;
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 3 : 4),
                        itemBuilder: (context, index) {
                          final element = items[index];
                          final bool stockEmpty = items[index].totalStock == 0;

                          return ItemCard(
                            element: element,
                            stockEmpty: stockEmpty,
                            onTap: () {
                              element.isSelected = !element.isSelected;
                              itemBloc.add(ItemEvent(items));
                            },
                          );
                        });
                  });
            });
      },
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.element,
    @required this.stockEmpty,
    @required this.onTap,
  }) : super(key: key);

  final Item element;
  final bool stockEmpty;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: element.isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 2.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Image.network(
                  element.urlImage,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Text(element.itemName.capitalize()),
              Text(
                currencyFormatter.format(element.sellPrice),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: stockEmpty ? Colors.red : Colors.green,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
