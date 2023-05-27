/*abstract class BiPredicate<T, U> {
  bool test(T var1, U var2);

  BiPredicate<T, U> and(BiPredicate<T, U> other) =>
    test(other.t, other.u) && other.test(t, u);


  BiPredicate<T, U> negate() {
    return (t, u) -> {
      return !this.test(t, u);
    };
  }

  BiPredicate<T, U> or(BiPredicate<? super T, ? super U> other) {
    return (t, u) -> {
      return this.test(t, u) || other.test(t, u);
    };
  }
}
*/

typedef BiPredicate<T, U> = bool Function(T, U);
/*
bool exemploBiPredicate(int a, String b) {
  // sua lógica de verificação
  return a > int.parse(b);
}

void main() {
  BiPredicate<int, String> predicate = exemploBiPredicate;

  bool resultado = predicate(10, "5");
  print(resultado); // true
}*/