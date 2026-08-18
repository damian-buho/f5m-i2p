<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

<!-- textlint-disable terminology,common-misspellings -->
[English](../../CONTRIBUTING.md) · [Українська](../uk/CONTRIBUTING.md)

# Cómo contribuir a F5M/I2P

Ante todo, ¡gracias por dedicar tu tiempo a contribuir! ❤️

Toda forma de contribución se agradece y se valora. Consulta la Tabla de contenidos para conocer las distintas maneras de ayudar y cómo las gestiona este proyecto. Lee la sección correspondiente antes de hacer tu aportación: nos facilitará mucho el trabajo a quienes mantenemos el proyecto y hará la experiencia más agradable para todo el mundo.

> Y si el proyecto te gusta pero no tienes tiempo para contribuir, no pasa nada. Hay otras formas sencillas de apoyarlo y mostrar tu agradecimiento, que también nos harían mucha ilusión:
>
> - Dale una estrella al proyecto en [codeberg.org](https://codeberg.org/f5m/i2p)
> - Dale una estrella al proyecto en [github.com](https://github.com/damian-buho/f5m-i2p)
> - Menciona este proyecto en el readme del tuyo
> - Habla del proyecto en encuentros locales y cuéntaselo a tus amistades y colegas
> - Sigue al [autor (mastodon.social/@damianbuho) en Mastodon](https://mastodon.social/@damianbuho)
> - Sigue al [autor (damian-buho) en GitHub](https://github.com/damian-buho)
> - Sigue al [autor (damian-buho) en Codeberg](https://codeberg.org/damian-buho)
> - Sigue al [autor (damian-buho) en LinkedIn](https://www.linkedin.com/in/damian-buho)
> - Visita el [sitio del autor (dbuho.me)](https://dbuho.me)

<!-- omit in toc -->
## Tabla de contenidos

- [Tengo una pregunta](#tengo-una-pregunta)
- [Cómo informar de fallos](#cómo-informar-de-fallos)
- [Cómo sugerir mejoras](#cómo-sugerir-mejoras)
- [Convenciones](#convenciones)
- [Mejorar la documentación](#mejorar-la-documentación)

## Tengo una pregunta

Antes de preguntar, revisa [SUPPORT.md](SUPPORT.md): explica dónde conseguir ayuda y cómo formular preguntas eficaces.

> ### Aviso legal
>
> Al contribuir a este proyecto, debes aceptar que eres la autoría del 100 % del contenido, que dispones de los derechos necesarios sobre él y que el contenido que aportas puede publicarse bajo la licencia del proyecto.

## Cómo informar de fallos

<!-- omit in toc -->
### Antes de enviar un informe de fallo

Un buen informe de fallo evita que otras personas tengan que perseguirte para obtener más información. Por eso te pedimos que investigues con cuidado, reúnas información y describas el problema con detalle. Completa estos pasos por adelantado para ayudarnos a corregir cualquier posible fallo lo antes posible.

- Asegúrate de usar una [versión con soporte](SUPPORT.md).
- Comprueba que se trata realmente de un fallo y no de un error por tu parte, por ejemplo, componentes o versiones incompatibles del entorno (asegúrate de haber leído la [documentación](/docs). Si lo que buscas es ayuda, consulta [SUPPORT.md](SUPPORT.md)).
- Para ver si otras personas han tenido (y quizá ya resuelto) el mismo problema, comprueba que no exista ya un informe de tu fallo o error en el [gestor de incidencias](https://codeberg.org/f5m/i2p/issues?q=label%3Abug).
- Si puedes, los siguientes detalles serían de ayuda:
    - Traza de la pila, si la hay
    - Sistema operativo, plataforma y versión (Windows, Linux, macOS, x86, ARM)
    - Versión del intérprete, compilador, SDK, entorno de ejecución o gestor de paquetes, según lo que resulte relevante.
    - Si es posible, la entrada que usaste y la salida obtenida
    - ¿Puedes reproducir el problema de forma fiable? ¿Y con versiones anteriores?

<!-- omit in toc -->
### ¿Cómo envío un buen informe de fallo?

> Nunca informes de problemas de seguridad, vulnerabilidades o fallos que incluyan información sensible en el gestor de incidencias ni en ningún otro lugar público. Los fallos sensibles deben enviarse por correo a <damian.buho@proton.me>.

Usamos [Issues de Codeberg](https://codeberg.org/f5m/i2p/issues) para seguir fallos y errores. Si te topas con un problema en el proyecto:

- Abre una [incidencia](https://codeberg.org/f5m/i2p/issues/new). (Como todavía no podemos saber si se trata de un fallo, te pedimos que no lo des por hecho ni etiquetes la incidencia.)
- Explica el comportamiento que esperabas y el que se produjo realmente.
- Aporta todo el contexto posible y describe los *pasos de reproducción* que otra persona pueda seguir para recrear el problema. Esto suele incluir tu código. En un buen informe conviene aislar el problema y crear un caso de prueba reducido.
- Incluye la información que reuniste en el apartado anterior.

## Cómo sugerir mejoras

Esta sección te guía para enviar una propuesta de mejora para F5M/I2P, **tanto funcionalidades completamente nuevas como pequeñas mejoras de lo existente**. Seguir estas indicaciones ayudará a quienes mantienen el proyecto y a la comunidad a entender tu propuesta y a encontrar sugerencias relacionadas.

<!-- omit in toc -->
### Antes de enviar una propuesta de mejora

- Asegúrate de usar una [versión con soporte](SUPPORT.md).
- Comprueba si la funcionalidad ya existe, quizá mediante alguna configuración concreta — la [documentación](/docs) es un buen punto de partida.
- Haz una [búsqueda](https://codeberg.org/f5m/i2p/issues) para ver si ya se ha propuesto. Si es así, comenta en la incidencia existente en lugar de abrir una nueva.
- Valora si tu idea encaja con el alcance y los objetivos del proyecto.

<!-- omit in toc -->
### ¿Cómo envío una buena propuesta de mejora?

Las propuestas de mejora se gestionan como Issues de Codeberg.

- Usa un **título claro y descriptivo** que identifique la propuesta.
- Describe la mejora sugerida **paso a paso** y con el mayor detalle posible.
- **Describe el comportamiento actual** y **explica qué comportamiento esperabas** y por qué. Aquí también puedes indicar qué alternativas no te sirven.
- **Explica por qué esta mejora sería útil** para quienes usan F5M/I2P. También puedes señalar otros proyectos que lo hayan resuelto mejor y que sirvan de inspiración.

## Convenciones

- **Workflow:** git-flow
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/)
- **Versioning:** [Semantic Versioning](https://semver.org/)
- **AI Policy:** [Lee nuestra política sobre IA y LLM](AI_POLICY.md)

## Mejorar la documentación

La documentación está en [/docs](/docs). Correcciones, mejoras y secciones nuevas son bienvenidas: abre una solicitud de incorporación contra las fuentes de la documentación.

## See also

- [Especificación de Projectfile](https://projectfile.org)
<!-- textlint-enable -->
