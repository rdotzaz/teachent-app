/// [TODO] NEED TO USE CRYPTOGRAPHY PACKAGE 
bool isPasswordCorrect(String password, Object hash) {
  return password == (hash as String);
}
