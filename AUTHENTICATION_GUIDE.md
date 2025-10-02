# Guía de Autenticación - Comunidad Acordeoneros

## 📋 Resumen

Se ha implementado un sistema completo de autenticación con Firebase usando **Arquitectura Limpia** y **Provider** para la gestión de estado.

## 🏗️ Estructura del Proyecto

```
lib/
├── core/
│   ├── di/
│   │   └── injection_container.dart       # Inyección de dependencias
│   ├── errors/
│   │   └── failures.dart                  # Definición de errores
│   └── utils/
│       └── either.dart                    # Tipo Either para manejo de errores
│
├── features/
│   └── auth/
│       ├── data/                          # CAPA DE DATOS
│       │   ├── datasources/
│       │   │   └── auth_remote_datasource.dart
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   └── repositories/
│       │       └── auth_repository_impl.dart
│       │
│       ├── domain/                        # CAPA DE DOMINIO
│       │   ├── entities/
│       │   │   └── user_entity.dart
│       │   ├── repositories/
│       │   │   └── auth_repository.dart
│       │   └── usecases/
│       │       ├── login_usecase.dart
│       │       ├── signup_usecase.dart
│       │       ├── logout_usecase.dart
│       │       ├── get_current_user_usecase.dart
│       │       └── google_signin_usecase.dart
│       │
│       └── presentation/                  # CAPA DE PRESENTACIÓN
│           ├── providers/
│           │   └── auth_provider.dart
│           └── widgets/
│               └── auth_wrapper.dart
│
├── pages/
│   ├── login_form.dart                   # Pantalla de login
│   ├── register_form.dart                # Pantalla de registro
│   └── home.dart                         # Pantalla principal
│
└── main.dart                             # Punto de entrada
```

## ✨ Funcionalidades Implementadas

### 1. Autenticación Email/Password
- ✅ **Login**: Inicio de sesión con email y contraseña
- ✅ **Registro**: Creación de cuenta con email, contraseña y nombre
- ✅ **Validaciones**: 
  - Email válido
  - Contraseña mínimo 6 caracteres
  - Confirmación de contraseña

### 2. Autenticación Social
- ✅ **Google Sign In**: Integración completa con Google
- ⏳ **Facebook** (estructura preparada, pendiente configuración)
- ⏳ **Apple** (estructura preparada, pendiente configuración)

### 3. Gestión de Sesión
- ✅ **Persistencia**: La sesión persiste al cerrar la app
- ✅ **Auth Wrapper**: Verifica automáticamente el estado de autenticación al iniciar
- ✅ **Logout**: Cierre de sesión con confirmación

### 4. UI/UX
- ✅ **Loading States**: Indicadores de carga durante operaciones
- ✅ **Error Handling**: Mensajes de error en español
- ✅ **User Profile**: Muestra información del usuario en el drawer
- ✅ **Logout Dialog**: Confirmación antes de cerrar sesión

## 🔐 Flujo de Autenticación

### Login Flow
```
┌─────────────────┐
│  Login Screen   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  AuthProvider   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  LoginUseCase   │
└────────┬────────┘
         │
         ▼
┌──────────────────┐
│ AuthRepository   │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   DataSource     │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│  Firebase Auth   │
└──────────────────┘
```

## 📱 Uso en el Código

### En la UI (Widgets)

```dart
// Obtener el provider
final authProvider = Provider.of<AuthProvider>(context);

// Verificar estado
if (authProvider.isLoading) {
  // Mostrar loading
}

if (authProvider.isAuthenticated) {
  // Usuario autenticado
}

// Acceder al usuario
final user = authProvider.user;
print(user?.email);
print(user?.displayName);
```

### Login

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

final success = await authProvider.signInWithEmailAndPassword(
  email: emailController.text.trim(),
  password: passwordController.text,
);

if (success) {
  // Navegar a home
} else {
  // Mostrar error: authProvider.errorMessage
}
```

### Sign Up

```dart
final success = await authProvider.signUpWithEmailAndPassword(
  email: emailController.text.trim(),
  password: passwordController.text,
  displayName: nameController.text.trim(),
);
```

### Google Sign In

```dart
final success = await authProvider.signInWithGoogle();
```

### Logout

```dart
final success = await authProvider.signOut();
if (success) {
  // Navegar a login
}
```

## 🎨 Estados del AuthProvider

```dart
enum AuthStatus {
  initial,       // Estado inicial
  loading,       // Cargando
  authenticated, // Usuario autenticado
  unauthenticated, // Usuario no autenticado
  error         // Error
}
```

## ⚠️ Manejo de Errores

Los errores de Firebase se traducen automáticamente a español:

| Código Firebase | Mensaje en Español |
|----------------|-------------------|
| `weak-password` | La contraseña es demasiado débil |
| `email-already-in-use` | Este correo electrónico ya está en uso |
| `user-not-found` | No se encontró ningún usuario con este correo |
| `wrong-password` | Contraseña incorrecta |
| `invalid-email` | El correo electrónico no es válido |

## 🔧 Configuración Necesaria

### Firebase (Ya configurado)
```yaml
# pubspec.yaml
dependencies:
  firebase_core: ^4.1.1
  firebase_auth: ^6.1.0
  google_sign_in: ^6.2.1
  provider: ^6.1.2
```

### Google Sign In

Para que Google Sign In funcione:

1. **Android**: 
   - El archivo `google-services.json` debe estar en `android/app/`
   - Configurar SHA-1 en Firebase Console

2. **iOS**:
   - Agregar `GoogleService-Info.plist`
   - Configurar URL Schemes en Info.plist

## 📝 Próximos Pasos

### Funcionalidades Pendientes
- [ ] Recuperación de contraseña (Forgot Password)
- [ ] Verificación de email
- [ ] Facebook Sign In
- [ ] Apple Sign In
- [ ] Actualización de perfil de usuario
- [ ] Cambio de contraseña
- [ ] Eliminación de cuenta

### Mejoras Sugeridas
- [ ] Agregar tests unitarios
- [ ] Agregar tests de integración
- [ ] Implementar analytics de Firebase
- [ ] Agregar Crashlytics
- [ ] Implementar rate limiting
- [ ] Agregar biometría (huella/Face ID)

## 🧪 Testing

### Estructura para Tests

```dart
test/
├── core/
│   └── utils/
│       └── either_test.dart
├── features/
│   └── auth/
│       ├── domain/
│       │   └── usecases/
│       │       ├── login_usecase_test.dart
│       │       └── signup_usecase_test.dart
│       ├── data/
│       │   └── repositories/
│       │       └── auth_repository_impl_test.dart
│       └── presentation/
│           └── providers/
│               └── auth_provider_test.dart
```

## 🎯 Principios Aplicados

1. **SOLID Principles**
   - Single Responsibility
   - Dependency Inversion
   - Interface Segregation

2. **Clean Architecture**
   - Separación en capas
   - Independencia de frameworks
   - Testeable

3. **Best Practices**
   - Manejo de errores robusto
   - Loading states
   - Validaciones
   - Mensajes de usuario claros

## 📚 Referencias

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Provider Package](https://pub.dev/packages/provider)
- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Desarrollado por:** Comunidad Acordeoneros  
**Fecha:** Octubre 2025

