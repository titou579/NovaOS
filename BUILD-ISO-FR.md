# Construire l'ISO NovaOS 0.2

## Option 1 — construction automatique avec GitHub Actions

Le fichier `.github/workflows/build-iso.yml` permet de construire l'ISO sur une machine Debian 13 temporaire hébergée par GitHub Actions.

1. Décompresser l'archive source.
2. Envoyer le contenu du dossier `NovaOS` à la racine du dépôt GitHub. Le dépôt doit donc contenir directement `.github/`, `config/`, `build.sh` et `test-source.sh`.
3. Ouvrir le dépôt sur GitHub, puis l'onglet **Actions**.
4. Sélectionner **Construire NovaOS ISO**, puis **Run workflow**.
5. Attendre la fin du travail. Si le résultat est vert, ouvrir le travail terminé et récupérer l'artefact `NovaOS-0.2-amd64-ISO`.
6. Décompresser l'artefact téléchargé : il contient l'ISO et son fichier `SHA256SUMS`.

L'ISO n'est pas compilée lors de l'envoi des sources : il faut déclencher le workflow. Si le travail échoue, ouvrir son journal et lire la première erreur rouge.

## Option 2 — construction locale

Sur une vraie installation Debian 13 amd64 connectée à Internet, avec droits administrateur et au moins 25 Go d'espace libre :

```bash
chmod +x build.sh test-source.sh
./test-source.sh
sudo ./build.sh
```

Le résultat attendu est `build/NovaOS-0.2-amd64.iso`.

## Premier test VirtualBox

- Type : Linux / Debian (64-bit)
- RAM : 4096 Mo recommandés (2048 Mo pour un essai réduit)
- Processeurs : 2
- Disque virtuel : 30 Go, VDI dynamique
- Mémoire vidéo : 128 Mo
- Démarrer sur l'ISO et choisir le mode live avant toute installation.
- Créer un instantané VirtualBox avant les premiers tests.

La réussite du build ne prouve pas à elle seule que chaque périphérique ou fonction graphique fonctionne. Il faut encore démarrer l'ISO dans VirtualBox et vérifier l'affichage, le clavier, le réseau, l'audio, les raccourcis et l'installateur.
