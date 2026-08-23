<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Reseed, що працює за фаєрволом

- **Проблема.** Конфігурація роутера не має ключів reseed, тож вона відкочується до clearnet-HTTPS-хостів reseed — саме те, що першим падає за національним фаєрволом, лишаючи оператора в цензурованій мережі з роутером, що ніколи не побудує мережеву базу даних.
- **Розглядається.** URL reseed, налаштовувані середовищем; опція reseed через Tor або комплектний офлайн-пакет reseed, щоб перший запуск досяг робочого netDb у цензурованому середовищі.
- **Спирається на.** Ключі конфігурації `i2p.reseed.*` I2P; сестринський образ `f5m/tor`, крізь який виходила б траса reseed-через-Tor.

<!-- textlint-enable -->
