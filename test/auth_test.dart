import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

const validEmail = "foo@bar.com";
const validPassword = "foobar";
void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();

    test("Should Not Be Initialized At Start", () {
      expect(provider.isInitialized, false);
    });

    group("Actions while initialized is false", () {
      test("Cannot Log out", () {
        expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      });

      test("Cannot log in", () {
        const email = validEmail;
        const password = validPassword;
        expect(
          provider.login(email: email, password: password),
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      });
      test("Cannot create user", () {
        final validUser =
            provider.createUser(email: validEmail, password: validPassword);
        expect(
          validUser,
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      });

      test("Cannot send email Verification", () {
        expect(
          provider.sendEmailVerification(),
          throwsA(const TypeMatcher<NotInitializedException>()),
        );
      });
    });

    test("Should able to Initialize", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("User is null after initialization",
        () => expect(provider.currentUser, null));

    test(
      "Should be able to initialize in less than 2 seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    group("Login Tests", () {
      test("Can't login with invalid email address", () {
        final badEmailUser = provider.login(
            email: "badEmail@email.com", password: validPassword);
        expect(
          badEmailUser,
          throwsA(const TypeMatcher<InvalidLoginAuthException>()),
        );
      });

      test("Can't login with invalid password", () {
        final badPasswordUser =
            provider.login(email: validEmail, password: "badPass");
        expect(
          badPasswordUser,
          throwsA(const TypeMatcher<InvalidLoginAuthException>()),
        );
      });

      test("Can login with valid credentials", () async {
        final user = await provider.createUser(
            email: validEmail, password: validPassword);
        expect(provider.currentUser, user);
      });
    });
    test("Create user should delegate to login Function", () async {
      final badEmailUser = provider.createUser(
          email: "email@email.com", password: validPassword);
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<InvalidLoginAuthException>()),
      );
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;

  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
    _user = null;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email != validEmail) throw InvalidLoginAuthException();
    if (password != validPassword) throw InvalidLoginAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
    throw UnimplementedError();
  }
}
