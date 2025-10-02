/// A simple Either type for handling success and failure cases
abstract class Either<L, R> {
  const Either();

  bool isLeft();
  bool isRight();

  L get left;
  R get right;

  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);
}

class Left<L, R> extends Either<L, R> {
  final L _value;

  const Left(this._value);

  @override
  bool isLeft() => true;

  @override
  bool isRight() => false;

  @override
  L get left => _value;

  @override
  R get right => throw Exception('Cannot get right value of Left');

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnL(_value);
}

class Right<L, R> extends Either<L, R> {
  final R _value;

  const Right(this._value);

  @override
  bool isLeft() => false;

  @override
  bool isRight() => true;

  @override
  L get left => throw Exception('Cannot get left value of Right');

  @override
  R get right => _value;

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnR(_value);
}
