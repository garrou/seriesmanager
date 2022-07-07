import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_register.dart';
import 'package:seriesmanager/services/auth_service.dart';
import 'package:seriesmanager/styles/styles.dart';
import 'package:seriesmanager/widgets/snackbar.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/views/auth/login.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';
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
  Widget build(BuildContext context) => const Scaffold(
        body: SingleChildScrollView(
          child: AppResponsiveLayout(
            mobileLayout: MobileLayout(),
            desktopLayout: DesktopLayout(),
          ),
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
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            SvgPicture.asset(
              'assets/register.svg',
              semanticsLabel: 'Logo',
              height: 200,
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

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _keyForm = GlobalKey<FormState>();

  final _email = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

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
                icon: Icon(
                  Icons.alternate_email_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              AppTextField(
                keyboardType: TextInputType.text,
                label: "Nom d'utilisateur",
                textfieldController: _username,
                validator: (value) => lengthValidator(value, 3, 50),
                icon: Icon(
                  Icons.person_outline,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              AppTextField(
                keyboardType: TextInputType.text,
                label: 'Mot de passe',
                textfieldController: _password,
                validator: (value) => lengthValidator(value, 8, 50),
                obscureText: true,
                icon: Icon(
                  Icons.password_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              AppTextField(
                keyboardType: TextInputType.text,
                label: 'Confirmer le mot de passe',
                textfieldController: _confirm,
                // ignore: body_might_complete_normally_nullable
                validator: (value) {
                  if (_password.text != value || value!.isEmpty) {
                    return 'Mot de passe incorrect';
                  }
                },
                obscureText: true,
                icon: Icon(
                  Icons.password_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              AppButton(
                content: "S'inscrire",
                onPressed: _onRegister,
              ),
              AppLink(
                child: Text('Déjà membre ? Se connecter', style: linkTextStyle),
                destination: const LoginPage(),
              ),
            ],
          ),
        ),
      );

  void _onRegister() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _register();
    }
  }

  void _register() async {
    HttpResponse response = await AuthService().register(UserRegister(
        _email.text, _username.text, _password.text, _confirm.text));

    if (response.success()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    }
    snackBar(context, response.message());
  }
}
