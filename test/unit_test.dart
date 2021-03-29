import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire_template/services/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final Auth auth = Auth(auth: mockFirebaseAuth);

  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });
  test("create account", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "test@gmail.com", password: "12345678"))
        .thenAnswer((realInvocation) => null);

    expect(
        await auth.createAccount(email: "test@gmail.com", password: "12345678"),
        "Success");
  });
  test("create account exception", () async {
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "test@gmail.com", password: "12345678"))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(
            code: "you_screwed_up", message: "You screwed up"));

    expect(
        await auth.createAccount(email: "test@gmail.com", password: "12345678"),
        "You screwed up");
  });

  test("sign in", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "test@gmail.com", password: "12345678"))
        .thenAnswer((realInvocation) => null);

    expect(await auth.signIn(email: "test@gmail.com", password: "12345678"),
        "Success");
  });
  test("sign in exception", () async {
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: "test@gmail.com", password: "12345678"))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(
            code: "you_screwed_up", message: "You screwed up"));

    expect(await auth.signIn(email: "test@gmail.com", password: "12345678"),
        "You screwed up");
  });
  test("sign out", () async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => null);

    expect(await auth.signOut(), "Success");
  });
}
