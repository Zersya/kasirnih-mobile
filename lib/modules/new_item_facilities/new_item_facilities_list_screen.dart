part of 'new_item_facilities_screen.dart';

class NewItemFacilitiesListScreen extends StatelessWidget {
  final NewItemFacilitiesBloc bloc;
  const NewItemFacilitiesListScreen(this.bloc, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new_item_facilities_screen.list_new_item_facilities').tr(),
      ),
      body: Stack(
        children: <Widget>[
          Hero(
            tag: bloc,
            child: NewItemFacilitiesList(
              bloc: bloc,
              shrinkWrap: false,
              itemLengthFollow: true,
            ),
          ),
          _loading(context),
        ],
      ),
    );
  }

  Widget _loading(context) {
    return BlocConsumer<NewItemFacilitiesBloc, NewItemFacilitiesState>(
        cubit: bloc,
        listener: (context, state) {
          if (state is NewItemFacilitiesStateInitial) {
          } else if (state is NewItemFacilitiesStateSuccess) {
            bloc.add(NewItemFacilitiesLoad());
          }
        },
        builder: (context, state) {
          if (state is NewItemFacilitiesStateLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }
}
