#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"
fail=0
check() { if eval "$2"; then printf 'OK   %s\n' "$1"; else printf 'FAIL %s\n' "$1"; fail=1; fi; }
check 'Script de construction présent et exécutable' 'test -x build.sh'
check 'Liste de paquets présente' 'test -s config/package-lists/novaos.list.chroot'
check 'Hook de configuration exécutable' 'test -x config/hooks/normal/0200-novaos-defaults.hook.chroot'
check 'Fond d’écran SVG présent' 'test -s config/includes.chroot/usr/share/backgrounds/novaos/novaos-wallpaper.svg'
check 'Raccourci ChatGPT présent' 'test -s config/includes.chroot/etc/skel/Desktop/ChatGPT.desktop'
check 'Guide de bienvenue présent' 'test -s config/includes.chroot/usr/share/doc/novaos/README.html'
check 'Pas de compte ou mot de passe codé en dur' '! grep -RniE "password=|passwd=|api[_-]?key[[:space:]]*=" config'
if (( fail )); then exit 1; fi
echo 'Contrôles statiques réussis. Cela ne remplace pas un démarrage réel dans VirtualBox.'
