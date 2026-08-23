<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Налаштовувані outproxy і SOCKS

- **Проблема.** Хости outproxy зашиті, а SOCKS-тунелю немає взагалі, тож оператор, який хоче інший clearnet-вихід — або будь-який клієнт SOCKS5 — має редагувати шаблон; гірше, типовий HTTPS-outproxy безшумно веде clearnet-трафік крізь чужий вузол Tor.
- **Розглядається.** Шаблонізувати HTTP- і HTTPS-outproxy зі середовища та додати перемикальний клієнтський SOCKS-тунель на звичайному порту, щоб оператор обирав вихід, а будь-який SOCKS-застосунок працював.
- **Спирається на.** Тунельні outproxy-ключі I2P і його тип клієнтського SOCKS-тунелю; наявний шаблон Jinja2, що вже визначає тунелі HTTP і CONNECT.

<!-- textlint-enable -->
