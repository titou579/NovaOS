# État de la construction NovaOS 0.2

- Source de départ : archive NovaOS 0.2.
- Paramètres corrigés : options live-build au singulier (`--architecture`, `--binary-image`).
- Cibles de démarrage prévues : BIOS (Syslinux) et UEFI (GRUB).
- Paquet système remplacé : `neofetch` par `fastfetch` pour Debian 13.
- Construction automatique ajoutée : GitHub Actions, exécution manuelle.
- Contrôles locaux : syntaxe shell et contrôles statiques des sources.
- ISO : non générée dans cette session, car le conteneur ne peut pas résoudre `deb.debian.org` et ne peut donc pas télécharger les outils/paquets nécessaires.
- Test VirtualBox : non effectué.

Ne pas présenter cette version comme démarrable tant que l'artefact ISO n'a pas été produit et testé.
