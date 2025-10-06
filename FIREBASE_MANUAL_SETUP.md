# Configuración Manual de Firebase

## 🚀 Guía Paso a Paso

### 1. Autenticarse en Firebase

Abre una terminal en tu proyecto y ejecuta:

```bash
npx firebase login
```

Esto abrirá tu navegador web para autenticarte con tu cuenta de Google.

### 2. Verificar el Proyecto

Después del login, verifica que estés en el proyecto correcto:

```bash
npx firebase projects:list
```

Deberías ver `app-acordeoneros` en la lista.

### 3. Configurar el Proyecto por Defecto

```bash
npx firebase use app-acordeoneros
```

### 4. Desplegar Reglas de Firestore

```bash
npx firebase deploy --only firestore:rules
```

### 5. Desplegar Índices de Firestore

```bash
npx firebase deploy --only firestore:indexes
```

### 6. Desplegar Reglas de Storage

```bash
npx firebase deploy --only storage
```

### 7. Verificar el Despliegue

```bash
npx firebase firestore:rules
npx firebase storage:rules
```

## 📱 Probar la Aplicación

Una vez configurado Firebase:

1. **Ejecuta la aplicación**:
   ```bash
   flutter run
   ```

2. **Accede al panel de administración**:
   - Toca el botón de administración en el AppBar
   - Verifica que puedas ver el dashboard

3. **Crea un programa de prueba**:
   - Toca "Nuevo Programa"
   - Llena el formulario
   - Sube una imagen desde la galería
   - Guarda el programa

4. **Verifica en Firebase Console**:
   - Ve a [Firebase Console](https://console.firebase.google.com/)
   - Selecciona tu proyecto `app-acordeoneros`
   - Ve a Firestore Database
   - Verifica que aparezca tu programa creado

## 🔧 Comandos Útiles

```bash
# Ver estado del proyecto
npx firebase use

# Ver reglas activas
npx firebase firestore:rules
npx firebase storage:rules

# Abrir consola de Firebase
npx firebase open

# Ver logs de despliegue
npx firebase deploy --debug
```

## 🚨 Solución de Problemas

### Error: "Permission denied"
- Verifica que las reglas estén desplegadas
- Asegúrate de estar autenticado en la app
- Revisa los logs en Firebase Console

### Error: "Project not found"
- Ejecuta: `npx firebase use app-acordeoneros`
- Verifica que el proyecto existe en tu cuenta

### Error: "Authentication failed"
- Ejecuta: `npx firebase logout` y luego `npx firebase login`
- Asegúrate de usar la cuenta correcta de Google

## 📊 Estructura de Datos

Una vez que Firebase esté configurado, podrás crear:

- **Programas**: Con información básica e imagen
- **Niveles**: Organizados dentro de cada programa
- **Lecciones**: Con videos y contenido educativo

## 🎯 Próximos Pasos

1. Configura Firebase siguiendo los pasos arriba
2. Ejecuta la aplicación
3. Prueba crear contenido en el panel de administración
4. Verifica que todo se guarde correctamente en Firebase

¡Tu sistema CRUD estará completamente funcional! 🎉
