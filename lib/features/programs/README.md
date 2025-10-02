  # 📚 Programs Feature - Arquitectura Limpia

## Estructura del módulo de programas

Este módulo implementa la funcionalidad de **Programas → Niveles → Clases** usando **Arquitectura Limpia (Clean Architecture)** y **Provider** para gestión de estado.

### 📊 Jerarquía de Datos

```
Programa
├── Descripción
├── Instructor
├── Imagen
└── Niveles []
    ├── Descripción
    ├── Orden
    ├── Progreso
    └── Clases []
        ├── Título
        ├── Descripción
        ├── Video
        ├── Duración
        ├── Vistas
        └── Comentarios []
            ├── Usuario
            ├── Contenido
            ├── Fecha
            └── Likes
```

### 📁 Estructura de Carpetas

```
lib/features/programs/
├── domain/                          # CAPA DE DOMINIO
│   ├── entities/
│   │   ├── program_entity.dart      # Entidad Programa
│   │   ├── level_entity.dart        # Entidad Nivel
│   │   ├── lesson_entity.dart       # Entidad Clase
│   │   └── comment_entity.dart      # Entidad Comentario
│   └── repositories/
│       └── programs_repository.dart # Contrato del repositorio
│
├── data/                            # CAPA DE DATOS
│   ├── models/
│   │   ├── program_model.dart
│   │   ├── level_model.dart
│   │   ├── lesson_model.dart
│   │   └── comment_model.dart
│   ├── datasources/
│   │   ├── programs_local_datasource.dart  # Datos locales
│   │   └── comments_datasource.dart        # Comentarios
│   └── repositories/
│       └── programs_repository_impl.dart
│
└── presentation/                    # CAPA DE PRESENTACIÓN
    └── providers/
        └── programs_provider.dart   # Provider para gestión de estado
```

### 🏗️ Entidades

#### ProgramEntity (Programa)
```dart
class ProgramEntity {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<LevelEntity> levels;
  final bool isActive;
  final String instructor;
  final DateTime createdAt;
  
  // Propiedades calculadas
  int get totalLevels;
  int get completedLevels;
  double get overallProgress;  // 0.0 a 1.0
  bool get isCompleted;
  LevelEntity? get currentLevel;
}
```

#### LevelEntity (Nivel)
```dart
class LevelEntity {
  final String id;
  final String name;
  final String description;
  final int order;
  final List<LessonEntity> lessons;
  final bool isUnlocked;
  final double progress;  // 0.0 a 1.0
  
  // Propiedades calculadas
  int get totalLessons;
  int get completedLessons;
  bool get isCompleted;
}
```

#### LessonEntity (Clase)
```dart
class LessonEntity {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String? thumbnailUrl;
  final int duration;  // en segundos
  final int order;
  final bool isCompleted;
  final int views;
}
```

#### CommentEntity (Comentario)
```dart
class CommentEntity {
  final String id;
  final String lessonId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final bool isLikedByCurrentUser;
}
```

### 🔄 Flujo de Datos

```
UI (HomePage, DetailProgram, etc.)
    ↓
ProgramsProvider
    ↓
ProgramsRepository (interface)
    ↓
ProgramsRepositoryImpl
    ↓
DataSources (Local/Remote)
    ↓
Datos (Firebase/API/Local)
```

### 🚀 Funcionalidades Implementadas

#### ✅ Gestión de Programas
- Listar todos los programas
- Obtener programa por ID
- Calcular progreso general
- Obtener nivel actual del usuario

#### ✅ Gestión de Niveles
- Listar niveles de un programa
- Desbloquear niveles progresivamente
- Calcular progreso por nivel
- Obtener clases por nivel

#### ✅ Gestión de Clases
- Listar clases de un nivel
- Reproducir video de la clase
- Marcar clase como completada
- Contador de vistas

#### ✅ Gestión de Comentarios
- Listar comentarios por clase
- Agregar comentario
- Eliminar comentario
- Dar like a comentarios
- Ordenar por fecha

### 📝 Uso del ProgramsProvider

#### En los widgets:

```dart
// Obtener el provider
final programsProvider = Provider.of<ProgramsProvider>(context);

// Cargar programas
await programsProvider.loadPrograms();

// Acceder a los datos
final programs = programsProvider.programs;
final selectedProgram = programsProvider.selectedProgram;
final selectedLevel = programsProvider.selectedLevel;

// Seleccionar programa
await programsProvider.selectProgram(programId);

// Seleccionar nivel
programsProvider.selectLevel(level);

// Seleccionar clase
programsProvider.selectLesson(lesson);

// Marcar clase como completada
await programsProvider.markLessonAsCompleted(lessonId);

// Comentarios
await programsProvider.loadComments(lessonId);
await programsProvider.addComment(
  lessonId: lessonId,
  userId: userId,
  userName: userName,
  content: content,
);
await programsProvider.likeComment(commentId, userId);
await programsProvider.deleteComment(commentId, lessonId);
```

### 🎯 Ejemplo de Datos

El `ProgramsLocalDataSource` incluye un programa de ejemplo:

**Programa VIP**
- Nivel 1: Fundamentos (3 clases)
  - Clase 1: Introducción al Acordeón Vallenato
  - Clase 2: Postura y Técnica Básica
  - Clase 3: Primeros Acordes
  
- Nivel 2: Técnicas Intermedias (2 clases)
  - Clase 4: Escalas y Digitación
  - Clase 5: Ritmos Tradicionales

- Nivel 3: Técnicas Avanzadas (2 clases)
  - Clase 6: Improvisación y Creatividad
  - Clase 7: Técnicas de Ornamentación

### 📊 Estados del Sistema

```dart
enum ProgramsStatus {
  initial,    // Estado inicial
  loading,    // Cargando
  loaded,     // Datos cargados
  error      // Error
}
```

### 🔐 Integración con Auth

El sistema de comentarios se integra con la autenticación:

```dart
final authProvider = Provider.of<AuthProvider>(context);
final user = authProvider.user;

// Agregar comentario con datos del usuario
await programsProvider.addComment(
  lessonId: lesson.id,
  userId: user!.uid,
  userName: user.displayName ?? user.email!,
  userPhotoUrl: user.photoURL,
  content: commentText,
);
```

### 📈 Cálculo de Progreso

#### Progreso de Nivel
```dart
double progress = completedLessons / totalLessons;
```

#### Progreso General del Programa
```dart
double overallProgress = 
  totalCompletedLessons / totalLessonsInAllLevels;
```

### 🎨 UI Components

#### HomePage
- Muestra todos los programas disponibles
- Carga datos con `ProgramsProvider`
- Loading state con `CircularProgressIndicator`

#### DetailProgramPage (Mejorada)
- Muestra detalles del programa
- Lista de niveles con progreso
- Navegación a clases

#### LessonPage (A crear)
- Reproductor de video
- Descripción de la clase
- Sección de comentarios
- Marcar como completada

### 🔧 Configuración

#### Dependency Injection

```dart
// lib/core/di/programs_injection.dart
class ProgramsInjection {
  static late ProgramsProvider programsProvider;
  
  static Future<void> init() async {
    // Inicializar data sources, repository y provider
  }
}
```

#### Provider Setup (main.dart)

```dart
void main() async {
  // ...
  await ProgramsInjection.init();
  
  runApp(
    MultiProvider(
      providers: [
        // ...
        ChangeNotifierProvider<ProgramsProvider>.value(
          value: ProgramsInjection.programsProvider,
        ),
      ],
      // ...
    ),
  );
}
```

### 🔄 Desbloqueo de Niveles

Los niveles se desbloquean progresivamente:
- Nivel 1: Desbloqueado por defecto
- Nivel 2: Se desbloquea al completar Nivel 1
- Nivel 3: Se desbloquea al completar Nivel 2

```dart
LevelEntity? get currentLevel {
  // Retorna el primer nivel no completado y desbloqueado
  return levels.firstWhere(
    (level) => !level.isCompleted && level.isUnlocked
  );
}
```

### 📝 Próximos Pasos

#### Funcionalidades Adicionales
- [ ] Persistencia con Firebase Firestore
- [ ] Notificaciones cuando se desbloquea un nivel
- [ ] Sistema de certificados al completar programa
- [ ] Descargar clases para ver offline
- [ ] Subtítulos en videos
- [ ] Velocidad de reproducción
- [ ] Marcadores en el video
- [ ] Quiz al final de cada nivel
- [ ] Ranking de estudiantes
- [ ] Chat en vivo durante clases

#### Mejoras Técnicas
- [ ] Caché de videos
- [ ] Optimización de imágenes
- [ ] Lazy loading de comentarios
- [ ] Paginación de clases
- [ ] Búsqueda de clases
- [ ] Filtros por nivel/dificultad

### ✨ Beneficios de la Arquitectura

1. **Escalable**: Fácil agregar nuevas funcionalidades
2. **Mantenible**: Código organizado y separado
3. **Testeable**: Cada capa puede testearse independientemente
4. **Flexible**: Cambiar data source sin afectar lógica de negocio
5. **Reutilizable**: Componentes pueden reutilizarse

---

**Creado:** Octubre 1, 2025  
**Proyecto:** Comunidad Acordeoneros  
**Stack:** Flutter + Clean Architecture + Provider

