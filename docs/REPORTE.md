# NewsFlow — Reporte del Proyecto

## 1. Introducción

Al iniciar este proyecto, cuento con aproximadamente 5 años de experiencia en programación,. Había explorado Flutter de forma superficial antes, pero nunca había construido algo significativo con este — este proyecto fue mi primera inmersión real en el framework.

En cuanto al backend, no partí desde cero con Firebase. Anteriormente había trabajado con Firebase Cloud Messaging para notificaciones push, así que ya me sentía cómodo con el ecosistema de Firebase en general. Sin embargo, Firestore y Firebase Cloud Storage eran servicios que nunca había utilizado, por lo que este proyecto me llevó a territorio nuevo tanto en el frontend como en el backend.

---

## 2. Proceso de Aprendizaje

Como Flutter era nuevo para mí a este nivel, tuve que aprender bastante en poco tiempo. Mis principales recursos fueron:

- **Cursos en YouTube** — tutoriales cortos y enfocados para ponerme al día rápidamente con widgets, navegación y gestión de estado en Flutter.
- **Documentación oficial de Flutter** — la documentación de Flutter es excelente y la consulté constantemente durante el desarrollo.
- **Asistencia con IA** — utilizada para entender conceptos más rápido, aclarar dudas y tomar decisiones arquitectónicas. Más sobre esto en la siguiente sección.

La transición mental a Flutter fue más fluida de lo esperado. El árbol de widgets de Flutter se sintió más estructurado y predecible que los componentes JSX. El hecho de que todo sea un widget — padding, estilos, layout — hizo que el código de UI fuera más consistente y fácil de razonar.

Para Firebase específicamente, tuve que aprender el modelo de documentos y colecciones de Firestore, la sintaxis de las reglas de seguridad y la API de Cloud Storage. La CLI de FlutterFire hizo que la conexión inicial entre Flutter y Firebase fuera sorprendentemente sencilla.

---

## 3. Desarrollo con IA

Esta aplicación completa fue construida desde cero usando IA — específicamente **Claude Code** de Anthropic.

Fue una decisión deliberada, y una que creo que refleja hacia dónde se dirige el desarrollo de software. Mi punto de vista es que **hoy en día ya no es estrictamente necesario aprender cada nueva tecnología desde cero antes de usarla de forma productiva**. Lo que importa más es saber cómo trabajar con la IA de manera efectiva para que ella haga el trabajo pesado mientras tú mantienes el control de la dirección y la calidad del resultado.

Dicho esto, trabajar con IA no es simplemente escribir prompts y aceptar lo que devuelve. Durante este proyecto apliqué las siguientes buenas prácticas:

- **Revisar todo lo que genera la IA.** Leí cada archivo, cada función, cada cambio antes de aceptarlo. La IA puede generar código que parece correcto pero tiene bugs sutiles o incompatibilidades arquitectónicas con el resto del proyecto.
- **Dar instrucciones precisas y con contexto.** Los prompts vagos producen resultados vagos. Cuanto más específica es la instrucción — incluyendo restricciones, patrones existentes y comportamiento esperado — mejor es el resultado.
- **Detectar y corregir errores.** Hubo bugs de serialización, imports faltantes, malas configuraciones en las reglas de Firestore, y más. Identificarlos requirió entender el código lo suficiente como para notar cuando algo estaba mal, aunque la IA lo hubiera escrito.
- **Ser dueño de la arquitectura.** Las decisiones de alto nivel — Clean Architecture, BLoC, el diseño del esquema de Firestore, la estructura de carpetas en Storage — fueron guiadas y validadas por mí. La IA ejecuta; el desarrollador dirige.
- **Iterar, no solo aceptar.** Cuando una solución generada no encajaba, respondía con feedback específico en lugar de trabajar alrededor de un resultado malo.

El resultado es una aplicación Flutter completamente funcional, conectada a un backend real de Firebase — construida en una fracción del tiempo que hubiera tomado aprender Flutter y Firestore desde cero de manera tradicional.

No se trata de reemplazar el conocimiento del desarrollador. Se trata de **usar la IA como multiplicador de fuerza** — y saber usar ese multiplicador de forma responsable es en sí mismo una habilidad que vale la pena desarrollar.

---

## 4. Desafíos Encontrados

Siendo honesto, la parte más difícil de todo el proyecto fue la **configuración inicial del entorno**. Es algo que todo desarrollador conoce pero nadie habla lo suficiente — alinear todas las herramientas, SDKs, versiones de CLI y dependencias para que funcionen juntas tomó tiempo considerable. Siempre había pequeños problemas: paquetes desactualizados, conflictos de versiones del SDK, variables de entorno mal configuradas, la CLI de Firebase sin detectar el directorio del proyecto. Cada vez que se solucionaba algo, aparecía otra cosa.

Una vez estable el entorno, el desarrollo en sí fue mucho más fluido. Pero esa fase inicial peleando con las herramientas fue genuinamente la parte más frustrante de la experiencia.

---

## 5. Reflexión y Direcciones Futuras

### Lo que más me gustó

La parte más interesante del proyecto fue **conectar el frontend de Flutter con Firebase**. Hay algo satisfactorio en ver datos que sembraste con un script de Node.js aparecer en vivo en una app móvil — con imágenes subidas a Firebase Storage, URLs almacenadas en Firestore, y la app renderizando todo correctamente. El ciclo completo desde el script del backend hasta la UI móvil se sintió completo.

También disfruté Flutter mucho más de lo que esperaba. Habiendo usado React Native antes, entré pensando que la experiencia sería similar, pero Flutter se sintió más intuitivo y cómodo para trabajar. El sistema de widgets es consistente, el hot reload es rápido, y la experiencia general del desarrollador es muy pulida.

### Qué haría diferente

Si empezara este proyecto desde cero, **conectaría Firebase desde el primer día** en lugar de construir primero con datos simulados. Aunque el enfoque mock-first es arquitectónicamente limpio y el cambio de datasource es sencillo, invertí tiempo extra depurando problemas de integración que habrían aparecido antes si Firebase hubiera estado conectado desde el inicio. Trabajar con datos reales desde el principio habría detectado incompatibilidades del esquema y bugs de serialización mucho más temprano.

### Mejoras Futuras

- **Firebase Authentication** — inicio de sesión con Google/Apple, y sincronización de bookmarks entre dispositivos vía Firestore en lugar de SharedPreferences.
- **Paginación** — paginación basada en cursor de Firestore (`startAfterDocument`) para feeds de artículos grandes.
- **Notificaciones push** — Firebase Cloud Messaging para alertas de noticias de última hora.
- **Búsqueda de texto completo** — integración con Algolia o Typesense para reemplazar el filtrado actual del lado del cliente.
- **Pipeline CI/CD** — GitHub Actions: analyze → test → build → Firebase App Distribution.
- **Pruebas unitarias y de widgets** — casos de uso del dominio probados con `mocktail`, BLoC con `bloc_test`.

---

## 6. Demo del Proyecto

### Capturas de Pantalla y Video Demo

> 📁 [Ver capturas de pantalla y video demo completo en Google Drive](https://drive.google.com/drive/folders/1fOYS0WQBOypDe93tqgT2f5euSjuVYi91?usp=drive_link)

---

## 7. Sobreentrega

Más allá de los requisitos principales, se implementaron varias características adicionales:

### Subida de Imagen al Crear un Artículo

La pantalla de Crear Artículo permite a los usuarios adjuntar una imagen desde la galería del dispositivo. Al publicar:

1. La imagen se sube a Firebase Cloud Storage en `media/articles/user_{timestamp}.jpg`.
2. La URL de descarga pública se guarda en el campo `thumbnailURL` del artículo en Firestore.
3. El artículo aparece inmediatamente en el feed con la imagen subida.

Esto demuestra el flujo completo de escritura: galería del dispositivo → Storage → Firestore → en vivo en el feed.

### Toggle de Tema (Claro / Oscuro / Sistema)

Se implementó un `ThemeCubit` que cicla entre los modos claro → oscuro → sistema. El modo seleccionado se persiste entre sesiones usando `SharedPreferences`, por lo que la preferencia del usuario se recuerda al cerrar la app.

### Skeletons de Carga con Shimmer

En lugar de un spinner simple, la app muestra placeholders animados con efecto shimmer mientras los artículos cargan — incluyendo al cambiar de categoría, donde el shimmer reemplaza la lista hasta que llegan los nuevos datos. Esto mejora el rendimiento percibido y da a la app una sensación más pulida.

### Deslizar para Eliminar en Bookmarks

La lista de bookmarks soporta deslizar para eliminar usando el widget `Dismissible` de Flutter, con un fondo rojo e ícono de eliminar que se revela al deslizar — una interacción que se siente nativa.

### Script de Seed con Firebase Storage

El script de seed del backend (`backend/scripts/seed.js`) va más allá de insertar datos de texto. Hace lo siguiente:

1. Descarga imágenes de Unsplash para cada artículo.
2. Las sube a Firebase Cloud Storage bajo `media/articles/`.
3. Guarda la URL pública de Storage en el campo `thumbnailURL` de Firestore.

Esto significa que la app no tiene ninguna dependencia en Unsplash ni en ningún CDN de imágenes externo en tiempo de ejecución — todas las imágenes se sirven desde Firebase Storage.

### Prototipo de Arquitectura — Diagrama de Clean Architecture

El proyecto sigue Clean Architecture con tres capas por feature:

```
┌─────────────────────────────────────────────┐
│           Capa de Presentación               │
│         BLoC / Cubit · Pages · Widgets       │
└────────────────────┬────────────────────────┘
                     │ llama casos de uso
┌────────────────────▼────────────────────────┐
│             Capa de Dominio                  │
│  Entidades · Casos de Uso · Interfaz Repo    │
│      (sin imports de Flutter/Firebase)       │
└────────────────────┬────────────────────────┘
                     │ implementada por
┌────────────────────▼────────────────────────┐
│              Capa de Datos                   │
│  Models · Firestore DataSource · Repo Impl   │
│         Mock DataSource (para testing)       │
└─────────────────────────────────────────────┘
```

El beneficio clave: cambiar Firebase por cualquier otro backend solo requiere modificar el registro del datasource en `injection_container.dart` — las capas de dominio y presentación no se ven afectadas en absoluto.

### Cómo Mejorar Más

- **Offline-first** — la persistencia offline integrada de Firestore ya cachea las lecturas. Agregar una capa local de SQLite permitiría consultas offline más ricas y un modo offline completamente funcional.
- **Firebase Remote Config** — feature flags para lanzamientos graduales sin necesidad de actualizaciones en la tienda de aplicaciones.
- **Analytics de artículos** — eventos de Firebase Analytics para aperturas de artículos, cambios de categoría y consultas de búsqueda para entender el comportamiento del usuario.
- **Contadores de vistas distribuidos** — reemplazar el incremento actual del campo `views` con una Firebase Cloud Function para evitar condiciones de carrera a escala.

---

## 8. Notas Adicionales

### Resumen del Stack Tecnológico

| Capa | Tecnología |
|---|---|
| Frontend | Flutter (Dart) |
| Gestión de Estado | BLoC / Cubit |
| Navegación | go_router |
| Inyección de Dependencias | GetIt |
| Base de Datos | Firebase Firestore |
| Almacenamiento de Archivos | Firebase Cloud Storage |
| Persistencia Local | SharedPreferences |
| Carga de Imágenes | CachedNetworkImage |
| Arquitectura | Clean Architecture |
| Herramienta IA | Claude Code (Anthropic) |

### Repositorio

Ambas ramas están disponibles en GitHub:
- `master` — implementa el diseño solicitado en el brief del proyecto, con integración completa de Firebase
- `custom-design` — implementa mi propio diseño personalizado, construido a mi gusto con mayor polish de UI, animaciones y características adicionales más allá de los requisitos
