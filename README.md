# NovaOS 0.2 — kit source

NovaOS est un prototype de distribution Linux francophone basé sur Debian 13 « trixie » et XFCE. Cette archive contient les fichiers de configuration et le script de construction : **elle ne contient pas encore d'ISO compilée**.

## Ce qui change en 0.2

- Bureau XFCE avec thème Arc et icônes Papirus.
- Fond d'écran NovaOS et raccourcis de bureau pour ChatGPT, les paramètres, les applications et le guide.
- Guide de bienvenue local en français.
- Applications : Firefox ESR, LibreOffice, VLC, lecteur PDF, gestionnaire de fichiers et utilitaires.
- Sécurité de base : UFW, AppArmor et mises à jour automatiques de sécurité.
- Script de vérification des fichiers sources avant compilation.

## Construire l'ISO

La construction est prévue sur une installation Debian 13 amd64 avec Internet, droits administrateur et environ 25 Go d'espace libre. Elle installe `live-build`, `debootstrap`, `xorriso` et `squashfs-tools`.

```bash
chmod +x build.sh test-source.sh
./test-source.sh
sudo ./build.sh
```

Si la construction réussit, l'ISO sera dans `build/NovaOS-0.2-amd64.iso`, accompagnée de son empreinte SHA-256. Ne lance pas la construction sur une machine contenant des données importantes sans sauvegarde.

## Essai VirtualBox

- Type : Linux / Debian (64-bit)
- RAM : 4096 Mo recommandés (2048 Mo pour un essai réduit)
- CPU : 2
- Disque virtuel : 30 Go, VDI dynamique
- Mémoire vidéo : 128 Mo
- Réseau : NAT pour les mises à jour ; déconnecté pour les tests qui n'ont pas besoin d'Internet
- Démarrer d'abord sur l'ISO en mode live, vérifier affichage, clavier, réseau, audio et raccourcis, puis tester l'installateur s'il est présent.

Crée un instantané avant les modifications. Ne partage pas de dossiers personnels de l'hôte avec une VM de test.

## Compte et ChatGPT

Aucun compte n'est précréé. Le compte utilisateur doit être créé pendant l'installation. Le raccourci ChatGPT ouvre `https://chatgpt.com/` dans Firefox : il faut se connecter avec son propre compte. Aucun mot de passe ni clé API n'est intégré à l'image.

## Sécurité et limites

Cette version ne doit pas être considérée comme un système audité ou invulnérable. UFW, AppArmor et les mises à jour automatiques sont des protections de base ; leur état devra être contrôlé dans la VM après démarrage. Les tests prévus sont défensifs : vérification du pare-feu, des permissions, des journaux, des mises à jour et détection de fichiers de test inoffensifs. Ne pas utiliser de vrais malwares, ni de code qui se propage, se dissimule ou endommage des données.

## État

Les fichiers sources ont passé les contrôles statiques inclus dans `test-source.sh`. L'ISO n'a pas encore été compilée ni testée au démarrage dans VirtualBox. Le fond d'écran est fourni dans les sources ; son application automatique comme fond XFCE devra être validée pendant le premier test graphique.

## Construction automatique de l'ISO

Un workflow GitHub Actions est fourni dans `.github/workflows/build-iso.yml`. Après avoir placé le contenu du dossier `NovaOS` à la racine d'un dépôt GitHub, ouvrir **Actions** > **Construire NovaOS ISO** > **Run workflow**. À la fin d'une exécution réussie, télécharger l'artefact `NovaOS-0.2-amd64-ISO`.

Voir `BUILD-ISO-FR.md` pour le mode d'emploi. Une compilation réussie ne remplace pas le test de démarrage dans VirtualBox.
