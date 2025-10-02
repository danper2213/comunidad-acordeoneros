import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:comunidad_acordeoneros/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Stream<UserModel?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('No se pudo obtener el usuario');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('No se pudo crear el usuario');
      }

      // Actualizar el displayName del usuario
      await userCredential.user!.updateDisplayName(displayName);
      await userCredential.user!.reload();
      final updatedUser = firebaseAuth.currentUser;

      if (updatedUser == null) {
        throw Exception('No se pudo obtener el usuario actualizado');
      }

      return UserModel.fromFirebaseUser(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Inicio de sesión cancelado');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('No se pudo obtener el usuario');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Cerrar sesión de Firebase Auth
      await firebaseAuth.signOut();

      // Cerrar sesión de Google solo si hay una sesión activa
      // Esto previene errores cuando el usuario no usó Google Sign In
      try {
        await googleSignIn.signOut();
      } catch (e) {
        // Ignorar error si no hay sesión de Google activa
        // Esto es esperado cuando el usuario usó email/password
      }
    } catch (e) {
      throw Exception('Error al cerrar sesión: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw Exception('Error al obtener el usuario actual: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'email-already-in-use':
        return 'Este correo electrónico ya está en uso';
      case 'invalid-email':
        return 'El correo electrónico no es válido';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'user-disabled':
        return 'Este usuario ha sido deshabilitado';
      case 'user-not-found':
        return 'No se encontró ningún usuario con este correo';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-credential':
        return 'Las credenciales son inválidas';
      case 'too-many-requests':
        return 'Demasiados intentos. Por favor, intenta más tarde';
      default:
        return 'Error de autenticación: ${e.message}';
    }
  }
}
