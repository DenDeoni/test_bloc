/*class LocaleSingleton {
  LocaleSingleton._private();

  static final LocaleSingleton instance = LocaleSingleton._private();
}*/

class LocaleSingleton {
  LocaleSingleton._private();

  static final LocaleSingleton _instance = LocaleSingleton._private();

  factory LocaleSingleton() {
    return _instance;
  }
}
