/// [TODO] NEED TO USE CRYPTOGRAPHY PACKAGE
///
/// Function check if password and hash retrived from database match.
bool isPasswordCorrect(String password, Object hash) {
  return password == (hash as String);
}
