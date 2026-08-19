<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

[English](../../FEATURES.md) · [Українська](../uk/FEATURES.md)

# Características

## Características del proyecto

### Configuración de I2P renderizada con Jinja2

- El router, los túneles, los clientes, el wrapper y las opciones de la JVM se renderizan todos desde plantillas Jinja2 al inicio.
- Cada subsistema de I2P (SAM, IRC, POP3, SMTP, Jetty, SSH, lanzamiento del navegador) se puede activar o desactivar mediante variables de entorno.
- La longitud y la cantidad de túneles de entrada y salida son configurables por túnel de eepsite.

### Alojamiento de eepsites con identidad persistente

- La capacidad de proxy inverso publica un servicio local como eepsite de I2P (sitio oculto).
- La clave de identidad del eepsite persiste entre reinicios mediante un volumen Docker.
- La clave de identidad se puede cargar desde secretos Docker para direcciones `.b32.i2p` reproducibles.
- La dirección `.b32.i2p` se extrae y registra automáticamente al inicio.
- Comando de generación de claves disponible mediante el tipo de secreto `docker-run`.
- Cabecera Host suplantada configurable para el frente Traefik con HostRegexp.

### Router de anonimato I2P

- Router I2P completo instalado mediante instalador silencioso con verificación de hash.
- Consola del router accesible en el puerto 7657 con enrutado Traefik.
- Proxy HTTP (puerto 4444) para navegar eepsites de I2P; proxy HTTPS disponible (desactivado por defecto).
- Detección de IPv4 tras cortafuegos, IPv6 desactivado y UPnP desactivado por defecto para un recorrido de NAT predecible.
- Memoria de la JVM limitada por defecto a un heap de 128m a 256m, configurable mediante el entorno.

## Heredado de B19/Ubuntu 1.4.0

### Caché APT persistente entre compilaciones

- Las cachés de paquetes e índices de APT sobreviven entre compilaciones mediante montajes de caché de BuildKit, con clave por serie de Ubuntu y arquitectura.
- Las compilaciones repetidas reutilizan los paquetes descargados en lugar de volver a descargarlos.
- Proxy opcional de caché APT en LAN, se activa con `M6E_APT_CACHE_HOST`.

### Gestión de procesos de servicio con enrutado de logs (b19-exec)

- Los procesos de larga duración (demonios, servidores) tienen stdout y stderr enrutados automáticamente a través del logger estructurado.
- Se hace seguimiento del PID del servicio para el reenvío de señales: Docker stop termina de forma elegante el proceso principal.
- Los niveles de log de los flujos stdout y stderr se configuran de forma independiente.
- El código de salida del servicio se captura y queda disponible para los hooks posteriores.

### Descargas de artefactos con caché y verificación de integridad (b19-fetch)

- Todas las descargas externas pasan por una caché de tres niveles: directorio local `.fetch/`, caché persistente de BuildKit y luego upstream vía aria2c con hasta 16 conexiones.
- Verificación SHA-512 opcional en cada nivel; un hash que no coincide provoca caída al siguiente nivel en lugar de fallo.
- El modo offgrid bloquea todas las descargas por completo, fallando rápido con un error claro si se produce un fallo de caché.
- Admite un proxy de near-cache para compilaciones solo-LAN que pasan por un proxy de caché.

### Ejecución de comandos temporizada con informe de fallos (b19-run)

- Cualquier comando puede envolverse para obtener medición automática del tiempo transcurrido e informe de éxito o fallo.
- La salida correcta solo es visible en niveles de verbosidad mayores; la salida de fallo siempre se muestra.
- En modo debug, la salida del comando se transmite en vivo en lugar de almacenarse en búfer.

### Inicialización de una sola vez (bootstrap.d)

- Las tareas de configuración únicas (migraciones de base de datos, creación del usuario administrador, init de directorios) se ejecutan solo en el primer arranque del contenedor.
- Idempotencia automática: los scripts completados no vuelven a ejecutarse jamás, ni siquiera entre reinicios del contenedor.
- Los scripts fallidos se reintentan en el siguiente arranque; los exitosos quedan bloqueados.
- El estado puede resetearse limpiando un volumen, lo que dispara un re-bootstrap completo.
- Las imágenes derivadas añaden sus propios scripts de init dejándolos caer en un directorio.

### Hooks de compilación modulares (build.d)

- Toda la lógica de compilación de la imagen vive en scripts de shell numerados en lugar de comandos `RUN` inline en el Dockerfile.
- Los hooks se organizan en fases `pre/on/post` y se autodescubren por el nombre de etapa pasado a `build-stage`.
- El ámbito reservado `always/{pre,post}` enmarca cada etapa, se llame como se llame, de modo que la configuración transversal se escribe una vez en lugar de por etapa.
- Los hooks heredables se propagan a las imágenes derivadas automáticamente vía superposición de capas de Docker: las derivadas obtienen gratis la lógica de compilación del padre.
- Los hooks no heredables se limpian tras su ejecución para evitar que se filtren en etapas posteriores.

### Detección automática del número de CPUs (NUMPROCS)

- Las CPUs disponibles se detectan automáticamente con la downward API de Kubernetes, cgroups v2 o `nproc` como respaldo.
- El recuento detectado está disponible como `NUMPROCS` durante toda la compilación y el runtime, y se usa para compilación paralela, renderizado de plantillas y ejecución de tests.
- Elimina los recuentos de jobs hardcodeados y garantiza un paralelismo consistente entre Docker, Kubernetes y CI.

### Gestión declarativa de dependencias (b19-deps)

- Los metadatos de dependencias externas (URL, versión, hash SHA-512) se guardan como archivos de texto plano, completamente separados de los scripts de compilación.
- Admite descargas específicas por arquitectura, series multiversión y rutas de componentes anidadas.
- Las dependencias se autodescubren al parsear el Makefile: añade archivos al directorio correcto y la compilación los recoge sin declaraciones manuales.
- `make fetch` predescarga todo para compilaciones offline; los cambios de versión disparan un re-fetch y una actualización de hashes automáticos.

### Sistema de arranque conectable (entrypoint.d)

- Cada arranque de contenedor pasa por una secuencia de hooks numerados: configuración de señales, carga de secretos, detección de CPU, validación de puertos, renderizado de plantillas, bootstrap y arranque del servicio.
- Los comandos ad hoc (`docker run img command`) saltan automáticamente parte de la cadena de arranque y se ejecutan directamente.
- Tanto los hooks individuales como el entrypoint completo pueden omitirse en runtime mediante variables de entorno, sin reconstruir la imagen.
- Las imágenes derivadas sobrescriben un único hook (slot 5000) para lanzar su servicio; todo lo demás se hereda.

### Conmutadores de funcionalidades para todos los subsistemas

- Cada subsistema mayor (entrypoint, healthchecks, bootstrap, tests, secrets, validación de puertos, i18n, shell hooks) puede desactivarse en runtime mediante variables de entorno.
- Los hooks individuales del entrypoint y del bootstrap pueden omitirse por nombre sin desactivar el subsistema entero.
- No hace falta reconstruir la imagen: los conmutadores son solo de runtime.

### Monitorización de estado integrada (healthcheck.d)

- Healthcheck nativo de Docker declarado en la imagen base y heredado por todas las imágenes derivadas sin configuración extra.
- Siete comprobaciones de estado por defecto: espacio en disco de los directorios home, caché y temporales; conectividad HTTPS, resolución DNS, ping ICMP; y escribibilidad del sistema de archivos.
- Las comprobaciones de red son tolerantes a fallos: el éxito en cualquier objetivo cuenta como aprobado.
- Todas las comprobaciones de red se omiten automáticamente en modo offgrid; todas pueden desactivarse en runtime.
- Las imágenes derivadas añaden comprobaciones específicas del servicio (endpoints HTTP, conexiones a base de datos, vida del proceso) dejando caer scripts en un directorio.

### Salida de shell multilingüe (b19-i18n)

- Todos los mensajes de log y la salida de scripts orientados al usuario son traducibles vía GNU gettext.
- Trae de fábrica inglés, español (`es_CL`) y ucraniano (`uk_UA`).
- Las imágenes derivadas heredan automáticamente todas las traducciones del padre; solo las cadenas nuevas o sobrescritas necesitan traducción.
- Las traducciones se compilan en tiempo de compilación sin coste en runtime.

### Seguimiento del linaje de la imagen

- Cada imagen registra sus metadatos de compilación (namespace, proyecto, versión, imagen base) en un archivo de linaje durante la compilación.
- Las imágenes derivadas encadenan el linaje de su padre, produciendo una cadena de procedencia completa desde la base hasta la actual.
- Toda la cadena de linaje se registra al arrancar (verbosidad debug) y puede leerse del archivo en cualquier momento, lo que facilita rastrear a partir de qué se construyó un contenedor en ejecución.

### Logging estructurado con filtro por nivel (b19-log)

- Toda la salida del contenedor pasa por un logger con niveles y cuatro umbrales: error, warn, info, debug.
- Los mensajes por debajo de la verbosidad configurada se descartan silenciosamente, manteniendo limpios los logs de producción.
- Los colores autodetectan el soporte del terminal y respetan `NO_COLOR=1`.
- Encauzable: la salida de comandos puede enrutarse a través del logger para aplicar filtrado por nivel y tags.

### Contenedor sin privilegios de root por defecto

- El contenedor se ejecuta como usuario sin privilegios de root (`ubuntu`, UID/GID 1000) con todos los archivos de runtime en propiedad de ese usuario.
- Una compilación en dos etapas separa la instalación del sistema a nivel root de la configuración del runtime a nivel de usuario.
- La identidad del usuario es configurable en tiempo de compilación.

### Soporte de compilación y runtime aislados de internet (air-gapped/offline)

- Una única variable de entorno (`B19_OFFGRID_MODE=Y`) corta todo acceso a internet en tiempo de compilación y en runtime.
- En compilación: se bloquean las descargas, se saltan las actualizaciones de APT y se saltan los keyscans de SSH. Todos los artefactos deben provenir de los niveles de caché.
- En runtime: las comprobaciones de estado de red se saltan automáticamente con resultado saludable, así los contenedores permanecen en verde en redes aisladas.
- Las listas de paquetes APT pueden capturarse como snapshot e inyectarse para compilaciones de imagen totalmente offline.
- Los servicios de LAN (proxies de caché, registros) siguen siendo accesibles: offgrid bloquea internet, no toda la red.

### Inyección de overlays en runtime

- Se pueden inyectar archivos de configuración o datos al arrancar el contenedor estableciendo en `B19_OVERLAY` el nombre de un directorio.
- El contenido del overlay se copia recursivamente a la raíz del contenedor, sobrescribiendo los archivos existentes; no hace falta reconstruir la imagen.
- Se omite en modo inmutable, impidiendo la modificación en runtime de imágenes bloqueadas para producción.

### Imagen base reproducible (fijada por digest)

- La imagen base de Ubuntu está fijada por digest SHA-256, no por tag, lo que garantiza compilaciones deterministas.
- Admite varias series de Ubuntu (resolute, noble, jammy) seleccionables en tiempo de compilación.
- Los mirrors de APT son configurables por arquitectura para mirrors de LAN o entornos aislados.

### Validación de puertos

- Todas las variables de entorno `*PORT*` se validan al arrancar contra la lista de puertos prohibidos de WHATWG y contra los puertos privilegiados (\<1024).
- Detecta temprano configuraciones erróneas como `HTTP_PORT=22`, antes de que el servicio falle en silencio.
- Puede desactivarse en runtime sin reconstruir la imagen.

### Familia unificada de runners del ciclo de vida

- Ocho runners de hooks numerados cubren el ciclo de vida completo del contenedor: arranque, healthchecks, tests, bootstrap, hooks de compilación, benchmarks, reports y sesiones de shell.
- Todos los runners comparten el mismo patrón: deja caer un script numerado en un directorio y se autodescubre y ejecuta.
- Los scripts de distintas capas de imagen se mezclan: los hooks upstream y los derivados coexisten sin conflicto.
- Cada runner tiene semántica de fallo a medida: abortar ante error (entrypoint, bootstrap), continuar y contar fallos (healthchecks, tests), tener siempre éxito (reports).

### Autocarga de secretos de Docker (secrets)

- Los archivos de secretos de Docker se autodescubren y convierten en variables de entorno al arrancar.
- Los nombres de archivo en notación de puntos se mapean a variables de entorno en mayúsculas (`b19.npm.registry_host` se convierte en `B19_NPM_REGISTRY_HOST`).
- Los secretos requeridos pueden declararse por nombre; el contenedor se niega a arrancar si falta alguno.
- Las variables de entorno existentes tienen precedencia sobre los valores derivados de secretos.
- Los secretos también están disponibles en sesiones de shell interactivas y en healthchecks.
- Los secretos no UTF-8/binarios (claves, blobs DER, tarballs comprimidos con gzip) **no** se exportan como variables de entorno: Bash los trunca en el primer NUL y los bytes sueltos hacen fallar a cualquier herramienta que lea el entorno como UTF-8 (p. ej., `minijinja --env`, usado para plantillar configuraciones). Permanecen en disco en `/run/secrets/<name>` para lecturas basadas en archivo — que, de todos modos, es la única forma correcta de consumir un secreto binario.

### Hooks de shell interactivo (shell.d)

- Las sesiones `docker exec bash` cargan automáticamente los secretos de Docker y cualquier hook personalizado añadido por las imágenes derivadas.
- Los hooks se mezclan vía superposición de capas de Docker, así que la configuración de shell heredada y la específica del proyecto coexisten.

### Gestión elegante de señales

- El PID 1 es `tini -g`, que recoge los procesos zombi y reenvía señales a todo el grupo de procesos.
- Un conjunto configurable de señales Unix (TERM, INT, HUP, USR1, USR2, etc.) se captura y reenvía al proceso principal del servicio.
- `docker stop` termina limpiamente el servicio sin procesos huérfanos ni pérdida de señales.

### Plantillas de configuración Jinja2 (minijinja-cli)

- Renderizado de plantillas compatible con Jinja2 tanto en tiempo de compilación como al arrancar el contenedor.
- Deja caer un archivo `.j2` en cualquier parte del directorio de la aplicación; se descubre en tiempo de compilación y se renderiza en cada arranque con todas las variables de entorno disponibles.
- El renderizado en runtime es paralelo y automático: las imágenes derivadas lo obtienen sin configuración alguna.
- El modo inmutable (`B19_IMMUTABLE=Y`) congela el sistema de archivos en el estado de compilación, saltándose todo renderizado en runtime.

### Framework de tests integrado (test.d)

- Los tests se ejecutan dentro del contenedor en marcha vía `make test` o `docker exec`.
- Espera automáticamente a que pasen los healthchecks antes de ejecutar.
- Sin dependencia de ningún framework de tests: los tests son scripts de shell simples con códigos de salida.
- Admite plantillas Jinja2 en los tests, útil para afirmar en runtime valores fijados en compilación.
- Continúa ante fallos e informa del recuento total; nunca oculta resultados parciales.

### Herramientas de utilidad preinstaladas

- `mold` como enlazador por defecto (con opción de desactivarlo).
- `fd` para búsqueda de archivos, `minijinja-cli` para renderizado de plantillas.
- `aria2c` para descargas multiconexión, `tini` como PID 1 para recoger zombis.
- Herramientas de compresión paralela: `pbzip2`, `pigz`, `pixz`.
- Herramientas gettext para la compilación de i18n, `cURL` para operaciones de red.

### Rutas XDG Base Directory

- Las rutas XDG estándar (`XDG_CACHE_HOME`, `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, `XDG_STATE_HOME`) se establecen bajo el directorio home de la aplicación.
- Todas las rutas son escribibles por el usuario sin privilegios de root, sin escalada de privilegios.
<!-- textlint-enable -->
