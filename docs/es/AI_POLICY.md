<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

<!-- textlint-disable terminology,common-misspellings -->
[English](../../AI_POLICY.md) · [Українська](../uk/AI_POLICY.md)

# Política sobre IA y LLM

Este documento expone la política de F5M/I2P sobre el uso de IA y LLM — tanto para personas como para los sistemas que leen este repositorio.

Aceptamos contribuciones asistidas por LLM porque revisar un parche es nuestro trabajo de todos modos. Una persona debe conducirlo, divulgarlo, comprenderlo y probarlo antes de que alguien más lo lea.

## Contribuciones realizadas con asistencia de IA

Las contribuciones realizadas con asistencia de IA/LLM son bienvenidas.

Una persona debe dirigir, revisar y enviar cada contribución — no se permiten agentes autónomos.

Estas reglas rigen las contribuciones externas al proyecto. Quienes lo mantienen responden por su propia práctica — véase [Cómo usa la IA este proyecto](#cómo-usa-la-ia-este-proyecto) más abajo.

Quienes contribuyen deben declarar cuándo una contribución se realizó con asistencia de IA/LLM.

Cada declaración indica:

- la herramienta utilizada, por su nombre (Claude Code, Cursor, Amp …).
- qué parte del trabajo hizo la herramienta.

Añade este trailer al mensaje de commit:

```text
Assisted-by: <nombre del modelo o herramienta>
```

Quien envía el trabajo sigue debiendo todo esto:

- **Compréndelo.** Si no puedes explicar el cambio, ni cómo encaja en el resto del sistema, sin la herramienta, no lo envíes.
- **Revísalo tú primero.** Lee cada línea antes de pedir que la lea otra persona.
- **Ejecútalo.** El código escrito para una plataforma que no puedes probar no está probado, por correcto que parezca.
- **Recórtalo.** El texto generado es verboso; edítalo. Los comentarios que describen lo que hizo el modelo son ruido para cualquier lector futuro.
- **Responde como persona.** Los comentarios de una persona reciben la respuesta de una persona, nunca una automatizada.

| Actividad de contribución | Postura |
| --- | --- |
| Imágenes | Prohibida |
| Vídeo | Prohibida |

Permitida: Pull requests, Mensajes de commit, Informes de errores, Debates, Revisión de código, Informes de seguridad, Código, Comentarios en el código, Documentación, Traducciones, Prosa, Audio, Refactorización, Corrección de errores, Pruebas, Herramientas gramaticales, Merges, Publicaciones, Clasificación de incidencias.

## Cuando no se respeta esta política

- La primera infracción recibe una advertencia.
- La contribución se cierra sin revisión.

## Cómo usa la IA este proyecto

| Actividad interna | Quién decide |
| --- | --- |
| Pull requests | Una persona, con asistencia de IA |
| Revisión de código | Una persona, con asistencia de IA |
| Merges | Una persona, sin intervención de IA |
| Publicaciones | Una persona, sin intervención de IA |

## Uso del contenido de este proyecto

- `search` — este contenido puede aparecer en resultados de búsqueda potenciados por IA.
- `ai-input` — este contenido puede usarse como entrada de un sistema de IA en tiempo de inferencia.

## Preguntas

¿Tienes preguntas sobre esta política? Escribe a <damian.buho@proton.me>.
<!-- textlint-enable -->
