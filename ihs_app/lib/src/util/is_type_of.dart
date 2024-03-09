import 'strings.dart';

bool isTypeOf<ThisType, OfType>() => _Instance<ThisType>() is _Instance<OfType>;

class _Instance<T> {
  T? me;
}

/// Returns the type of a generic (as a string)
/// e.g.
/// ```dart
/// doSomthing(1);
/// void <T> doSomething(T t){
/// String type =   typeOf<T>();
/// Log.d(type);
///  > int
/// ```
String typeOfGeneric<T>() {
  final instanceType = _Instance<T>().runtimeType.toString();

  return Strings.within(instanceType, '<', '>');
}

///
/// When passed a generic type such as
///
/// ```dart
/// State<E>
/// ```
/// This code will return
/// ```dart
/// 'State'
/// ```
/// as a string.
///
String stripGenericType(Type type) => Strings.upTo(type.toString(), '<');
