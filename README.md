
[![Build Status](https://travis-ci.org/Inist-CNRS/ezmaster-gitbook.png?branch=master)](https://travis-ci.org/Inist-CNRS/ezmaster-gitbook)

# ezmaster-gitbook

Générateur de documentation GitBook à partir d'un dépôt distant.

## Installation

Télécharger ou cloner le repository sur votre ordinateur :

``` 
git clone https://github.com/Inist-CNRS/ezmaster-gitbook.git
```
Vous devrez ensuite définir des variables d'environnement afin que ça fonctionne :

* GITHUB_URL : définit l'URL du repository où se trouve vore documentation
* BUILD_EACH_NBMINUTES : définit le nombre de minutes entre chaque vérification de mise à jour de votre documentation

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


### Mode production
Pour installer et lancer en mode production :
```
make build
make run-prod
```

### Mode production avec ezmaster

Vous devrez créer un compte DockerHub avec lequel vous allez lier votre repository github. <br>
Une fois ceci fait, rendez-vous sur ezmaster. <br>
Vous devrez alors créer une application en précisant le nom puis le numéro de version. <br>
Ensuite, il faut créer une instance de cette application. <br>
Pour plus de détails et un tutoriel vidéo sur ezmaster, rendez vous sur : <br>
https://github.com/Inist-CNRS/ezmaster/blob/master/README.md

Vous pouvez également automatiser la création application/instance en utilisant ezmaster-automaton : <br>
https://github.com/Inist-CNRS/ezmaster-automaton/blob/master/README.md


