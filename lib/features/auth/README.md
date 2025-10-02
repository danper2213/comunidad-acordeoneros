# Auth Feature - Arquitectura Limpia

## Estructura del módulo de autenticación

Este módulo implementa la funcionalidad de autenticación usando **Arquitectura Limpia (Clean Architecture)** y **Provider** para gestión de estado.

### 📁 Estructura de Carpetas

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart    # Interacción con Firebase Auth
│   ├── models/
│   │   └── user_model.dart                # Modelo de datos del usuario
│   └── repositories/
│       └── auth_repository_impl.dart      # Implementación del repositorio
├── domain/
│   ├── entities/
│   │   └── user_entity.dart               # Entidad de usuario (lógica de negocio)
│   ├── repositories/
│   │   └── auth_repository.dart           # Contrato del repositorio (abstracto)
│   └── usecases/
│       ├── login_usecase.dart             # Caso de uso: Login
│       ├── signup_usecase.dart            # Caso de uso: Registro
│       ├── logout_usecase.dart            # Caso de uso: Cerrar sesión
│       ├── get_current_user_usecase.dart  # Caso de uso: Obtener usuario actual
│       └── google_signin_usecase.dart     # Caso de uso: Login con Google
└── presentation/
    └── providers/
        └── auth_provider.dart             # Provider para gestión de estado
```

### 🏗️ Capas de la Arquitectura

#### 1. **Domain Layer** (Capa de Dominio)
Contiene la lógica de negocio y es independiente de cualquier framework o librería externa.

- **Entities**: Objetos de negocio puros (UserEntity)
- **Repositories**: Interfaces/contratos abstractos
- **Use Cases**: Casos de uso específicos de la aplicación

#### 2. **Data Layer** (Capa de Datos)
Maneja la obtención y persistencia de datos.

- **DataSources**: Implementación de fuentes de datos (Firebase)
- **Models**: Modelos de datos que extienden las entidades
- **Repositories**: Implementación concreta de los repositoriosabstractos

#### 3. **Presentation Layer** (Capa de Presentación)
Maneja la UI y la gestión de estado.

- **Providers**: Gestión de estado con Provider
- **Pages**: (ubicadas en lib/pages/) Pantallas de la aplicación

### 🔄 Flujo de Datos

```
UI (Widgets) 
    ↓
Provider (AuthProvider)
    ↓
Use Cases (LoginUseCase, SignUpUseCase, etc.)
    ↓
Repository Interface (AuthRepository)
    ↓
Repository Implementation (AuthRepositoryImpl)
    ↓
Data Source (AuthRemoteDataSource)
    ↓
Firebase Auth
```

### 🚀 Funcionalidades Implementadas

#### Autenticación con Email y Password
- ✅ Login
- ✅ Registro (Sign Up)
- ✅ Logout

#### Autenticación Social
- ✅ Google Sign In
- ⏳ Facebook Sign In (pendiente)
- ⏳ Apple Sign In (pendiente)

### 📝 Uso del AuthProvider

#### En los widgets:

```dart
// Leer el estado
final authProvider = Provider.of<AuthProvider>(context);
final isLoading = authProvider.isLoading;
final user = authProvider.user;

// Ejecutar acciones (sin escuchar cambios)
final authProvider = Provider.of<AuthProvider>(context, listen: false);

// Login
final success = await authProvider.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Sign Up
final success = await authProvider.signUpWithEmailAndPassword(
  email: email,
  password: password,
  displayName: displayName,
);

// Google Sign In
final success = await authProvider.signInWithGoogle();

// Logout
await authProvider.signOut();
```

### 🔧 Configuración

#### Dependency Injection
El archivo `lib/core/di/injection_container.dart` maneja la inyección de dependencias:

```dart
await InjectionContainer.init();
```

#### Provider Setup (main.dart)
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<AuthProvider>.value(
      value: InjectionContainer.authProvider,
    ),
  ],
  child: MaterialApp(...),
)
```

### ⚠️ Manejo de Errores

Los errores de Firebase se manejan en `AuthRemoteDataSource` y se traducen a mensajes en español:

- `weak-password` → "La contraseña es demasiado débil"
- `email-already-in-use` → "Este correo electrónico ya está en uso"
- `user-not-found` → "No se encontró ningún usuario con este correo"
- etc.

### 🧪 Testing

Para testing, cada capa puede ser testeada independientemente:

- **Use Cases**: Testear lógica de negocio
- **Repositories**: Mockear DataSources
- **Providers**: Testear estados y transiciones

### 📚 Beneficios de esta arquitectura

1. **Separación de responsabilidades**: Cada capa tiene un propósito específico
2. **Testeable**: Fácil de crear tests unitarios y de integración
3. **Mantenible**: Código organizado y fácil de mantener
4. **Escalable**: Fácil de agregar nuevas funcionalidades
5. **Independiente**: La lógica de negocio no depende de frameworks externos

