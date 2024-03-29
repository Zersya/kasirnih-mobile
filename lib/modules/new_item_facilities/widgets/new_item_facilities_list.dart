part of '../new_item_facilities_screen.dart';

class NewItemFacilitiesList extends StatelessWidget {
  const NewItemFacilitiesList({
    Key key,
    @required NewItemFacilitiesBloc bloc,
    this.shrinkWrap = true,
    this.itemLengthFollow = false,
  })  : _bloc = bloc,
        super(key: key);

  final NewItemFacilitiesBloc _bloc;
  final bool shrinkWrap;
  final bool itemLengthFollow;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<NewItemFacilitiesBloc, NewItemFacilitiesState>(
          cubit: _bloc,
          builder: (context, state) {
            final List<NewItemFacilities> listItem = state.props[1];
            if (listItem.isEmpty) {
              return Center(
                  child:
                      Text('new_item_facilities_screen.no_list_bought').tr());
            }
            return ListView.builder(
                shrinkWrap: shrinkWrap,
                physics: ScrollPhysics(),
                itemCount: itemLengthFollow
                    ? listItem.length
                    : listItem.length > 10 ? 10 : listItem.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => onTap(listItem[index]),
                    leading: Checkbox(
                      value: listItem[index].isBought,
                      onChanged: (value) => onTap(listItem[index]),
                    ),
                    title: Text(listItem[index].name.capitalize()),
                  );
                });
          }),
    );
  }

  void onTap(NewItemFacilities oldItem) {
    final item = oldItem;
    item.isBought = !oldItem.isBought;
    _bloc.add(NewItemFacilitiesChangeValue(item));
  }
}
