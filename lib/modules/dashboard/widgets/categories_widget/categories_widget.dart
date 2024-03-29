part of '../../dashboard_screen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CategoriesWidgetBloc categoriesWidgetBloc =
        BlocProvider.of<CategoriesWidgetBloc>(context);

    final ItemsWidgetBloc itemsWidgetBloc =
        BlocProvider.of<ItemsWidgetBloc>(context);

    return BlocBuilder<CategoriesWidgetBloc, CategoriesWidgetState>(
      cubit: categoriesWidgetBloc,
      builder: (context, state) {
        final stream = state.props[1];

        return StreamBuilder<List<Category>>(
            stream: stream,
            initialData: [],
            builder: (context, snapshot) {
              final List<Category> categories = snapshot.data;
              final CategoryBloc categoryBloc =
                  CategoryBloc(CategoryState(categories: categories));

              if (categories.isEmpty) {
                return Center(child: Text('messages.no_data').tr());
              }
              return SizedBox(
                height: 50,
                child: BlocBuilder<CategoryBloc, CategoryState>(
                    cubit: categoryBloc,
                    builder: (context, state) {
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final element = categories[index];

                            return CategoryWidget(
                              element: element,
                              onSelected: (value) => onSelected(value, element,
                                  state, index, categoryBloc, itemsWidgetBloc),
                            );
                          });
                    }),
              );
            });
      },
    );
  }

  onSelected(bool value, Category element, CategoryState state, int index,
      CategoryBloc categoryBloc, ItemsWidgetBloc itemsWidgetBloc) {
    element.isSelected = value;
    final categories = state.categories
        .getRange(1, state.categories.length)
        .where((element) => element.isSelected)
        .toList();

    if (categories.isEmpty) {
      final element = state.categories[0]..isSelected = true;
      categoryBloc.add(element);
    } else {
      if (index == 0) {
        final newCategories = state.categories
            .getRange(1, state.categories.length)
            .map((element) {
          element.isSelected = false;
          categoryBloc.add(element);
          return element;
        }).toList();
        categoryBloc.add(element);
        return itemsWidgetBloc.add(ItemsWidgetLoad(categories: newCategories));
      } else {
        final element = state.categories[0]..isSelected = false;
        categoryBloc.add(element);
      }
    }

    itemsWidgetBloc.add(ItemsWidgetLoad(categories: categories));
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
        label: Text(element.name.capitalize()),
        selected: element.isSelected,
        onSelected: onSelected,
      ),
    );
  }
}
