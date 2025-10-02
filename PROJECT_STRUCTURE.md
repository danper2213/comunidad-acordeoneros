# 🗂️ Estructura del Proyecto - Sistema de Autenticación

## 📊 Vista General

```
comunidad-acordeoneros/
│
├── 📱 lib/
│   │
│   ├── 🎯 core/                          # NÚCLEO DE LA APLICACIÓN
│   │   ├── di/
│   │   │   └── injection_container.dart  # 💉 Inyección de dependencias
│   │   ├── errors/
│   │   │   └── failures.dart            # ⚠️ Tipos de errores
│   │   └── utils/
│   │       └── either.dart              # 🔀 Manejo funcional de errores
│   │
│   ├── ✨ features/                      # CARACTERÍSTICAS MODULARES
│   │   └── auth/                        # 🔐 MÓDULO DE AUTENTICACIÓN
│   │       │
│   │       ├── 📊 domain/               # CAPA DE DOMINIO (Lógica de Negocio)
│   │       │   ├── entities/
│   │       │   │   └── user_entity.dart          # 👤 Entidad Usuario
│   │       │   ├── repositories/
│   │       │   │   └── auth_repository.dart      # 📋 Contrato del repositorio
│   │       │   └── usecases/
│   │       │       ├── login_usecase.dart        # ▶️ Caso de uso: Login
│   │       │       ├── signup_usecase.dart       # ✍️ Caso de uso: Registro
│   │       │       ├── logout_usecase.dart       # 🚪 Caso de uso: Logout
│   │       │       ├── get_current_user_usecase.dart  # 👁️ Obtener usuario actual
│   │       │       ├── google_signin_usecase.dart     # 🔍 Login con Google
│   │       │       └── usecases.dart             # 📦 Barrel file
│   │       │
│   │       ├── 💾 data/                 # CAPA DE DATOS (Implementación)
│   │       │   ├── datasources/
│   │       │   │   └── auth_remote_datasource.dart   # 🌐 Fuente de datos Firebase
│   │       │   ├── models/
│   │       │   │   └── user_model.dart               # 📦 Modelo de datos
│   │       │   └── repositories/
│   │       │       └── auth_repository_impl.dart     # ✅ Implementación del repo
│   │       │
│   │       ├── 🎨 presentation/         # CAPA DE PRESENTACIÓN (UI y Estado)
│   │       │   ├── providers/
│   │       │   │   └── auth_provider.dart       # 🔄 Gestión de estado
│   │       │   └── widgets/
│   │       │       └── auth_wrapper.dart        # 🛡️ Protección de rutas
│   │       │
│   │       ├── auth_exports.dart        # 📤 Exportaciones centralizadas
│   │       └── README.md                # 📚 Documentación del módulo
│   │
│   ├── 📄 pages/                        # PANTALLAS DE LA APP
│   │   ├── login_form.dart             # 🔐 Pantalla de login
│   │   ├── register_form.dart          # ✍️ Pantalla de registro
│   │   ├── home.dart                   # 🏠 Pantalla principal
│   │   ├── login.dart                  # 🎯 Landing page de login
│   │   └── ... (otras páginas)
│   │
│   ├── 🎨 widgets/                      # COMPONENTES REUTILIZABLES
│   │   ├── button_custom.dart
│   │   ├── card_todo.dart
│   │   └── ... (otros widgets)
│   │
│   ├── 🎭 theme/                        # TEMA DE LA APP
│   │   └── theme_app.dart
│   │
│   ├── 🔥 firebase_options.dart         # Configuración Firebase
│   └── 🚀 main.dart                     # PUNTO DE ENTRADA
│
├── 📚 DOCUMENTACIÓN/
│   ├── AUTHENTICATION_GUIDE.md          # 📖 Guía de autenticación
│   ├── IMPLEMENTATION_SUMMARY.md        # ✅ Resumen de implementación
│   └── PROJECT_STRUCTURE.md             # 🗂️ Este archivo
│
├── 🔧 CONFIGURACIÓN/
│   ├── pubspec.yaml                     # 📦 Dependencias
│   ├── analysis_options.yaml            # 🔍 Reglas de análisis
│   └── firebase.json                    # 🔥 Configuración Firebase
│
└── 📱 PLATAFORMAS/
    ├── android/                         # 🤖 Android
    ├── ios/                             # 🍎 iOS
    ├── web/                             # 🌐 Web
    ├── windows/                         # 🪟 Windows
    ├── linux/                           # 🐧 Linux
    └── macos/                           # 💻 macOS
```

## 🏗️ Capas de Clean Architecture

### 1️⃣ Domain Layer (Capa de Dominio)
```
┌─────────────────────────────────────┐
│       DOMAIN LAYER                  │
│  (Lógica de Negocio Pura)          │
├─────────────────────────────────────┤
│  📦 Entities                        │
│  - UserEntity                       │
│                                     │
│  📋 Repositories (Abstractos)       │
│  - AuthRepository                   │
│                                     │
│  ⚙️ Use Cases                       │
│  - LoginUseCase                     │
│  - SignUpUseCase                    │
│  - LogoutUseCase                    │
│  - GetCurrentUserUseCase            │
│  - GoogleSignInUseCase              │
└─────────────────────────────────────┘
```

### 2️⃣ Data Layer (Capa de Datos)
```
┌─────────────────────────────────────┐
│        DATA LAYER                   │
│  (Implementación de Datos)          │
├─────────────────────────────────────┤
│  📦 Models                          │
│  - UserModel (extends UserEntity)   │
│                                     │
│  🌐 Data Sources                    │
│  - AuthRemoteDataSource             │
│                                     │
│  ✅ Repository Implementation       │
│  - AuthRepositoryImpl               │
│    (implements AuthRepository)      │
└─────────────────────────────────────┘
```

### 3️⃣ Presentation Layer (Capa de Presentación)
```
┌─────────────────────────────────────┐
│     PRESENTATION LAYER              │
│   (UI y Gestión de Estado)          │
├─────────────────────────────────────┤
│  🔄 Providers                       │
│  - AuthProvider (ChangeNotifier)    │
│                                     │
│  🎨 Widgets                         │
│  - AuthWrapper                      │
│                                     │
│  📄 Pages                           │
│  - LoginFormPage                    │
│  - RegisterFormPage                 │
│  - HomePage                         │
└─────────────────────────────────────┘
```

## 🔄 Flujo de Datos Detallado

```
┌─────────────────────────────────────────────────────────────────┐
│                         UI LAYER                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ LoginForm    │  │ RegisterForm │  │   HomePage   │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
│         │                  │                  │                   │
│         └──────────────────┼──────────────────┘                   │
│                           │                                      │
│                           ▼                                      │
│                  ┌─────────────────┐                            │
│                  │  AuthProvider   │  ◄─── ChangeNotifier       │
│                  └────────┬────────┘                            │
└──────────────────────────┼──────────────────────────────────────┘
                           │
┌──────────────────────────┼──────────────────────────────────────┐
│                  DOMAIN LAYER                                    │
│                           ▼                                      │
│         ┌──────────────────────────────────────┐                │
│         │         Use Cases                     │                │
│         ├──────────────────────────────────────┤                │
│         │ • LoginUseCase                       │                │
│         │ • SignUpUseCase                      │                │
│         │ • LogoutUseCase                      │                │
│         │ • GetCurrentUserUseCase              │                │
│         │ • GoogleSignInUseCase                │                │
│         └─────────────┬────────────────────────┘                │
│                       │                                          │
│                       ▼                                          │
│         ┌──────────────────────────────────────┐                │
│         │  AuthRepository (interface)          │                │
│         └─────────────┬────────────────────────┘                │
└───────────────────────┼──────────────────────────────────────────┘
                        │
┌───────────────────────┼──────────────────────────────────────────┐
│                  DATA LAYER                                       │
│                        ▼                                          │
│         ┌──────────────────────────────────────┐                │
│         │  AuthRepositoryImpl                  │                │
│         └─────────────┬────────────────────────┘                │
│                       │                                          │
│                       ▼                                          │
│         ┌──────────────────────────────────────┐                │
│         │  AuthRemoteDataSource                │                │
│         └─────────────┬────────────────────────┘                │
└───────────────────────┼──────────────────────────────────────────┘
                        │
                        ▼
              ┌──────────────────┐
              │  Firebase Auth   │
              └──────────────────┘
```

## 📦 Dependencias del Proyecto

```yaml
dependencies:
  # Flutter
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^4.1.1      # Core de Firebase
  firebase_auth: ^6.1.0      # Autenticación
  
  # Autenticación Social
  google_sign_in: ^6.2.1     # Login con Google
  
  # Gestión de Estado
  provider: ^6.1.2           # State management
  
  # UI
  cupertino_icons: ^1.0.6    # Iconos
  google_fonts: ^6.1.0       # Fuentes
  curved_navigation_bar: ^1.0.3  # Navegación
  
  # Multimedia
  video_player: 2.9.0        # Reproductor de video
```

## 🎯 Puntos de Entrada

### 1. main.dart
```dart
void main() async {
  // Inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización de Firebase
  await Firebase.initializeApp();
  
  // Inicialización de Dependencias
  await InjectionContainer.init();
  
  // Ejecución de la app
  runApp(const MyApp());
}
```

### 2. InjectionContainer (DI)
```
External Dependencies
    ↓
Data Sources
    ↓
Repositories
    ↓
Use Cases
    ↓
Providers
```

### 3. AuthWrapper
```
App Start
    ↓
AuthWrapper
    ↓
Check Auth Status
    ↓
├── Authenticated → HomePage
└── Not Authenticated → LoginPage
```

## 📊 Estados de la Aplicación

```
AuthStatus States:
├── 🔵 initial       → Estado inicial
├── ⏳ loading       → Procesando
├── ✅ authenticated → Usuario logueado
├── ❌ unauthenticated → Sin sesión
└── ⚠️ error        → Error ocurrido
```

## 🔐 Flujo de Autenticación

### Login Flow
```
┌──────────────┐
│ User Input   │
│ Email/Pass   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Validation   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│AuthProvider  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ LoginUseCase │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  Repository  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ DataSource   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│Firebase Auth │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│   Success?   │
└──────┬───────┘
       │
       ├─ Yes → Navigate to HomePage
       │
       └─ No  → Show Error Message
```

## 📈 Métricas del Proyecto

| Métrica | Valor |
|---------|-------|
| Total Archivos Creados | 20 |
| Total Archivos Modificados | 4 |
| Líneas de Código | ~2,500+ |
| Capas de Arquitectura | 3 |
| Use Cases | 5 |
| Data Sources | 1 |
| Repositories | 1 |
| Providers | 1 |
| Entities | 1 |
| Models | 1 |

## ✨ Características Implementadas

- ✅ Login Email/Password
- ✅ Registro Email/Password
- ✅ Google Sign In
- ✅ Logout
- ✅ Persistencia de sesión
- ✅ Auto-login
- ✅ Validaciones
- ✅ Error handling
- ✅ Loading states
- ✅ User profile display
- ✅ Protected routes

---

**🎉 Sistema completamente funcional con Arquitectura Limpia + Provider + Firebase 🎉**

