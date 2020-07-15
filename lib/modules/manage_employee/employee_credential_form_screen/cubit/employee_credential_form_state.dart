part of 'employee_credential_form_cubit.dart';

abstract class EmployeeCredentialFormState extends Equatable {
  final propss;

  const EmployeeCredentialFormState({this.propss});

  int incrementV() {
    int version = propss[0];
    version++;
    return version;
  }

  @override
  List<Object> get props => propss;
}

class EmployeeCredentialFormInitial extends EmployeeCredentialFormState {
  final int version;
  final List<Credential> listCredential;

  EmployeeCredentialFormInitial({
    this.version = 0,
    this.listCredential = const [],
  }) : super(propss: [version, listCredential]);
}

class EmployeeCredentialFormLoading extends EmployeeCredentialFormState {
  final int version;
  final List<Credential> listCredential;

  EmployeeCredentialFormLoading(
    this.version,
    this.listCredential,
  ) : super(propss: [version, listCredential]);
}

class EmployeeCredentialFormSuccess extends EmployeeCredentialFormState {
  final int version;
  final List<Credential> listCredential;

  EmployeeCredentialFormSuccess(
    this.version,
    this.listCredential,
  ) : super(propss: [version, listCredential]);
}
