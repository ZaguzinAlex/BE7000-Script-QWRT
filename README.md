# BE7000-Script-QWRT
Скрипты для быстрой установки бинарников Qbittorrent и Torrserver на QWRT. А также установки локализации luci и удаления китайских пакетов.

1. Скрипт удаления некоторых китайских пакетов и установки русской локализации для админки роутера. С возможностью выбора удалять или оставить.

curl -sSL https://raw.githubusercontent.com/ZaguzinAlex/BE7000-Script-QWRT/main/remove.sh | sh

2. Скрипт установки [Qbittorrent-nox static](https://github.com/userdocs/qbittorrent-nox-static/releases/tag/release-5.1.4_v2.0.12)
Позволяет при установке выбрать веб-порт, порт для торрентов, папку для загрузки. Устаналивается по пути /usr/bin/qbittorrent. Папка профиля будет жить там-же для удобства. Служба qbittorrent также будет установлена и настроена. После установки сервис запуститься автоматически. Там же, в скрипте, Вы можете найти и пароль для доступа в веб-интерфейс. Также через скрипт можно его и удалить. Просто снова запустите скрипт и выберите "D".

curl -sSL https://raw.githubusercontent.com/ZaguzinAlex/BE7000-Script-QWRT/main/qbittorrent.sh | sh

3. Скрипт установки [Torrserver Matrix.141]([(https://github.com/YouROK/TorrServer/releases/tag/MatriX.141))
При установке позволяет выбрать веб-порт, включить авторизацию на сервере, ввести имя пользователя и пароль. Устаналивается по пути /usr/bin/torrserver. Папка профиля будет жить там-же для удобства. Служба torrserver также будет установлена и настроена. После установки сервис запуститься автоматически. Также через скрипт можно его и удалить. Просто снова запустите скрипт и выберите "D".

curl -sSL https://raw.githubusercontent.com/ZaguzinAlex/BE7000-Script-QWRT/main/torrserver.sh | sh

Если вас что-то не устраивает, то возьмите скрипт и переделейте под себя. Создавал скрипт я чисто для собственного удобства.

Запускать можно прямо во встроенном терминале админки роутера или через любой другой.

Скриншоты:

<img width="922" height="773" alt="2" src="https://github.com/user-attachments/assets/b029d545-b08a-43d4-bc1d-25b7c95a73bc" />

<img width="923" height="906" alt="3" src="https://github.com/user-attachments/assets/603fa60c-32e8-47a2-a24a-59c24923540d" />

<img width="923" height="735" alt="1" src="https://github.com/user-attachments/assets/a794c89c-36f4-46dd-a09e-637c40790dc4" />
