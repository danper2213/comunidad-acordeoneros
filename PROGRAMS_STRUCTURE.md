# 📚 Estructura de Programas - Sistema de Aprendizaje

## 🎯 Resumen

Se ha implementado un sistema completo de **Programas de Aprendizaje** con la estructura:

```
📚 Programa
  └── 📊 Niveles
      └── 📹 Clases
          └── 💬 Comentarios
```

---

## 📊 Jerarquía Completa

### 1️⃣ Programa (Program)

Un **Programa** representa un curso completo de acordeón.

**Atributos:**
- ✅ ID único
- ✅ Nombre
- ✅ Descripción completa
- ✅ Imagen de portada
- ✅ Instructor
- ✅ Fecha de creación
- ✅ Estado (activo/inactivo)
- ✅ Lista de niveles

**Propiedades Calculadas:**
- `totalLevels` - Total de niveles
- `completedLevels` - Niveles completados
- `overallProgress` - Progreso general (0.0 a 1.0)
- `isCompleted` - Si el programa está completo
- `currentLevel` - Nivel actual del usuario

**Ejemplo:**
```dart
ProgramEntity(
  id: 'prog-001',
  name: 'Programa VIP',
  description: 'Curso exclusivo de acordeón vallenato...',
  imageUrl: 'assets/images/fer-festival.jpg',
  instructor: 'Ferney Arrieta',
  levels: [...],
  overallProgress: 0.35,  // 35% completado
)
```

---

### 2️⃣ Nivel (Level)

Un **Nivel** agrupa clases temáticas dentro de un programa.

**Atributos:**
- ✅ ID único
- ✅ Nombre (ej: "Nivel 1 - Fundamentos")
- ✅ Descripción
- ✅ Orden
- ✅ Lista de clases
- ✅ Estado desbloqueado (isUnlocked)
- ✅ Progreso (0.0 a 1.0)

**Propiedades Calculadas:**
- `totalLessons` - Total de clases
- `completedLessons` - Clases completadas
- `isCompleted` - Si el nivel está completo

**Sistema de Desbloqueo:**
- Nivel 1: **Siempre desbloqueado**
- Nivel N: Se desbloquea al completar Nivel N-1

**Ejemplo:**
```dart
LevelEntity(
  id: 'level-001',
  name: 'Nivel 1 - Fundamentos',
  description: 'Aprende los fundamentos básicos...',
  order: 1,
  isUnlocked: true,
  progress: 0.66,  // 2 de 3 clases completadas
  lessons: [...],
)
```

---

### 3️⃣ Clase (Lesson)

Una **Clase** es una lección individual con video y descripción.

**Atributos:**
- ✅ ID único
- ✅ Título
- ✅ Descripción
- ✅ URL del video
- ✅ Thumbnail (opcional)
- ✅ Duración (segundos)
- ✅ Orden
- ✅ Estado completado
- ✅ Contador de vistas

**Funcionalidades:**
- ▶️ Reproducir video
- ✅ Marcar como completada
- 👁️ Contador de vistas
- 💬 Comentarios asociados

**Ejemplo:**
```dart
LessonEntity(
  id: 'lesson-001',
  title: 'Introducción al Acordeón Vallenato',
  description: 'En esta primera clase aprenderás...',
  videoUrl: 'assets/videos/test.mp4',
  duration: 600,  // 10 minutos
  order: 1,
  isCompleted: false,
  views: 0,
)
```

---

### 4️⃣ Comentario (Comment)

Un **Comentario** permite a los usuarios interactuar en cada clase.

**Atributos:**
- ✅ ID único
- ✅ ID de la clase
- ✅ ID del usuario
- ✅ Nombre del usuario
- ✅ Foto del usuario (opcional)
- ✅ Contenido del comentario
- ✅ Fecha de creación
- ✅ Fecha de actualización
- ✅ Contador de likes
- ✅ Si el usuario actual dio like

**Funcionalidades:**
- ➕ Agregar comentario
- 🗑️ Eliminar comentario (solo autor)
- ❤️ Dar/quitar like
- 📅 Ordenar por fecha

**Ejemplo:**
```dart
CommentEntity(
  id: 'comment-001',
  lessonId: 'lesson-001',
  userId: 'user-123',
  userName: 'Juan Pérez',
  content: 'Excelente clase!',
  createdAt: DateTime.now(),
  likes: 5,
  isLikedByCurrentUser: true,
)
```

---

## 🔄 Flujo de Uso

### 1. Ver Programas Disponibles
```
HomePage 
  → Carga programas con ProgramsProvider
  → Muestra lista de ProgramCards
  → Click en programa → DetailProgramPage
```

### 2. Explorar Programa y Niveles
```
DetailProgramPage
  → Muestra descripción del programa
  → Lista de niveles (bloqueados/desbloqueados)
  → Click en nivel → LevelPage (lista de clases)
```

### 3. Ver Clase con Video
```
LevelPage
  → Muestra clases del nivel
  → Click en clase → LessonPage
    → Reproduce video
    → Muestra descripción
    → Sección de comentarios
    → Botón "Marcar como completada"
```

### 4. Interactuar con Comentarios
```
LessonPage
  → Ver comentarios de otros usuarios
  → Agregar nuevo comentario
  → Dar like a comentarios
  → Eliminar propios comentarios
```

---

## 📈 Sistema de Progreso

### Cálculo de Progreso por Nivel
```dart
// Porcentaje de clases completadas
double progress = completedLessons / totalLessons;

// Ejemplo: 2 de 3 clases completadas = 0.66 (66%)
```

### Cálculo de Progreso General
```dart
// Total de clases completadas en TODOS los niveles
int totalCompleted = 0;
int totalLessons = 0;

for (level in program.levels) {
  totalCompleted += level.completedLessons;
  totalLessons += level.totalLessons;
}

double overallProgress = totalCompleted / totalLessons;
```

### Visualización del Progreso
- **Barra de progreso** en cada nivel
- **Porcentaje** en el programa general
- **Badge** de nivel completado
- **Checkmark** en clases completadas

---

## 🎨 Componentes de UI

### ProgramCard
Tarjeta que muestra un programa en la HomePage.

```dart
ProgramCard(
  name: 'Programa VIP',
  level: 'Nivel 1 - Fundamentos',
  image: 'assets/images/fer-festival.jpg',
)
```

### DetailProgramPage
Página de detalles del programa con lista de niveles.

```dart
DetailProgramPage(
  name: program.name,
  description: program.description,
  image: program.imageUrl,
  levels: program.levels,
)
```

### LessonCard (A crear)
Tarjeta para mostrar una clase.

```dart
LessonCard(
  lesson: lessonEntity,
  isCompleted: lesson.isCompleted,
  onTap: () => navigateToLesson(lesson),
)
```

### CommentCard (A crear)
Tarjeta para mostrar un comentario.

```dart
CommentCard(
  comment: commentEntity,
  onLike: () => likeComment(comment.id),
  onDelete: () => deleteComment(comment.id),
)
```

---

## 💾 Datos de Ejemplo

El sistema incluye datos de ejemplo en `ProgramsLocalDataSource`:

### Programa VIP

**Nivel 1: Fundamentos** ✅ (Desbloqueado)
- Clase 1: Introducción al Acordeón Vallenato (10 min)
- Clase 2: Postura y Técnica Básica (15 min)
- Clase 3: Primeros Acordes (20 min)

**Nivel 2: Técnicas Intermedias** 🔒 (Bloqueado)
- Clase 4: Escalas y Digitación (25 min)
- Clase 5: Ritmos Tradicionales (30 min)

**Nivel 3: Técnicas Avanzadas** 🔒 (Bloqueado)
- Clase 6: Improvisación y Creatividad (35 min)
- Clase 7: Técnicas de Ornamentación (30 min)

**Total:** 3 niveles, 7 clases, 165 minutos de contenido

---

## 🔧 Uso con Provider

### Cargar Programas
```dart
final programsProvider = Provider.of<ProgramsProvider>(context);

// Cargar todos los programas
await programsProvider.loadPrograms();

// Acceder a los programas
final programs = programsProvider.programs;
```

### Seleccionar Programa y Nivel
```dart
// Seleccionar programa
await programsProvider.selectProgram('prog-001');

// Obtener programa seleccionado
final program = programsProvider.selectedProgram;

// Seleccionar nivel
programsProvider.selectLevel(program.levels.first);

// Obtener nivel seleccionado
final level = programsProvider.selectedLevel;
```

### Trabajar con Clases
```dart
// Seleccionar clase
programsProvider.selectLesson(lesson);

// Marcar como completada
await programsProvider.markLessonAsCompleted(lesson.id);
```

### Gestionar Comentarios
```dart
// Cargar comentarios de una clase
await programsProvider.loadComments(lesson.id);

// Obtener comentarios
final comments = programsProvider.comments;

// Agregar comentario
await programsProvider.addComment(
  lessonId: lesson.id,
  userId: user.uid,
  userName: user.displayName ?? 'Usuario',
  userPhotoUrl: user.photoURL,
  content: 'Excelente clase!',
);

// Dar like
await programsProvider.likeComment(comment.id, user.uid);

// Eliminar
await programsProvider.deleteComment(comment.id, lesson.id);
```

---

## 🎯 Próximos Pasos

### UI a Crear
- [ ] **LevelPage** - Página para mostrar clases de un nivel
- [ ] **LessonPage** - Página con video y comentarios
- [ ] **ProgressIndicator** - Widget de progreso visual
- [ ] **CommentSection** - Sección de comentarios
- [ ] **VideoPlayer** - Reproductor mejorado

### Features Adicionales
- [ ] Certificados al completar programa
- [ ] Descargar clases offline
- [ ] Subtítulos en videos
- [ ] Quiz por nivel
- [ ] Ranking de estudiantes
- [ ] Notificaciones de nuevas clases

### Mejoras Técnicas
- [ ] Persistencia con Firestore
- [ ] Caché de videos
- [ ] Analytics de progreso
- [ ] Tests unitarios
- [ ] Tests de integración

---

## ✅ Estado Actual

### ✨ Implementado
- ✅ Arquitectura limpia completa
- ✅ Entidades (Program, Level, Lesson, Comment)
- ✅ Models con JSON parsing
- ✅ DataSources (local + comments)
- ✅ Repository pattern
- ✅ Provider para state management
- ✅ Datos de ejemplo
- ✅ Integración con HomePage
- ✅ Cálculo de progreso
- ✅ Sistema de comentarios
- ✅ Likes en comentarios

### 🚧 En Progreso
- Páginas de UI para niveles y clases
- Reproductor de video mejorado
- Persistencia con Firebase

---

**📅 Actualizado:** Octubre 1, 2025  
**🎯 Proyecto:** Comunidad Acordeoneros  
**🛠️ Tecnología:** Flutter + Clean Architecture + Provider

