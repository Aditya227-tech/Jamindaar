extension MapIndexed on Iterable<dynamic> {
  Iterable<U> mapIndexed<T, U>(U Function(T e, int i) f) {
    var i = 0;
    return map<U>((it) {
      final t = i;
      i++;
      return f(it as T, t);
    });
  }
}
