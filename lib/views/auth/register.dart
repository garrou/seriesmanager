import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/styles/text.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/views/layouts/responsive_layout.dart';
import 'package:seriesmanager/widgets/button.dart';
import 'package:seriesmanager/widgets/link.dart';
import 'package:seriesmanager/widgets/textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppResponsiveLayout(
        mobileLayout: MobileLayout(),
        desktopLayout: DesktopLayout(),
      ),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 4,
      ),
      child: const MobileLayout(),
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          SvgPicture.asset(
            'assets/register_logo.svg',
            semanticsLabel: 'Logo',
            height: 150,
          ),
          Padding(
            child: Text(
              "S'inscrire",
              style: titleTextStyle,
              textAlign: TextAlign.center,
            ),
            padding: const EdgeInsets.only(top: 10),
          ),
          const RegisterForm()
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _keyForm = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              icon: Icons.alternate_email,
            ),
            AppTextField(
              keyboardType: TextInputType.text,
              label: 'Mot de passe',
              textfieldController: _password,
              validator: fieldValidator,
              obscureText: true,
              icon: Icons.password,
            ),
            AppTextField(
              keyboardType: TextInputType.text,
              label: 'Confirmer le mot de passe',
              textfieldController: _confirm,
              validator: fieldValidator,
              obscureText: true,
              icon: Icons.password,
            ),
            AppButton(
              content: 'Connexion',
              onPressed: () {},
            ),
            AppLink(
              child: Text('Déjà membre ? Se connecter', style: linkTextStyle),
              destination: const LoginPage(),
            ),
          ],
        ),
      ),
    );
  }
}
