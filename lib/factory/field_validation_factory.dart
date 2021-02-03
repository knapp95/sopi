
class FieldValidationFactory {
  static final FieldValidationFactory _singleton =
      FieldValidationFactory._internal();

  /// Factory daje nam pewność że obiekt singleton zostanie utworzony tylko raz,
  factory FieldValidationFactory() {
    return _singleton;
  }

  FieldValidationFactory._internal();

  static FieldValidationFactory get singleton => _singleton;

  /// Walidacja pól (mail, hasło) przy logowaniu
  String validateFields(String field, String input) {
    String validateMessage;
    if (input == null || input.isEmpty) {
      validateMessage = 'Pole wymagane.';
      return validateMessage;
    }
    switch (field) {
      case 'mail':
        {
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(input)) {
            validateMessage = 'Wprowdzono błędny adres e-mail.';
          }
        }
        break;
      case 'password':
        {
          Pattern pattern =
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
