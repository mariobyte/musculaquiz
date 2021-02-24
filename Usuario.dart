class Usuario {
  String _nome;
  String _email;
  String _senha;
  String _userId;
  String _userIdMQ;

  Usuario();

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get userIdMQ => _userIdMQ;

  set userIdMQ(String value) {
    _userIdMQ = value;
  }
}
