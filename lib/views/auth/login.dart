import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/auth_service.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/storage.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/views/auth/register.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';
import 'package:seriesmanager/views/user/home.dart';
import 'package:seriesmanager/widgets/button.dart';
import 'package:seriesmanager/widgets/link.dart';
import 'package:seriesmanager/widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: AppResponsiveLayout(
          mobileLayout: MobileLayout(),
          desktopLayout: DesktopLayout(),
        ),
      );
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
        ),
        child: const MobileLayout(),
      );
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView(
          children: <Widget>[
            SvgPicture.asset(
              'assets/login_logo.svg',
              semanticsLabel: 'Logo',
              height: 150,
            ),
            Padding(
              child: Text(
                'Se connecter',
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
              padding: const EdgeInsets.only(top: 10),
            ),
            const LoginForm()
          ],
        ),
      );
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _keyForm = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppTextField(
                keyboardType: TextInputType.emailAddress,
                label: 'Email',
                textfieldController: _email,
                validator: emailValidator,
                icon: const Icon(Icons.alternate_email_outlined,
                    color: Colors.black),
              ),
              AppTextField(
                keyboardType: TextInputType.text,
                label: 'Mot de passe',
                textfieldController: _password,
                validator: fieldValidator,
                obscureText: true,
                icon: const Icon(Icons.password_outlined, color: Colors.black),
              ),
              AppButton(
                content: 'Connexion',
                onPressed: _onLogin,
              ),
              AppLink(
                child: Text('Nouveau ? Créer un compte', style: linkTextStyle),
                destination: const RegisterPage(),
              ),
            ],
          ),
        ),
      );

  void _onLogin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _login();
    }
  }

  void _login() async {
    final HttpResponse response =
        await AuthService().login(_email.text.trim(), _password.text.trim());

    if (response.success()) {
      Storage.setToken(response.content());
      pushAndRemove(context, const UserHomePage());
    }
  }
}
