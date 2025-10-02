# 🧪 Guía de Testing - Comunidad Acordeoneros

## 🚀 Cómo Probar la App Completa

---

## 📱 Ejecutar la App

```bash
# 1. Asegurarse de tener las dependencias
flutter pub get

# 2. Ejecutar la app
flutter run
```

---

## 🔐 1. Testing de Autenticación

### Registro de Usuario
1. Abrir la app
2. Click en **"Regístrate aquí"**
3. Ingresar:
   - Nombre: `Juan Pérez`
   - Email: `juan@test.com`
   - Contraseña: `123456`
   - Confirmar: `123456`
4. Click en **"Crear cuenta"**
5. ✅ **Esperado:** Navega a HomePage con tu nombre

### Login con Email
1. Si ya tienes cuenta, ingresa:
   - Email: `juan@test.com`
   - Contraseña: `123456`
2. Click en **"Iniciar sesión"**
3. ✅ **Esperado:** Navega a HomePage

### Google Sign In
1. Click en el botón de **Google** (icono G)
2. Seleccionar cuenta de Google
3. ✅ **Esperado:** Navega a HomePage con foto de perfil

### Logout
1. En HomePage, click en **icono de logout** (o abrir drawer)
2. Confirmar en el diálogo
3. ✅ **Esperado:** Vuelve a LoginPage

---

## 📚 2. Testing de Programas

### Ver Programa
1. En **HomePage**, ver el programa "Programa VIP"
2. Click en el programa
3. ✅ **Esperado:** 
   - Navega a DetailProgramPage
   - Muestra 3 niveles
   - Progreso general: 0%
   - Nivel 1 desbloqueado 🔓
   - Niveles 2 y 3 bloqueados 🔒

### Ver Niveles
1. En DetailProgramPage
2. **Nivel 1** (desbloqueado)
   - Badge: "En progreso"
   - Barra de progreso: 0%
   - Click en el nivel
3. ✅ **Esperado:**
   - Diálogo con 3 clases
   - Todas con icono ▶️ (pendientes)

### Ver Clases del Nivel
1. En el diálogo, click **"Ver clases"**
2. ✅ **Esperado:**
   - Navega a LevelLessonsPage
   - Muestra 3 clases listadas
   - Progreso del nivel: 0%
   - Clase 1: Introducción (10 min)
   - Clase 2: Postura (15 min)
   - Clase 3: Primeros Acordes (20 min)

---

## 📹 3. Testing de Reproducción

### Ver Clase con Video
1. En LevelLessonsPage, click en **Clase 1**
2. ✅ **Esperado:**
   - Navega a LessonDetailPage
   - Video se carga
   - Muestra título: "Introducción al Acordeón Vallenato"
   - Muestra duración: 10 min
   - Botón "Marcar como completada" visible
   - Botones de navegación:
     - **Anterior:** Deshabilitado (primera clase)
     - **Siguiente:** Habilitado

### Reproducir Video
1. Click en el **video**
2. ✅ **Esperado:**
   - Video comienza a reproducirse
   - Click nuevamente → pausa
   - Controles overlay funcionando

---

## 🔄 4. Testing de Navegación entre Clases

### Navegar Siguiente
1. En **Clase 1**, click en **"Siguiente"**
2. ✅ **Esperado:**
   - Video se reinicia
   - Muestra **Clase 2: Postura y Técnica Básica**
   - Duración: 15 min
   - Ambos botones habilitados
   - Comentarios se recargan (vacíos)

### Navegar Anterior
1. En **Clase 2**, click en **"Anterior"**
2. ✅ **Esperado:**
   - Vuelve a **Clase 1**
   - Video se reinicia
   - Botón "Anterior" deshabilitado
   - Botón "Siguiente" habilitado

### Navegar Hasta el Final
1. Desde Clase 1, click **"Siguiente"** → Clase 2
2. Desde Clase 2, click **"Siguiente"** → Clase 3
3. ✅ **Esperado en Clase 3:**
   - Título: "Primeros Acordes"
   - Botón "Anterior" habilitado
   - Botón "Siguiente" deshabilitado (última clase)

---

## 📊 5. Testing de Progreso

### Completar Primera Clase
1. En **Clase 1**, ver el video
2. Click en **"Marcar como completada"**
3. ✅ **Esperado:**
   - SnackBar verde: "¡Clase completada! 🎉"
   - Botón desaparece
   - Clase marcada localmente

### Verificar Progreso
1. Click en **← Atrás** para volver a LevelLessonsPage
2. ✅ **Esperado:**
   - Clase 1 tiene icono ✓ verde
   - Progreso del nivel: **33%** (1/3)
   - Barra de progreso actualizada

### Completar Todas las Clases
1. Entrar a **Clase 2**
2. Marcar como completada → 66%
3. Click "Siguiente" → **Clase 3**
4. Marcar como completada → 100%
5. ✅ **Esperado:**
   - Progreso: 100%
   - ¡Nivel completado! ✅

### Verificar Desbloqueo de Nivel
1. Volver a **DetailProgramPage**
2. ✅ **Esperado:**
   - **Nivel 1:** Badge "Completado" (verde)
   - **Nivel 1:** Progreso 100%
   - **Nivel 2:** 🔓 DESBLOQUEADO
   - **Nivel 2:** Badge "En progreso"
   - **Progreso general:** 42% (3/7 clases)

---

## 💬 6. Testing de Comentarios

### Agregar Comentario
1. En cualquier clase, scroll hasta **Comentarios**
2. Ver campo de texto con tu avatar
3. Escribir: `"Excelente clase!"`
4. Click en **botón enviar** (icono →)
5. ✅ **Esperado:**
   - Comentario aparece en la lista
   - Con tu nombre y avatar
   - Timestamp: "Ahora"
   - 0 likes

### Dar Like a Comentario
1. Click en el **icono de corazón** de tu comentario
2. ✅ **Esperado:**
   - Corazón se llena (rojo)
   - Contador: 1 like
3. Click nuevamente
4. ✅ **Esperado:**
   - Corazón se vacía
   - Contador: 0 likes

### Eliminar Comentario
1. En tu comentario, click en **icono de basura** 🗑️
2. Confirmar en el diálogo
3. ✅ **Esperado:**
   - Comentario desaparece
   - Vuelve al estado vacío

### Múltiples Comentarios
1. Agregar varios comentarios
2. ✅ **Esperado:**
   - Se ordenan por fecha (más reciente arriba)
   - Contador de comentarios actualizado
   - Cada uno con su timestamp

---

## 🔄 7. Testing de Flujo Completo

### Recorrido Completo
```
1. ✅ Registrarse/Login
2. ✅ Ver HomePage con programa
3. ✅ Click en Programa VIP
4. ✅ Ver 3 niveles (1 desbloqueado)
5. ✅ Click en Nivel 1
6. ✅ Ver diálogo con 3 clases
7. ✅ Click "Ver clases"
8. ✅ Ver lista de 3 clases (progreso 0%)
9. ✅ Click en Clase 1
10. ✅ Ver video
11. ✅ Marcar como completada
12. ✅ Click "Siguiente" → Clase 2
13. ✅ Marcar como completada
14. ✅ Click "Siguiente" → Clase 3
15. ✅ Agregar comentario: "¡Me encantó!"
16. ✅ Dar like al comentario
17. ✅ Marcar Clase 3 como completada
18. ✅ Volver a DetailProgram
19. ✅ Ver Nivel 1: 100% completado ✅
20. ✅ Ver Nivel 2: Desbloqueado 🔓
21. ✅ Click en Nivel 2
22. ✅ Ver sus 2 clases (Escalas, Ritmos)
23. ✅ Logout
24. ✅ Login nuevamente
25. ✅ Verificar que progreso persiste
```

---

## 🎨 8. Testing Visual

### Verificar Estilos
- ✅ Gradientes en fondos
- ✅ Colores consistentes
- ✅ Tipografía clara
- ✅ Espaciado uniforme
- ✅ Hero animations

### Verificar Estados
- ✅ Loading indicators
- ✅ Estados vacíos (sin comentarios)
- ✅ Botones disabled
- ✅ Barras de progreso
- ✅ Badges de estado

### Verificar Feedback
- ✅ SnackBars (errores, éxitos)
- ✅ Diálogos de confirmación
- ✅ Ripple effects
- ✅ Transiciones suaves

---

## ⚠️ 9. Testing de Edge Cases

### Navegación
- ✅ Primera clase → "Anterior" deshabilitado
- ✅ Última clase → "Siguiente" deshabilitado
- ✅ Cambio de video sin errores
- ✅ Comentarios se recargan correctamente

### Progreso
- ✅ No se puede marcar 2 veces
- ✅ Botón desaparece al completar
- ✅ Progreso no supera 100%
- ✅ Desbloqueo solo con 100%

### Comentarios
- ✅ No enviar comentario vacío
- ✅ Solo eliminar propios comentarios
- ✅ Likes con toggle correcto
- ✅ Timestamps correctos

---

## 📊 Checklist de Aprobación

Marcar cada item al probarlo:

### Autenticación
- [ ] Registro funciona
- [ ] Login funciona
- [ ] Google Sign In funciona
- [ ] Logout funciona
- [ ] Sesión persiste

### Programas
- [ ] HomePage muestra programa
- [ ] DetailProgram muestra niveles
- [ ] Progreso general se muestra
- [ ] Solo Nivel 1 desbloqueado

### Clases
- [ ] LevelLessons muestra 3 clases
- [ ] Progreso del nivel en 0%
- [ ] Todas las clases clickeables

### Video y Navegación
- [ ] Video reproduce correctamente
- [ ] Botón "Siguiente" funciona
- [ ] Botón "Anterior" funciona
- [ ] Estados disabled correctos
- [ ] Video cambia al navegar

### Progreso
- [ ] Marcar como completada funciona
- [ ] SnackBar aparece
- [ ] Botón desaparece
- [ ] Progreso se actualiza
- [ ] Volver muestra ✓ verde
- [ ] Nivel 2 se desbloquea al 100%

### Comentarios
- [ ] Agregar comentario funciona
- [ ] Comentario aparece
- [ ] Dar like funciona
- [ ] Eliminar funciona
- [ ] Timestamps correctos

---

## ✅ Criterios de Éxito

### La app está lista si:
- ✅ Puedes registrarte e iniciar sesión
- ✅ Ves el Programa VIP en HomePage
- ✅ Puedes navegar: Programa → Niveles → Clases
- ✅ El video reproduce
- ✅ Puedes navegar entre clases con botones
- ✅ El progreso se actualiza al completar
- ✅ Nivel 2 se desbloquea al completar Nivel 1
- ✅ Puedes comentar y dar likes
- ✅ Todo funciona sin errores

---

## 🎯 Flujo de Testing Recomendado

### 🏃 Test Rápido (5 minutos)
1. Login
2. Ver programa
3. Entrar a una clase
4. Reproducir video
5. Navegar con "Siguiente"
6. Marcar como completada

### 🚶 Test Completo (15 minutos)
1. Registro de usuario
2. Ver programa completo
3. Explorar todos los niveles
4. Ver todas las clases del Nivel 1
5. Completar las 3 clases
6. Verificar desbloqueo de Nivel 2
7. Agregar comentarios
8. Dar likes
9. Eliminar comentario
10. Logout y login nuevamente

### 🏋️ Test Exhaustivo (30 minutos)
- Probar todos los casos de edge
- Validar todos los mensajes de error
- Verificar todas las animaciones
- Probar en diferentes tamaños de pantalla
- Verificar performance
- Documentar bugs si los hay

---

## 🐛 Reporte de Issues

Si encuentras problemas:

```markdown
### Bug: [Título]

**Descripción:** [Qué pasó]

**Pasos para reproducir:**
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

**Resultado esperado:** [Qué debería pasar]

**Resultado actual:** [Qué pasó]

**Severidad:** Alta/Media/Baja

**Screenshots:** [Si aplica]
```

---

## ✅ Estado Esperado Después de Testing

- ✅ Autenticación funciona perfectamente
- ✅ Navegación fluida sin errores
- ✅ Progreso se actualiza correctamente
- ✅ Niveles se desbloquean automáticamente
- ✅ Comentarios funcionan
- ✅ UI responsive y atractiva
- ✅ Sin crashes ni errores críticos

---

## 🎉 ¡Listo para Probar!

**Ejecuta `flutter run` y empieza a explorar tu plataforma educativa completa.**

---

**📅 Guía creada:** Octubre 1, 2025  
**🎯 Proyecto:** Comunidad Acordeoneros  
**✅ Todo listo para testing**

