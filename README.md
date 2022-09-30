# Скрипт для VPN с российским IP

- Скрипт из [статьи на VC](https://vc.ru/dev/66942-sozdaem-svoy-vpn-server-poshagovaya-instrukciya).
- Работает только для Mac.

## Как поднять VPN

1. Заводим Debian сервер на [https://my.selectel.ru/vpc/](https://my.selectel.ru/vpc/) (где-то 2-3 руб/час) или ещё на какому-нибудь российском сервере:  главное, чтобы вы могли войти на сервер с логином root и вашим SSH ключом. 
2. `./vpn.zsh <ПУБЛИЧНЫЙ_IP_СЕРВЕРА>`
3. В System Preferences в Profiles появится новая конфигурация VPN.
4. Заходим в Profiles и устанавливаем конфигурацию.
5. Переходим в System Preferences в Network и коннектимся к VPN с названием Emin.

