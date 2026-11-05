#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Lance ce script avec sudo : sudo ./build.sh" >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "Impossible d'identifier le système hôte." >&2
  exit 1
fi
# shellcheck disable=SC1091
. /etc/os-release
if [[ "${ID:-}" != "debian" || "${VERSION_CODENAME:-}" != "trixie" ]]; then
  echo "Construction prévue sur Debian 13 (trixie). Hôte détecté : ${PRETTY_NAME:-inconnu}." >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Outils pour produire une image hybride amorçable en BIOS et en UEFI.
apt-get update
apt-get install -y --no-install-recommends \
  live-build debootstrap xorriso squashfs-tools \
  isolinux syslinux-common grub-pc-bin grub-efi-amd64-bin \
  dosfstools mtools ca-certificates

# Contrôles avant la construction.
./test-source.sh
test -s config/package-lists/novaos.list.chroot
test -x config/hooks/normal/0200-novaos-defaults.hook.chroot

# Nettoyer les éléments de construction précédents.
lb clean --purge || true

# Une configuration neuve est générée à chaque construction.
lb config \
  --distribution trixie \
  --architecture amd64 \
  --binary-image iso-hybrid \
  --bootloaders "syslinux grub-efi" \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer live \
  --debian-installer-gui true \
  --checksums sha256 \
  --firmware-chroot true \
  --firmware-binary true \
  --bootappend-live "boot=live components locales=fr_FR.UTF-8 keyboard-layouts=fr username=nova hostname=novaos" \
  --iso-application "NovaOS" \
  --iso-volume "NOVAOS_02" \
  --iso-publisher "NovaOS Community" \
  --iso-preparer "NovaOS build kit"

lb build

mkdir -p build
ISO_PATH="$(find "$ROOT" -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "$ISO_PATH" ]]; then
  echo "Aucune ISO trouvée à la racine après live-build." >&2
  exit 2
fi

mv -f "$ISO_PATH" "$ROOT/build/NovaOS-0.2-amd64.iso"
sha256sum "$ROOT/build/NovaOS-0.2-amd64.iso" | tee "$ROOT/build/SHA256SUMS"
ls -lh "$ROOT/build/NovaOS-0.2-amd64.iso"
echo "ISO créée : $ROOT/build/NovaOS-0.2-amd64.iso"
