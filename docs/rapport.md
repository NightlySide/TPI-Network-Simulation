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

```
TODO: remplir en fonction du sujet
```

## Technologie de virtualisation

La toute première réflexion que nous avons était le choix de la technologie permettant de faire tourner nos multiples machines virtuelles. Le sujet nous proposant un minimum de 4 machines, il nous paraissait difficile de toutes les faire tourner sous **VirtualBox** ou **VMware** en raison des limites de matériel à notre disposition, en effet nous travaillons majoritairement sur PC portable et nous sommes limités par la quantité de RAM et de puissance de calcul.

Un autre type de virtualisation existe cependant : la "**containérisation**". Le principe ? Au lieu d'émuler une machine complète, on n'**émule que la partie applicative**, ainsi le noyau de la machine est utilisé pour les appels courants cependant les machines sont isolées du système et les unes des autres dans des conteneurs. Ainsi nous pouvons faire tourner un plus grand nombre de ces machines virtuelles avec le même matériel.

La technologie que nous avons décidé d'utiliser est [Docker](https://www.docker.com/).

![Logo docker](https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Docker_%28container_engine%29_logo.svg/1280px-Docker_%28container_engine%29_logo.svg.png)

L'outil [docker-compose](https://docs.docker.com/compose/) va nous permettre de **décrire les réseaux** ainsi que les interactions entre chaque image composant ce projet.

Ainsi nous allons **décrire chaque machine**, les configurer, créer des réseaux virtuels et attribuer chaque machine à ces réseaux, mettre en place un pare-feu et ainsi de suite.

Nous avons donc la structure de fichier suivante : 

![Structure de fichiers du projet](./imgs/struct_files.png)

Chaque dossier dans le dossier `docker` représente une machine sur le réseau. Dans chacun de ces dossier on va retrouver un fichier `Dockerfile` contenant la configuration de base de la machine avec par exemple les fichiers a copier dans le conteneur. Une telle configuration ressemble au fichier suivant : 

```dockerfile
FROM atomicorp/ossec-docker

# copy config
COPY ossec.conf /var/ossec/etc/ossec.conf

# restart ossec
RUN ["/var/ossec/bin/syscheck_update", "-a"]
RUN ["/var/ossec/bin/syscheck_update", "-l"]
RUN ["/var/ossec/bin/ossec-control", "restart"]
```

On se base sur une image préexistante sur [Docker Hub](https://hub.docker.com/), puis on peut y copier des fichiers, exécuter des commandes et ainsi de suite. Ces commandes seront exécutées lors du build de l’image du conteneur. Nous travaillerons alors avec cette image fraîche pour le reste du projet.



## Création des sous-réseaux

Nous venons de voir comment nous allions créer chaque machine. Maintenant nous devons nous poser la question de **comment organiser** ces machines en réseau afin de pouvoir commencer à configurer ces dernières et à simuler les intrusions.

Pour commencer avec la configuration de docker-compose, nous avions mis **toutes les machines sur le même réseau**, en exposant les ports nécessaires. Cela fonctionnait mais était bien loin de ce que l’on peut retrouver en entreprise ou simplement dans un réseau réel.

Nous avons découvert que docker-compose permet de créer **un lien DNS** direct vers chaque machine du réseau afin de pouvoir y accéder simplement par son nom. Imaginons maintenant que l’image docker de mon pare-feu s’appelle `firewall`, pour y accéder depuis n’importe quelle machine présente sur le réseau, nous n’avons pas besoin de connaître son identité, il suffira d’y accéder par : `http://firewall/` ce qui est pratique.

Nous avons donc réfléchis à la manière d’organiser ce réseau de machines. Le plus simple était de commencer par la machine externe au système. On suppose quelle se trouve sur internet donc elle est mise dans son propre sous-réseau que l’on va appeler `Internet`.

Ensuite avant d’accéder à l’ensemble des machines sur le réseau, les requêtes devront passer par un router, c’est donc le nœud suivant. Ensuite nous avons un sous-réseau pour le pare-feu comprenant différents services tels que Logstash, Suricata, Kibana ou encore Elasticsearch. Dans notre simulation, chacun de ces services tournera sur sa propre machine. Il s’agira du sous-réseau `vlan-FW`. 

On continue avec l’espace DMZ contenant le site web, le serveur DNS et syslog pour remonter les logs par Logstash. Ce sous-réseau sera nommé `vlan-DMZ`. 

Enfin nous avons l’espace utilisateur avec les postes utilisateur des employés de l’entreprise: Alice, Bob et le CEO. Ce sous-réseau portera le nom de `vlan-ZUI`. 

![Nouveau réseau obtenu](imgs/network.drawio.png)

## Création du firewall

-> expliquer pourquoi pas pfsense et comment on a trouvé l'autre

### Définition des règles de filtrage

### Durcissement configuration

## Utilisation de Syslog-ng pour les logs FW et Serveur

-> logs centralisés via le protocole syslog, serveur de collecte sous syslog-ng

## Mise en place de la défense réseau avec Suricata

-> Activer la fonction IDS, préciser les interfaces surveillées, quels sont les avantages inconvénients, utilisation jeu de règle standard, envoie des alertes sur serveur de collecte, tester depuis zone internet avec scan nmap

## Mécanisme de défense hôte avec OSSEC

-> configuration des fonctions principales: vérification d'intégrité, détection de rootkit, collecte de logs...

## Attaque avec metasploit

-> attaquer de l'extérieur et de l'intérieur, voir comment le système réagit, quels sont les alertes remontées