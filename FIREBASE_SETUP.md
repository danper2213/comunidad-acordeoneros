# Configuración Completa de Firebase

## 🚀 Guía Paso a Paso para Configurar Firebase

### Prerequisitos

1. **Firebase CLI instalado**:
   ```bash
   npm install -g firebase-tools
   ```

2. **Autenticación en Firebase**:
   ```bash
   firebase login
   ```

3. **Verificar proyecto**:
   ```bash
   firebase projects:list
   ```

### 📋 Pasos de Configuración

#### 1. Verificar Configuración Actual

Tu proyecto ya está configurado con:
- **Project ID**: `app-acordeoneros`
- **Firebase Options**: Configurado en `lib/firebase_options.dart`
- **Google Services**: Configurado en `android/app/google-services.json`

#### 2. Desplegar Reglas de Seguridad

Ejecuta el script de despliegue:

```bash
dart run scripts/deploy_firebase.dart
```

Este script:
- ✅ Verifica que Firebase CLI esté instalado
- ✅ Verifica que estés autenticado
- ✅ Despliega reglas de Firestore
- ✅ Despliega índices de Firestore
- ✅ Despliega reglas de Storage

#### 3. Inicializar Base de Datos

Ejecuta el script de inicialización:

```bash
dart run scripts/initialize_firebase.dart
```

Este script crea:
- 📚 **2 Programas de ejemplo**
- 📖 **6 Niveles organizados**
- 🎵 **12 Lecciones con contenido**

#### 4. Verificar en Consola de Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto `app-acordeoneros`
3. Verifica que las siguientes colecciones existan:
   - `programs`
   - `levels`
   - `lessons`

### 🏗️ Estructura de Datos Creada

#### Colección: `programs`
```json
{
  "id": "program_basico_acordeon",
  "name": "Curso Básico de Acordeón",
  "description": "Aprende los fundamentos del acordeón desde cero...",
  "imageUrl": "assets/images/fer-festival.jpg",
  "instructor": "María González",
  "isActive": true,
  "levels": [],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Colección: `levels`
```json
{
  "id": "level_basico_1",
  "programId": "program_basico_acordeon",
  "name": "Introducción al Acordeón",
  "description": "Conoce las partes del acordeón...",
  "order": 1,
  "isUnlocked": true,
  "progress": 0.0,
  "lessons": [],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Colección: `lessons`
```json
{
  "id": "lesson_basico_1_1",
  "programId": "program_basico_acordeon",
  "levelId": "level_basico_1",
  "title": "Conociendo tu Acordeón",
  "description": "Aprende sobre las diferentes partes...",
  "videoUrl": "assets/videos/test.mp4",
  "thumbnailUrl": "assets/images/fer-festival.jpg",
  "duration": 600,
  "order": 1,
  "isCompleted": false,
  "views": 0,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### 🔐 Reglas de Seguridad

#### Firestore Rules
- ✅ **Lectura**: Solo usuarios autenticados
- ✅ **Escritura**: Solo usuarios autenticados
- ✅ **Validaciones**: Campos requeridos y tipos correctos
- ✅ **Estructura**: Validación de estructura de datos

#### Storage Rules
- ✅ **Programas**: Imágenes máximo 10MB
- ✅ **Lecciones**: Videos máximo 500MB, imágenes máximo 5MB
- ✅ **Usuarios**: Avatares máximo 5MB
- ✅ **Tipos**: Solo archivos de imagen y video

### 📊 Índices de Firestore

Se han creado índices optimizados para:
- Búsqueda por programa activo y fecha
- Búsqueda por instructor
- Niveles ordenados por programa
- Lecciones ordenadas por nivel
- Comentarios por programa y fecha
- Progreso de usuario por programa

### 🧪 Datos de Prueba Creados

#### Programa 1: Curso Básico de Acordeón
- **Nivel 1**: Introducción al Acordeón (2 lecciones)
- **Nivel 2**: Escalas y Acordes Básicos (2 lecciones)
- **Nivel 3**: Primeras Melodías (2 lecciones)

#### Programa 2: Técnicas Avanzadas
- **Nivel 1**: Acordeón Diatónico (2 lecciones)
- **Nivel 2**: Ornamentos y Adornos (2 lecciones)
- **Nivel 3**: Estilos Musicales (2 lecciones)

### 🔧 Comandos Útiles

#### Verificar Estado de Firebase
```bash
firebase status
```

#### Ver Logs de Despliegue
```bash
firebase deploy --only firestore:rules --debug
```

#### Limpiar Base de Datos (CUIDADO)
```bash
# Solo si necesitas empezar de cero
firebase firestore:delete --recursive programs
firebase firestore:delete --recursive levels
firebase firestore:delete --recursive lessons
```

#### Ver Reglas Activas
```bash
firebase firestore:rules
firebase storage:rules
```

### 🚨 Solución de Problemas

#### Error: "Permission denied"
- Verifica que las reglas estén desplegadas
- Asegúrate de estar autenticado en la app
- Revisa los logs en Firebase Console

#### Error: "Index not found"
- Los índices se crean automáticamente cuando se usan
- Puede tomar unos minutos en aparecer
- Verifica en Firebase Console > Firestore > Indexes

#### Error: "Storage permission denied"
- Verifica que las reglas de Storage estén desplegadas
- Revisa el tamaño y tipo de archivo
- Asegúrate de estar autenticado

### 📱 Próximos Pasos

1. **Probar la App**: Ejecuta la aplicación y verifica que los datos aparezcan
2. **Crear Contenido**: Usa el panel de administración para crear nuevos programas
3. **Subir Archivos**: Prueba la funcionalidad de subida de imágenes y videos
4. **Monitorear**: Revisa los logs en Firebase Console para verificar funcionamiento

### 🎯 Funcionalidades Disponibles

Con esta configuración, tu app puede:
- ✅ Crear, editar y eliminar programas
- ✅ Gestionar niveles y lecciones
- ✅ Subir imágenes y videos
- ✅ Autenticación de usuarios
- ✅ Almacenamiento seguro
- ✅ Consultas optimizadas
- ✅ Reglas de seguridad

### 📞 Soporte

Si encuentras problemas:
1. Revisa los logs en Firebase Console
2. Verifica que las reglas estén desplegadas
3. Asegúrate de estar autenticado
4. Comprueba la conectividad a internet

¡Tu sistema CRUD está completamente configurado y listo para usar! 🎉
