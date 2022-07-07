import 'package:flutter/material.dart';
import 'package:seriesmanager/models/http_response.dart';
import 'package:seriesmanager/models/user_profile.dart';
import 'package:seriesmanager/services/user_service.dart';
import 'package:seriesmanager/widgets/snackbar.dart';
import 'package:seriesmanager/utils/validator.dart';
import 'package:seriesmanager/widgets/responsive_layout.dart';
import 'package:seriesmanager/widgets/textfield.dart';

class UpdateProfile extends StatefulWidget {
  final UserProfile profile;
  const UpdateProfile({Key? key, required this.profile}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _keyForm = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _username;

  @override
  void initState() {
    _email = TextEditingController(text: widget.profile.email);
    _username = TextEditingController(text: widget.profile.username);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onUpdateProfile,
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          child: Icon(
            Icons.save_outlined,
            color: Theme.of(context).backgroundColor,
          ),
        ),
        body: AppResponsiveLayout(
          mobileLayout: mobileLayout(),
          desktopLayout: desktopLayout(),
        ),
      );

  Widget desktopLayout() => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4,
        ),
        child: mobileLayout(),
      );

  Widget mobileLayout() => Form(
        key: _keyForm,
        child: Column(
          children: <Widget>[
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
              keyboardType: TextInputType.emailAddress,
              label: 'Email',
              textfieldController: _email,
              validator: emailValidator,
              icon: Icon(
                Icons.alternate_email_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      );

  void _onUpdateProfile() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateProfile();
    }
  }

  void _updateProfile() async {
    final HttpResponse response = await UserService()
        .updateProfile(_username.text.trim(), _email.text.trim());

    if (response.success()) {
      Navigator.pop(context);
    }
    snackBar(context, response.message());
  }
}
