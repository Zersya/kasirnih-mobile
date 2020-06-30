part of '../../dashboard_screen.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ItemsWidgetBloc _bloc = BlocProvider.of<ItemsWidgetBloc>(context);
    final stream = _bloc.state.props[1];

    return StreamBuilder<List<Item>>(
        stream: stream,
        initialData: [],
        builder: (context, snapshot) {
          final List<Item> items = snapshot.data;

          if (items.isEmpty) {
            return Center(child: Text('messages.no_data').tr());
          }
          final Orientation orientation = MediaQuery.of(context).orientation;
          return GridView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 3 : 4),
              itemBuilder: (context, index) {
                final element = items[index];
                final bool stockEmpty = items[index].totalStock == 0;

                return Card(
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
                );
              });
        });
  }
}
