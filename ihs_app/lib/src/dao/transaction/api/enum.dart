abstract class Enum<T> {

  const Enum(this._value);
  final T _value;

  T get value => _value;

  String toJson() => _value.toString();
}
