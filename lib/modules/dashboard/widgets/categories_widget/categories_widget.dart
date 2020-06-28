part of '../../dashboard_screen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoriesWidgetBloc categoriesWidgetBloc =
        BlocProvider.of<CategoriesWidgetBloc>(context);

    final stream = categoriesWidgetBloc.state.props[1];

    final ItemsWidgetBloc itemsWidgetBloc =
        BlocProvider.of<ItemsWidgetBloc>(context);

    return StreamBuilder<List<Category>>(
        stream: stream,
        initialData: [],
        builder: (context, snapshot) {
          final List<Category> categories = snapshot.data;
          final CategoryBloc categoryBloc = CategoryBloc(categories);

          if (categories.isEmpty) {
            return Center(child: Text('messages.no_data').tr());
          }
          return SizedBox(
            height: 50,
            child: BlocConsumer<CategoryBloc, CategoryState>(
                bloc: categoryBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  final categories = state.categories;
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final element = categories[index];

                        return CategoryWidget(
                          element: element,
                          onSelected: (value) {
                            element.isSelected = value;
                            final categories = state.categories
                                .getRange(1, state.categories.length - 1)
                                .where((element) => element.isSelected)
                                .toList();

                            if (categories.isEmpty) {
                              final element = state.categories[0]
                                ..isSelected = true;
                              categoryBloc.add(element);
                            } else {
                              final element = state.categories[0]
                                ..isSelected = false;
                              categoryBloc.add(element);
                            }

                            itemsWidgetBloc
                                .add(ItemsWidgetLoad(categories: categories));
                          },
                        );
                      });
                }),
          );
        });
  }
}

class CategoryWidget extends StatelessWidget {
  CategoryWidget({
    Key key,
    @required this.element,
    @required this.onSelected,
  }) : super(key: key);

  final Category element;
  final Function(bool) onSelected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChoiceChip(
        label: Text(element.name),
        selected: element.isSelected,
        onSelected: onSelected,
      ),
    );
  }
}
