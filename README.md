# Travaux pratiques : Reverse Engineering

## Présentation

Les 6 premiers TP sont présentés sous forme de CTF (*Capture The Flag*). L'objectif est de trouver un mot de passe dissimulé dans le code du programme.

Attention : certains mots de passe présents dans le code sont volontairement faux afin de vous induire en erreur !

Lorsque vous pensez avoir trouvé le bon mot de passe, exécutez le programme non patché en lui passant celui-ci en argument :

```bash
./tpX mot_de_passe
```

Si le mot de passe est correct, le programme affichera :

```text
Bravo ! Tu as réussi le Xème TP.
```

Dans le cas contraire :

```text
Réessaye.
```

> Les options de compilation utilisées pour les différents TP permettent normalement de conserver les mêmes adresses mémoire lors de l'analyse statique et de l'analyse dynamique. Dans la vraie vie, ce n'est généralement pas le cas !

Si vous découvrez qu'un des exécutables est packé avec UPX, installez UPX puis décompactez le binaire :

```bash
sudo apt install upx-ucl
```

N'oubliez pas les techniques d'obfuscation présentées en cours !

SVP, n'utilisez pas l'IA qui pourrait tout faire à votre place... C'est pas noté et c'est purement à visée éducative donc ça a aucun bénéfice.

## Installation et outils

Un seul désassembleur et un seul débogueur sont nécessaires.

Si vous avez déjà Ghidra, il n'est pas nécessaire d'installer IDA (même si les deux peuvent être utilisés).

### Désassembleur : Ghidra

Documentation et téléchargement :  
https://github.com/NationalSecurityAgency/ghidra

### Débogueur : GDB

Installation :

```bash
sudo apt-get install gdb
```

Il existe également des interfaces graphiques permettant de faciliter l'utilisation de GDB.

Aide-mémoire des commandes GDB :  
https://visualgdb.com/gdbreference/commands/

### Alternative : IDA

Documentation et téléchargement :  
https://docs.hex-rays.com/getting-started/install-ida

# Les travaux pratiques

## TP 1

Le binaire n'a pas été strippé : il a gardé les noms des variables et des fonctions.

Ce premier TP devrait être assez facile ! Ouvrez le fichier avec Ghidra ou IDA afin de prendre en main l'outil et de comprendre les informations affichées.

Le mot de passe peut être trouvé en une commande en statique et en dynamique. Quels sont ces deux commandes ?

### Analyse dynamique avec GDB

Une fois le mot de passe trouvé en analyse statique, prenons en main GDB.

Lancez le débogueur :

```bash
gdb ./tp1
```

**1. Rechercher la variable contenant le flag**

```gdb
info variables flag
```

Observez l'adresse de la variable. Normalement, elle devrait être située à l'adresse `0x404040`.

Affichez ensuite son contenu :

```gdb
x/s 0x404040
```

Que voyez-vous ?

**2. Démarrer l'exécution du programme**

```gdb
start
```

Cette commande lance le programme et s'arrête au début de la fonction `main`.

Observez le code de cette fonction :

```gdb
disassemble main
```

Repérez l'instruction `strcmp`, puis placez un breakpoint à son adresse.

L'adresse devrait normalement être `0x4011aa` mais vérifiez !

```gdb
break *0x4011aa
```

Vous auriez également pu retrouver cette adresse directement dans Ghidra.

**3. Atteindre le breakpoint**

```gdb
continue
```

Le programme reprend son exécution jusqu'au breakpoint.

Lorsque le programme vous demande une entrée, saisissez une valeur quelconque.

**4. Observer les arguments de strcmp**

Lorsque le breakpoint est atteint, observez les arguments de `strcmp`.

Sur Linux x86-64, les deux premiers arguments d'une fonction sont respectivement passés dans les registres `RDI` et `RSI`.

```gdb
x/s $rdi
x/s $rsi
```

Que remarquez-vous ?

**5. Exécuter l'appel et observer son résultat**

```gdb
ni
print $eax
```

La commande `ni` (*next instruction*) exécute l'appel à `strcmp` sans entrer dans la fonction.

La valeur de retour est stockée dans `EAX` :
- 0 : les deux chaînes sont identiques
- sinon elles sont différentes

**6. Terminer l'exécution**

```gdb
continue
```

Le programme poursuit son exécution et affiche le résultat.

## TP 2

Le binaire a été strippé : les noms des fonctions et des variables ne sont plus disponibles. Dans les ELF compilés avec gcc, le premier argument passé à __libc_start_main est l’adresse du main.

Le mot de passe est plus difficile à trouver cette fois !

Conseil : N'hésitez pas à programmer un petit script pour décoder le flag si nécessaire.

## TP 3

L'objectif de ce TP est de trouver le mot de passe en utilisant l'analyse dynamique, après avoir effectué une première analyse statique rapide.

Pour afficher un caractère contenu dans un registre, utilisez :

```gdb
p/c $registre
```

## TP 4

Appliquez ce que vous avez appris jusqu'à présent !

Si le mot de passe que vous obtenez est illisible, c'est qu'il y a probablement un problème quelque part dans votre analyse...

## TP 5

Attention à ne pas tomber dans un piège facile !

Analysez bien l'ensemble du contenu du fichier.

## TP 6

Ne vous inquiétez pas si vous ne comprenez pas immédiatement ce que vous observez. Suivez bien l'ordre recommandé des instructions.

Une fois que vous avez compris le fonctionnement du programme, essayez de trouver le mot de passe uniquement en patchant le binaire. Sans écrire de programme supplémentaire, sans utiliser l'analyse dynamique.

## TP bonus : Analyse d'un exécutable Windows

Ce TP est différent des précédents : il n'est pas sous forme de CTFs et l'exécutable est un exécutable Windows.

Il s'agit d'un binaire au format PE, contrairement aux précédents qui étaient au format ELF.

Le binaire a été strippé.

### Présentation

Ce programme n'est pas un vrai malware (l'INSA ne nous laisserait sans doute pas vous en télécharger un) et son exécution ne présente pas de comportement nocif pour la machine.

Il utilise certaines techniques que l'on peut retrouver dans des malwares mais de manière totalement inoffensive. C'est ce qui rend son analyse intéressante.

### Objectif

L'exécutable comporte 4 salles, chacune contenant un défi à surmonter.

Le TP est terminé lorsque vous avez compris comment valider chacune des quatre salles.

N'hésitez pas à consulter la documentation Microsoft pour approfondir vos recherches :

https://learn.microsoft.com/fr-fr/

## Pour aller plus loin

Si vous avez terminé tous les TP et souhaitez continuer la rétro-ingénierie :

- [Challenges.re](https://challenges.re/)
- [Root-Me](https://www.root-me.org/fr/Challenges/Cracking/)