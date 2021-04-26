# Expérimentation d'une architecture SI sécurisée - Syslog-ng, Suricata, Ossec

> Rapport rédigé dans le cadre du cours de Traitement et Protection de l'Information
> U.E. 4.2 dispensé à l'ENSTA Bretagne
>
> Auteurs :
>
> -   Alexandre FROEHLICH
> -   Guillaume LEINEN
> -   Erwan AUBRY

## Introduction

L'objectif de ce project est de concevoir une simulation dans laquelle nous allons tenter de déclencher une intrusion puis de la détecter en remontant l'alerte.

Pour arriver à cet objectif nous allons donc devoir :

-   créer un ensemble de machines virtuelles connectées entre elles
-   créer un firewall permettant de filtrer les requêtes
-   créer un serveur en DMZ qui sera notre "point sensible"
-   créer un attaquant, une machine virtuelle externe, qui tentera de pénétrer le réseau

Ce rapport décrit notre procédure et les évolutions du projet au fur et à mesure de nos avancées ainsi que de nos recherches.

![Schéma initial](imgs/schema_initial.jpg)

## Technologie de virtualisation

La toute première réflexion que nous avons était le choix de la technologie permettant de faire tourner nos multiples machines virtuelles. Le sujet nous proposant un minimum de 4 machines, il nous paraissait difficile de toutes les faire tourner sous VirtualBox ou VMWare en raison des limites de matériel à notre disposition, en effet nous travaillons majoritairement sur PC portable et nous sommes limités par la quantité de RAM et de puissance de calcul.

Un autre type de virtualisation existe cependant : la "containarisation". Le principe ? Au lieu d'émuler une machine complète, on n'émule que la partie applicative, ainsi le noyau de la machine est utilisé pour les appels courants cependant les machines sont isolées du système et les unes des autres dans des conteneurs. Ainsi nous pouvons faire tourner un plus grand nombre de ces machines virtuelles avec le même matériel.

La technologie que nous avons décidé d'utiliser est [Docker](https://www.docker.com/).

![Logo docker](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Docker_%28container_engine%29_logo.svg/1280px-Docker_%28container_engine%29_logo.svg.png)

L'outil [docker-compose](https://docs.docker.com/compose/) va nous permettre de décrire les réseaux ainsi que les intéractions entre chaque image composant ce projet.

Ainsi nous allons décrire chaque machine, les configurer, créer des réseaux virtuels et attribuer chaque machine à ces réseaux, mettre en place un pare-feu et ainsi de suite.
