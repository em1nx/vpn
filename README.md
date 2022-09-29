# Скрипт для VPN с российским IP

- Скрипт из [статьи на VC](https://vc.ru/dev/66942-sozdaem-svoy-vpn-server-poshagovaya-instrukciya).
- Работает только для Mac.

## Как поднять VPN

1. Заводим Debian сервер на [https://my.selectel.ru/vpc/](https://my.selectel.ru/vpc/) или ещё на какому-нибудь российском сервисе. 
2. `./vpn.zsh <ПУБЛИЧНЫЙ_IP_СЕРВЕРА>` (используется root логин).
3. В System Preferences мака появится новая конфигурация (справа снизу).
4. Устанавливаем конфигурацию.
5. Переходим в System Preferences в подключения и коннектимся к VPN с названием Emin.

