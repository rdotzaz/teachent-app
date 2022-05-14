import 'package:bcrypt/bcrypt.dart';

/// Function check if password and hash retrived from database match.
bool isPasswordCorrect(String password, String hash) {
  return BCrypt.checkpw(password, hash);
}

String getHashedPassword(String password) {
  return BCrypt.hashpw(password, BCrypt.gensalt());
}
