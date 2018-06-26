
[![Build Status](https://travis-ci.org/Inist-CNRS/ezmaster-gitbook.png?branch=master)](https://travis-ci.org/Inist-CNRS/ezmaster-gitbook)

# ezmaster-gitbook

Générateur de documentation GitBook à partir d'un dépôt distant.

## Installation

Télécharger ou cloner le repository sur votre ordinateur :

``` 
git clone https://github.com/Inist-CNRS/ezmaster-gitbook.git
```
Vous devrez ensuite définir des variables d'environnement afin que ça fonctionne :
* SERVER_NAME : définit le nom de domaine (pas de valeur par défaut)
* GITHUB_URL : définit l'URL du repository où se trouve vore documentation (valeur par défaut : https://github.com/istex/istex-doc-gitbook.git)
* BUILD_EACH_NBMINUTES : définit le nombre de minutes entre chaque vérification de mise à jour de votre documentation (valeur par défaut : 1)

## Développeur

### Mode développement

Prérequis :
* Docker
* Docker-compose
* Pour le développement : Git & Make

Placer vous dans le dossier où vous avez cloné le repository, puis exécutez :

```
make run-debug
```
Puis rendez vous dans le dossier src/ pour modifier votre documentation ou pour ajouter plugins, styles, etc..

Ouvrez alors votre navigateur sur http://localhost:8080 pour visualiser votre documentation.

Pour tester avec une autre doc hébergée sur github, tapez ceci (exemple sur la doc de lodex): 

```bash
GITHUB_URL="https://github.com/Inist-CNRS/lodex-doc" make run-prod
```

### Mode production
Pour installer et lancer en mode production :
```
make build
make run-prod
```

### Mode production avec ezmaster

Vous pouvez également mettre en production votre documentation avec ezmaster (cf https://github.com/Inist-CNRS/ezmaster/blob/master/README.md)



