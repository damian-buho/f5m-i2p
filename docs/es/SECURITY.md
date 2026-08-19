<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>
SPDX-License-Identifier: MIT
pf-cli-managed: yes
-->

<!-- textlint-disable terminology,common-misspellings -->
[English](../../SECURITY.md) · [Українська](../uk/SECURITY.md)

# Política de seguridad

## Cómo informar de una vulnerabilidad

**No informes de vulnerabilidades de seguridad a través de incidencias, debates o solicitudes de cambio públicos.**

Hazlo escribiendo a **<damian.buho@proton.me>**.

Incluye toda la información que puedas de la siguiente lista; nos ayuda a clasificar y resolver el informe más rápido:

- El tipo de problema (p. ej. desbordamiento de búfer, inyección SQL, cross-site scripting)
- La versión o versiones afectadas
- El impacto del problema, incluido cómo podría explotarlo un atacante
- Instrucciones paso a paso para reproducir el problema
- La ubicación del código fuente afectado (etiqueta, rama, commit o URL directa)
- Las rutas completas de los archivos fuente relacionados con el problema
- Cualquier configuración necesaria para reproducir el problema
- Archivos de registro relevantes, si es posible
- Código de prueba de concepto o de explotación, si es posible

Procuramos acusar recibo de los informes en un plazo de 30 días y coordinar
la divulgación en cuanto exista una corrección.

## Cifrar un informe

Si quieres enviarnos un informe cifrado, sigue estos pasos.

Importa nuestra clave pública:

```sh
gpg --keyserver keys.openpgp.org --recv-keys B64C122EE16C3746
```

Verifica que la huella coincide antes de confiar en ella:

```sh
gpg --fingerprint B64C122EE16C3746
```

La salida debe mostrar:

```text
6F19 7084 3C9E 8406 AD70  0467 B64C 122E E16C 3746
```

Cifra tu mensaje para nosotros:

```sh
gpg --encrypt --armor --recipient B64C122EE16C3746 message.txt
```

## Programa de recompensas

F5M/I2P no ofrece actualmente un programa de recompensas. Aun así
agradecemos los informes divulgados de forma responsable — consulta el canal de
contacto anterior.

## Vulnerabilidades reconocidas

Los siguientes hallazgos fueron revisados y se suprimen de forma intencionada
(la corrección depende de una versión posterior del proyecto base o el aviso no
aplica a este proyecto):

| ID | Motivo |
| --- | --- |
| CVE-2025-47273 | vendored in pip wheel, blocked by upstream |
| GHSA-5rjg-fvgr-3xxf | vendored in pip wheel, blocked by upstream |
| GHSA-6v7p-g79w-8964 | vendored in pip wheel, blocked by upstream |
| CVE-2026-10050 | unfixable upstream dependency; fixable only via upstream release |
| CVE-2026-1605 | unfixable upstream dependency; fixable only via upstream release |
| CVE-2026-2332 | unfixable upstream dependency; fixable only via upstream release |
| GHSA-355h-qmc2-wpwf | unfixable upstream dependency; fixable only via upstream release |
| GHSA-xxh7-fcf3-rj7f | unfixable upstream dependency; fixable only via upstream release |

<!-- textlint-enable -->
