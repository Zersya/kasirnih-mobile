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
              final List<Item> selectedItems = itemBloc.state.props[2];

              selectedItems.forEach((selectedItem) {
                final item = items.firstWhere(
                    (item) => (item.docId == selectedItem.docId),
                    orElse: () => null);
                if (item == null) return;
                selectedItem.totalStock = item.totalStock;

                if (item.totalStock > 0) {
                  final index = items.indexOf(item);
                  items[index].qty = selectedItem.qty;
                } else {
                  selectedItems.remove(this);
                }
              });
              itemBloc.add(ItemEvent(items: items));

              if (items.isEmpty) {
                return Expanded(
                    child: Center(child: Text('messages.no_data').tr()));
              }

              final Orientation orientation =
                  MediaQuery.of(context).orientation;

              return BlocBuilder<ItemBloc, ItemState>(
                  bloc: itemBloc,
                  builder: (context, state) {
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 3 : 4),
                        itemBuilder: (context, index) {
                          final element = items[index];

                          return ItemCard(
                            element: element,
                            onTap: () {
                              if (element.totalStock > 0) {
                                element.qty = element.qty > 0 ? 0 : 1;
                                final selectedItems = items
                                    .where((element) => element.qty > 0)
                                    .toList();
                                itemBloc.add(
                                    ItemEvent(selectedItems: selectedItems));
                              } else {
                                toastError(
                                    'Stock ${element.itemName} tidak tersedia');
                              }
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
    @required this.onTap,
  }) : super(key: key);

  final Item element;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: element.qty > 0
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 2.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (element.urlImage.isEmpty)
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[200],
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Icon(Icons.image), Text('No Image')],
                    ),
                  ),
                )
              else if (element.urlImage.isNotEmpty)
                Flexible(
                  flex: 1,
                  child: Image.network(
                    element.urlImage,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              SizedBox(height: 8.0),
              Text(element.itemName.capitalize()),
              SizedBox(height: 4.0),
              Text(
                currencyFormatter.format(element.sellPrice),
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          element.totalStock == 0 ? Colors.red : Colors.green,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
