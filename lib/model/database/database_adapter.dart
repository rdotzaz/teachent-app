import 'database.dart';

abstract class BaseDatabaseAdapter {
  void init(DBMode dbMode);
  void clear();
}
