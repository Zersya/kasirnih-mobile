import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ks_bike_mobile/helpers/route_helper.dart';
import 'package:ks_bike_mobile/widgets/custom_loading.dart';
import 'package:ks_bike_mobile/widgets/custom_text_field.dart';
import 'package:ks_bike_mobile/widgets/raised_button_gradient.dart';
import 'package:easy_localization/easy_localization.dart';

import 'bloc/auth_bloc.dart';

part 'widgets/login_widget.dart';
part 'widgets/register_widget.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  final TextEditingController usernameLoginC = TextEditingController();
  final TextEditingController passwordLoginC = TextEditingController();

  final TextEditingController usernameRegisterC = TextEditingController();
  final TextEditingController passwordRegisterC = TextEditingController();

  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();

  final FocusNode usernameLoginNode = FocusNode();
  final FocusNode passwordLoginNode = FocusNode();
  final FocusNode usernameRegisterNode = FocusNode();
  final FocusNode passwordRegisterNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formLoginKey = GlobalKey<FormState>();
  final formRegistKey = GlobalKey<FormState>();

  final AuthBloc authBloc = AuthBloc(AuthInitial());

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    if (kDebugMode) {
      usernameLoginC.text = 'misha';
      passwordLoginC.text = '123456';
      usernameRegisterC.text = 'abidin';
      passwordRegisterC.text = '1234567';
      emailC.text = "abidin@mail.com";
      phoneC.text = "1234567";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          _body(context),
          _loading(context),
        ],
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacementNamed(RouterHelper.kRouteHome,
                arguments: usernameLoginC.text);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoading();
          } else {
            return SizedBox();
          }
        });
  }

  SingleChildScrollView _body(BuildContext context) {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 880),
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(
            children: <Widget>[
              SafeArea(
                child: Container(
                  padding: EdgeInsets.all(21.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(
                    'KS',
                    style: GoogleFonts.roboto(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TabBar(
                controller: tabController,
                labelPadding: EdgeInsets.symmetric(vertical: 8),
                tabs: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(color: Colors.black87),
                  ),
                  Text(
                    'Register',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              Expanded(
                child: BlocProvider(
                  create: (context) => authBloc,
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      LoginWidget(
                        formKey: formLoginKey,
                        usernameNode: usernameLoginNode,
                        usernameC: usernameLoginC,
                        passwordNode: passwordLoginNode,
                        passwordC: passwordLoginC,
                      ),
                      RegisterWidget(
                        formKey: formRegistKey,
                        usernameNode: usernameRegisterNode,
                        usernameC: usernameRegisterC,
                        passwordNode: passwordRegisterNode,
                        passwordC: passwordRegisterC,
                        emailC: emailC,
                        emailNode: emailNode,
                        phoneC: phoneC,
                        phoneNode: phoneNode,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
