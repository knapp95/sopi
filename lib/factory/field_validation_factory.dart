class FieldValidationFactory {
  static final FieldValidationFactory _singleton =
      FieldValidationFactory._internal();

  factory FieldValidationFactory() {
    return _singleton;
  }

  FieldValidationFactory._internal();

  static FieldValidationFactory get singleton => _singleton;

  String? validateFields(String? field, String input) {
    String? validateMessage;
    if (input.isEmpty) {
      validateMessage = 'Pole wymagane.';
      return validateMessage;
    }
    switch (field) {
      case 'mail':
        {
          String pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(input)) {
            validateMessage = 'Wprowdzono błędny adres e-mail.';
          }
        }
        break;
      case 'password':
        {
          String pattern =
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(input)) {
            validateMessage = 'Min. 8 znaków, znak specjalny, duża litera.';
          }
        }
        break;
      case 'confirmPassword':
        {
          ///TODO
//        if (input != _passwordController.text) {
//          return 'Podane hasła są różne!';
//        }
        }
        break;
    }
    return validateMessage;
  }
}
