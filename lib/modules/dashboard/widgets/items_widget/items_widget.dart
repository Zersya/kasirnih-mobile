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
                    if (state.props[3] == 1) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final element = items[index];

                          return ItemListCard(
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
                        },
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 3 : 4),
                        itemBuilder: (context, index) {
                          final element = items[index];

                          return ItemGridCard(
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

class ItemGridCard extends StatelessWidget {
  const ItemGridCard({
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
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: element.urlImage,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemListCard extends StatelessWidget {
  const ItemListCard({
    Key key,
    @required this.element,
    @required this.onTap,
  }) : super(key: key);

  final Item element;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: element.qty > 0
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2.0),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(element.itemName.capitalize()),
        subtitle: Text(
          currencyFormatter.format(element.sellPrice),
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: element.totalStock == 0 ? Colors.red : Colors.green,
              ),
        ),
        leading: element.urlImage.isEmpty
            ? Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.image), Text('No Image')],
                ),
              )
            : CachedNetworkImage(
                imageUrl: element.urlImage,
                fit: BoxFit.fitWidth,
              ),
      ),
    );
  }
}
