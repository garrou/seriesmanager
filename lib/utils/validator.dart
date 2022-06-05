// ignore_for_file: body_might_complete_normally_nullable

String? lengthValidator(String? value, int min, int max) {
  if (value == null ||
      value.isEmpty ||
      value.length < min ||
      value.length > max) {
    return 'Nombre de caractères minimum $min, maximum $max';
  }
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty || !value.contains('@')) {
    return 'Email invalide';
  }
}

String? fieldValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Saisie invalide';
  }
}
