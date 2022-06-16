import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/styles/button.dart';
import 'package:seriesmanager/utils/redirects.dart';
import 'package:seriesmanager/utils/snackbar.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/views/user/nav.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';
import 'package:seriesmanager/widgets/textfield.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _keyForm = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _onUpdatePassword,
            icon: const Icon(Icons.save_outlined, size: iconSize),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: AppResponsiveLayout(
          mobileLayout: mobileLayout(),
          desktopLayout: desktopLayout(),
        ),
      ),
    );
  }

  Widget desktopLayout() => Padding(
        child: mobileLayout(),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 4),
      );

  Widget mobileLayout() => Form(
        key: _keyForm,
        child: Column(
          children: <Widget>[
            AppTextField(
              keyboardType: TextInputType.text,
              label: 'Mot de passe actuel',
              textfieldController: _current,
              icon: const Icon(Icons.password_outlined, color: Colors.black),
              obscureText: true,
            ),
            AppTextField(
              keyboardType: TextInputType.text,
              label: 'Nouveau mot de passe',
              textfieldController: _password,
              validator: (value) => lengthValidator(value, 8, 50),
              icon: const Icon(
                Icons.password_outlined,
                color: Colors.black,
              ),
              obscureText: true,
            ),
            AppTextField(
              keyboardType: TextInputType.text,
              label: 'Confirmer le mot de passe',
              textfieldController: _confirm,
              icon: const Icon(Icons.password_outlined, color: Colors.black),
              obscureText: true,
              // ignore: body_might_complete_normally_nullable
              validator: (value) {
                if (_password.text != value || value!.isEmpty) {
                  return 'Mot de passe incorrect';
                }
              },
            ),
          ],
        ),
      );

  void _onUpdatePassword() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updatePassword();
    }
  }

  void _updatePassword() async {
    final HttpResponse response = await UserService().updatePassword(
        _current.text.trim(), _password.text.trim(), _confirm.text.trim());

    if (response.success()) {
      pushAndRemove(context, const UserNav(initial: 3));
    }
    snackBar(
      context,
      response.message(),
      response.success() ? Colors.black : Colors.red,
    );
  }
}
