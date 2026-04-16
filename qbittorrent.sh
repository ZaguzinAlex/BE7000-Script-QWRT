#!/bin/sh

dirInstall="/usr/bin/qbittorrent"
serviceName="qbittorrent"
scriptname=$(basename "$0")

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' 

colorize() {
    color=$1
    text=$2
    case $color in
        red) echo -e "${RED}${text}${NC}" ;;
        green) echo -e "${GREEN}${text}${NC}" ;;
        yellow) echo -e "${YELLOW}${text}${NC}" ;;
        *) echo -e "${text}" ;;
    esac
}

isRoot() {
    [ $(id -u) -eq 0 ] && return 0 || return 1
}


checkRunning() {
    pidof aarch64-qbittorrent-nox | head -n 1
}

getIP() {
    ip addr show dev $(ip route | grep default | awk '{print $5}') | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | head -n 1
}

uninstall() {
    checkInstalled
    echo ""
    echo " Директория c Qbittorrent - ${dirInstall}"
    echo ""
    echo " Это действие удалит все данные qbittorrent включая базу данных торрентов и настройки!"
    echo ""
    read -p " Вы уверены что хотите удалить программу? ($(colorize red Y)es/$(colorize yellow N)o) " answer_del </dev/tty
    if [ "$answer_del" != "${answer_del#[YyДд]}" ]; then
        cleanup
        echo " - Qbittorrent удален из системы!"
        echo ""
    else
        echo ""
    fi
}

cleanup() {
    /etc/init.d/$serviceName stop 2>/dev/null
    /etc/init.d/$serviceName disable 2>/dev/null
    rm -rf /etc/init.d/$serviceName $dirInstall 2>/dev/null
}


checkInternet() {
    echo " Проверяем соединение с Интернетом..."
    if ! ping -c 2 google.com >/dev/null 2>&1; then
        echo " - Нет Интернета. Проверьте ваше соединение."
        exit 1
    fi
    echo " - соединение с Интернетом успешно"
}

initialCheck() {
    if ! isRoot; then
        echo " Вам нужно запустить скрипт от root. Пример: sh $scriptname"
        exit 1
    fi
    checkInternet
}


installQbittorrent() {
    echo " Устанавливаем и настраиваем Qbittorrent..."
    
    binName="aarch64-qbittorrent-nox"
    [ ! -d "$dirInstall" ] && mkdir -p "$dirInstall"
    
    urlBin="https://github.com/userdocs/qbittorrent-nox-static/releases/download/release-5.1.4_v2.0.12/aarch64-qbittorrent-nox"
    
    echo " Загружаем Qbittorrent..."
    curl -L -o "$dirInstall/$binName" "$urlBin"
    chmod +x "$dirInstall/$binName"
echo ""    
    read -p " Хотите изменить порт для Qbittorrent (по умолчанию 8080)? ($(colorize yellow Y)es/$(colorize green N)o) " answer_cp </dev/tty
    if [ "$answer_cp" != "${answer_cp#[YyДд]}" ]; then
        read -p " Введите номер порта: " answer_port </dev/tty
        webPort=$answer_port
    else
        webPort="8080"
    fi
echo ""	
    read -p " Хотите изменить порт для торрентов Qbittorrent (по умолчанию 26777)? ($(colorize yellow Y)es/$(colorize green N)o) " answer_cp1 </dev/tty
    if [ "$answer_cp1" != "${answer_cp1#[YyДд]}" ]; then
        read -p " Введите номер порта: " answer_port1 </dev/tty
        torrentPort=$answer_port1
    else
        torrentPort="26777"
    fi
echo ""	
	read -p " Хотите изменить папку, куда будут скачиваться ваши торренты (по умолчанию /usr/bin/qbittorrent/Downloads)? ($(colorize yellow Y)es/$(colorize green N)o) " answer_f </dev/tty
    if [ "$answer_f" != "${answer_f#[YyДд]}" ]; then
        read -p " Введите путь к папке: " answer_fold </dev/tty
        torrentFold=$answer_fold
    else
        torrentFold="/usr/bin/qbittorrent/Downloads"
    fi
echo ""

    mkdir -p $dirInstall/qBittorrent/config
	chmod -R 755 $dirInstall/qBittorrent/config
	
	cat << EOF > $dirInstall/qBittorrent/config/qBittorrent.conf
	
[BitTorrent]
Session\DefaultSavePath=$torrentFold
Session\Port=$torrentPort

[LegalNotice]
Accepted=true

[Preferences]
General\Locale=ru
WebUI\Port=$webPort

EOF
    chmod 644 $dirInstall/qBittorrent/config/qBittorrent.conf
    
    cat << EOF > /etc/init.d/$serviceName
#!/bin/sh /etc/rc.common
START=98
STOP=10

USE_PROCD=1
PROG="$dirInstall/aarch64-qbittorrent-nox"

start_service() {
    [ -x "\$PROG" ] || return 1
    procd_open_instance
    procd_set_param command "\$PROG" --profile=$dirInstall
    procd_set_param respawn
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_set_param limits core="0" 
    procd_close_instance
}
EOF

    chmod +x /etc/init.d/$serviceName
    /etc/init.d/$serviceName enable
    /etc/init.d/$serviceName start
    serverIP=$(getIP)
    
    echo ""
    echo " Qbittorrent установлен в папку ${dirInstall}"
	echo " Немного подождите для получения логина и временного пароля..."
	echo " Зайдите в веб-интерфейс Qbittorrent и смените пароль на постоянный!"
    echo ""

    sleep 3; logread -e qbittorrent | grep -iC 2 "пароль" | tail -n 5

}

checkInstalled() {
    if [ -f "$dirInstall/aarch64-qbittorrent-nox" ]; then
        echo " - Qbittorrent найден в директории $dirInstall"
        return 0
    else
        echo " - Qbittorrent не найден"
        return 1
    fi
}

case $1 in
    -i|--install|install)
        initialCheck
        installQbittorrent
        exit
        ;;
    -r|--remove|remove)
        uninstall
        exit
        ;;
    *)
        echo ""
        echo "========================================================"
        echo " Скрипт установки Qbittorrent 5.1.4 (LT 2.0.12) для QWrt"
        echo "========================================================"
        echo ""
        ;;
esac

while true; do
    echo ""
    read -p " Хотите установить или настроить Qbittorrent? ($(colorize green Y)es|$(colorize yellow N)o) Для удаления введите «$(colorize red D)elete» " ydn </dev/tty
    case $ydn in
        [YyДд]*)
            initialCheck
            installQbittorrent
            break
            ;;
        [DdУу]*)
            uninstall
            break
            ;;
        [NnНн]*)
            break
            ;;
        *) echo " Введите $(colorize green Y)es, $(colorize yellow N)o или $(colorize red D)elete"
            ;;
    esac
done

echo " Готово!"
echo ""
