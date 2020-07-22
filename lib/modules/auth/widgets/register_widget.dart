part of '../auth_screen.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget(
      {Key key,
      @required this.usernameNode,
      @required this.usernameC,
      @required this.passwordNode,
      @required this.passwordC,
      @required this.emailNode,
      @required this.emailC,
      @required this.phoneNode,
      @required this.phoneC,
      @required this.formKey})
      : super(key: key);

  final FocusNode usernameNode;
  final TextEditingController usernameC;
  final FocusNode passwordNode;
  final TextEditingController passwordC;
  final FocusNode emailNode;
  final TextEditingController emailC;
  final FocusNode phoneNode;
  final TextEditingController phoneC;

  final formKey;

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'auth_screen.welcome',
              style: Theme.of(context).textTheme.headline5,
            ).tr(),
            Text(
              'auth_screen.register_desc',
              style: Theme.of(context).textTheme.bodyText1,
            ).tr(),
            SizedBox(
              height: 32.0,
            ),
            CustomTextField(
              label: 'Username',
              node: usernameNode,
              controller: usernameC,
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              label: 'Email',
              node: emailNode,
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              label: 'Phone',
              node: phoneNode,
              controller: phoneC,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10.0,
            ),
            BlocBuilder<AuthBloc, AuthState>(
                cubit: authBloc,
                builder: (context, state) {
                  return CustomTextField(
                    label: 'Password',
                    node: passwordNode,
                    controller: passwordC,
                    isObsecure: !state.props[1],
                    onVisibleTap: () =>
                        {authBloc.add(AuthEventTriggerPasswordRegister())},
                  );
                }),
            SizedBox(
              height: 27.0,
            ),
            RaisedButtonGradient(
                width: double.infinity,
                height: 43,
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  'Register',
                  style: Theme.of(context).textTheme.button,
                ),
                gradient: LinearGradient(
                  colors: <Color>[
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                onPressed: () {
                  if (formKey.currentState.validate()) {
                    FocusScope.of(context).unfocus();
                    authBloc.add(AuthEventRegister(usernameC.text, emailC.text,
                        phoneC.text, passwordC.text));
                  }
                }),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
