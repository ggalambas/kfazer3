import 'package:rxdart/rxdart.dart' show BehaviorSubject;

/// An in-memory store backed by BehaviorSubject that can be used to
/// store the data for all the fake repositories in the app
class InMemorStore<T> {
  /// The BehaviourSubject that holds the data
  final BehaviorSubject<T> _subject;
  InMemorStore(T initial) : _subject = BehaviorSubject<T>.seeded(initial);

  /// The output stream that can be used to listen to the data
  Stream<T> get stream => _subject.stream;

  /// A synchronous getter for the current value
  T get value => _subject.value;

  // A setter for updating the value
  set value(T value) => _subject.add(value);

  // Don't forget to call this when done
  void close() => _subject.close();
}
