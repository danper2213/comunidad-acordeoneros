# ✅ Checklist de Testing - Sistema de Autenticación

## 🧪 Guía de Pruebas Manuales

### 📋 Preparación

- [ ] Ejecutar `flutter pub get`
- [ ] Verificar que Firebase esté configurado correctamente
- [ ] Verificar que `google-services.json` (Android) esté en `android/app/`
- [ ] Compilar la app: `flutter run`

---

## 🔐 Testing de Autenticación

### 1. Registro de Usuario (Sign Up)

#### Test Case 1.1: Registro Exitoso
- [ ] Abrir la app
- [ ] Click en "Regístrate aquí"
- [ ] Ingresar:
  - Nombre: `Test User`
  - Email: `test@example.com`
  - Password: `123456`
  - Confirmar Password: `123456`
- [ ] Click en "Crear cuenta"
- [ ] **Esperado**: 
  - Muestra loading
  - Navega a HomePage
  - Muestra nombre del usuario en el drawer

#### Test Case 1.2: Validaciones de Registro
- [ ] Intentar registrarse con campos vacíos
  - **Esperado**: Mensajes de error en cada campo
- [ ] Intentar con email inválido (sin @)
  - **Esperado**: "Por favor ingresa un correo electronico valido"
- [ ] Intentar con contraseña < 6 caracteres
  - **Esperado**: "La contraseña debe tener al menos 6 caracteres"
- [ ] Intentar con contraseñas que no coinciden
  - **Esperado**: "Las contraseñas no coinciden"

#### Test Case 1.3: Email Duplicado
- [ ] Intentar registrarse con un email ya existente
- [ ] **Esperado**: 
  - Muestra SnackBar roja
  - Mensaje: "Este correo electrónico ya está en uso"

---

### 2. Inicio de Sesión (Login)

#### Test Case 2.1: Login Exitoso
- [ ] En pantalla de login, ingresar:
  - Email: `test@example.com`
  - Password: `123456`
- [ ] Click en "Iniciar sesión"
- [ ] **Esperado**:
  - Muestra loading
  - Navega a HomePage
  - Muestra información del usuario

#### Test Case 2.2: Credenciales Incorrectas
- [ ] Intentar login con password incorrecta
- [ ] **Esperado**:
  - SnackBar roja
  - Mensaje de error apropiado

#### Test Case 2.3: Usuario No Existente
- [ ] Intentar login con email no registrado
- [ ] **Esperado**:
  - SnackBar roja
  - "No se encontró ningún usuario con este correo"

#### Test Case 2.4: Validaciones de Login
- [ ] Intentar login con campos vacíos
  - **Esperado**: Mensajes de validación
- [ ] Email sin @
  - **Esperado**: Error de validación

---

### 3. Google Sign In

#### Test Case 3.1: Login con Google Exitoso
- [ ] Click en botón de Google
- [ ] Seleccionar cuenta de Google
- [ ] **Esperado**:
  - Muestra loading
  - Navega a HomePage
  - Muestra foto de perfil de Google (si existe)
  - Muestra nombre de la cuenta de Google

#### Test Case 3.2: Cancelar Google Sign In
- [ ] Click en botón de Google
- [ ] Cerrar el diálogo de Google
- [ ] **Esperado**:
  - Permanece en pantalla de login
  - Muestra mensaje de error

---

### 4. Persistencia de Sesión

#### Test Case 4.1: Auto-Login
- [ ] Iniciar sesión exitosamente
- [ ] Cerrar completamente la app
- [ ] Volver a abrir la app
- [ ] **Esperado**:
  - Muestra loading brevemente
  - Navega automáticamente a HomePage
  - NO pide login nuevamente

#### Test Case 4.2: Estado de Loading Inicial
- [ ] Al abrir la app (con sesión activa)
- [ ] **Esperado**:
  - Muestra CircularProgressIndicator
  - Luego navega a HomePage

---

### 5. Cierre de Sesión (Logout)

#### Test Case 5.1: Logout desde AppBar
- [ ] Estando en HomePage
- [ ] Click en icono de logout en AppBar
- [ ] Confirmar en el diálogo
- [ ] **Esperado**:
  - Muestra diálogo de confirmación
  - Cierra sesión
  - Navega a LoginPage

#### Test Case 5.2: Logout desde Drawer
- [ ] Abrir drawer (menú lateral)
- [ ] Click en "Cerrar sesión"
- [ ] Confirmar en el diálogo
- [ ] **Esperado**:
  - Cierra drawer
  - Muestra diálogo
  - Cierra sesión al confirmar

#### Test Case 5.3: Cancelar Logout
- [ ] Intentar logout
- [ ] Click en "Cancelar" en el diálogo
- [ ] **Esperado**:
  - Cierra el diálogo
  - Permanece en HomePage
  - NO cierra sesión

---

### 6. Navegación

#### Test Case 6.1: Navegación entre Login y Registro
- [ ] Desde LoginPage, click en "Regístrate aquí"
  - **Esperado**: Navega a RegisterPage
- [ ] Desde RegisterPage, click en "Inicia sesión aquí"
  - **Esperado**: Vuelve a LoginPage

#### Test Case 6.2: Botón Back
- [ ] En LoginFormPage, click en botón back
  - **Esperado**: Vuelve a LoginPage (landing)
- [ ] En RegisterFormPage, click en botón back
  - **Esperado**: Vuelve a LoginFormPage

---

### 7. UI/UX

#### Test Case 7.1: Estados de Loading
- [ ] Durante login, verificar:
  - **Esperado**: Overlay negro con CircularProgressIndicator
- [ ] Durante registro, verificar:
  - **Esperado**: Loading overlay
- [ ] Durante logout, verificar:
  - **Esperado**: Indicador de loading apropiado

#### Test Case 7.2: Mensajes de Error
- [ ] Verificar que todos los errores muestren SnackBar roja
- [ ] Verificar que los mensajes sean en español
- [ ] Verificar que desaparezcan automáticamente

#### Test Case 7.3: Información del Usuario
- [ ] En HomePage, verificar drawer:
  - **Esperado**: 
    - Muestra foto de perfil (o icono por defecto)
    - Muestra nombre de usuario
    - Muestra email

#### Test Case 7.4: Toggle de Password
- [ ] En campos de contraseña, click en icono de ojo
  - **Esperado**: Alterna entre mostrar/ocultar contraseña

---

### 8. Edge Cases

#### Test Case 8.1: Múltiples Clicks
- [ ] Click múltiple en botón de login
  - **Esperado**: Solo procesa una vez (loading previene clicks adicionales)

#### Test Case 8.2: Conexión a Internet
- [ ] Desactivar internet
- [ ] Intentar login
  - **Esperado**: Mensaje de error apropiado

#### Test Case 8.3: Campos con Espacios
- [ ] Ingresar email con espacios al inicio/final
- [ ] **Esperado**: Se hace trim() automáticamente

---

## 📊 Resultados Esperados

### ✅ Todos los Tests Deben Pasar

| Test | Estado | Notas |
|------|--------|-------|
| Registro Exitoso | ⬜ | |
| Validaciones Registro | ⬜ | |
| Login Exitoso | ⬜ | |
| Credenciales Incorrectas | ⬜ | |
| Google Sign In | ⬜ | |
| Persistencia de Sesión | ⬜ | |
| Logout | ⬜ | |
| Navegación | ⬜ | |
| Loading States | ⬜ | |
| Error Handling | ⬜ | |

---

## 🐛 Reporte de Bugs

Si encuentras algún problema, documéntalo así:

```
### Bug #[número]
**Descripción**: [Qué pasó]
**Pasos para reproducir**:
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

**Comportamiento esperado**: [Qué debería pasar]
**Comportamiento actual**: [Qué pasó realmente]
**Screenshots**: [Si aplica]
```

---

## 🧪 Tests Automatizados (Futuro)

### Unit Tests a Implementar

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
│       │       ├── signup_usecase_test.dart
│       │       └── logout_usecase_test.dart
│       ├── data/
│       │   ├── models/
│       │   │   └── user_model_test.dart
│       │   └── repositories/
│       │       └── auth_repository_impl_test.dart
│       └── presentation/
│           └── providers/
│               └── auth_provider_test.dart
```

### Widget Tests a Implementar

```dart
test/
└── features/
    └── auth/
        └── presentation/
            └── widgets/
                ├── auth_wrapper_test.dart
                ├── login_form_test.dart
                └── register_form_test.dart
```

### Integration Tests a Implementar

```dart
integration_test/
├── auth_flow_test.dart
├── login_test.dart
└── registration_test.dart
```

---

## 🚀 Comandos Útiles

```bash
# Ejecutar la app
flutter run

# Limpiar y reconstruir
flutter clean && flutter pub get && flutter run

# Ver logs
flutter logs

# Ejecutar tests (cuando se implementen)
flutter test

# Ejecutar tests de integración (cuando se implementen)
flutter test integration_test

# Analizar código
flutter analyze

# Formatear código
dart format lib/
```

---

## ✅ Checklist de Aprobación Final

Antes de considerar el feature completo:

- [ ] Todos los tests manuales pasan
- [ ] No hay errores de linting (`flutter analyze`)
- [ ] Código formateado (`dart format`)
- [ ] Documentación completa
- [ ] README actualizado
- [ ] Screenshots tomados (opcional)
- [ ] Performance aceptable
- [ ] UX fluida sin trabas
- [ ] Mensajes de error claros
- [ ] Loading states apropiados
- [ ] Navegación intuitiva

---

**Última actualización**: Octubre 1, 2025
**Proyecto**: Comunidad Acordeoneros
**Feature**: Sistema de Autenticación

