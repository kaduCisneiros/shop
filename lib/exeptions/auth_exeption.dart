class AuthExeption implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado!',
    'OPERATION_NOT_ALLOWED': 'Login não disponível para o APP!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Excedeu o número de tentativas para logar!',
    'EMAIL_NOT_FOUND': 'E-mail não cadastrado!',
    'INVALID_PASSWORD': 'Senha Inválida!',
    'USER_DISABLED': 'Usuáio desabilidado!',
  };
  final String key;

  const AuthExeption(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return 'Ocorreu um erro na Autenticação!';
    }
  }
}
