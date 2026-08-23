<!--
SPDX-FileCopyrightText: 2026 Damián Búho <damian.buho@proton.me>

SPDX-License-Identifier: MIT
-->

<!-- textlint-disable terminology,common-misspellings -->

# Уніфікований вихід через Tor із f5m/tor

- **Проблема.** HTTPS-outproxy вказує на чужий вузол Tor, тож оператор доручає свій clearnet-трафік незнайомцеві, а I2P і Tor працюють як окремі стеки без спільного виходу та спостережуваності.
- **Розглядається.** Один compose-стек, що використовує власний контейнер `f5m/tor` оператора як I2P-outproxy у clearnet і вихід reseed, усуваючи довіру до третіх осіб і об’єднуючи постійну ідентичність та метрики обох.
- **Спирається на.** SOCKS-порт сестринського образу `f5m/tor` і вже шаблонізовані ключі outproxy та reseed I2P; спільна compose-машинерія, якою користуються обидва образи.

<!-- textlint-enable -->
