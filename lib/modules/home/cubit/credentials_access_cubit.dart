import 'package:cubit/cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ks_bike_mobile/utils/key.dart';

part 'credentials_access_state.dart';

class CredentialsAccessCubit extends Cubit<CredentialsAccessState> {
  CredentialsAccessCubit() : super(CredentialsAccessInitial());

  void getCredentials(String key) async {
    emit(CredentialsAccessLoading(state.props[0], state.props[1],
        state.props[2], state.props[3], state.props[4], state.props[5]));

    final storage = FlutterSecureStorage();
    Map<String, String> allValues = await storage.readAll();
    emit(
      await CredentialsAccessLoaded(
        allValues[kDebtInvoice] != null,
        allValues[kAddNewItem] != null,
        allValues[kItemStock] != null,
        allValues[kPos] != null,
        allValues[kTrxReport] != null,
        allValues[kOwner] != null,
      ),
    );
  }
}
