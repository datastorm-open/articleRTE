Publication Scientifique 


* Intro : Contexte du problème 

  * Le flow-based
Le flow-based est une méthode développée par RTE pour maximiser les échanges d'énergie éléctrique entre pays européens. Il permet d'utiliser les réseaux éléctriques des différants pays de façon conjointe et d'ainsi de maximiser les échanges entre ces pays. Prenons un exemple concret. L'allemagne à un besoin d'énergie important et la france en a beaucoup trop. L'ancienne méthode permettait uniquement d'envoyer de l'énergie de la france vers l'allemagne. Avec le flow-based, en plus d'utiliser les lignes franco allemande, il est posssible d'envoyer de l'énergie à la belgique qui la renvérra à l'Allemagne par la suite.

  * La modélisation
La modélisation de modèle flow-based est un polyhèdre convexe. Nous observons une dimension par pays, par exemple dans le cas France, Belgique, Pays-Bas, Allemagne le modèle aura quatre dimensions. Les faces de polyhèdre représente les contraintes sur le réseau éléctrique (souvent caractérisées) par des lignes et/ou des contraintes régaliennes imposées par les états.

  * Partie de l'algorithme concerné
Pour gérer de façon efficace le flow-based dans le logiciel antares, il est nécéssaire de réduire le nombre de face de notre polyhèdre. Nous devons donc approximer au mieux l'ancien polyhèdre par un nouveau avec un nombre de façes reduit. Cette approxiation ce fait en volume. L'algorythme que nous étudions ici consiste à approcher un premier polyhèdre par un second. Les inclinaisons des faces de ce second polyhèdre sont définit mais les hauteurs sont à définir. C'est donc une optimisation conjointe des hauterus de ce second polyhèdre que nous réalisons.


* Partie 1 : Présentation de l’ancienne méthode

L'ancienne méthode utilise un calcul d'enveloppe convexe et une descente de gradient. Le calcul de distances entre les deux polyhèdres ce fait par projection des points. Du premier sur le second et vice versa. La distance total est la somme des distances au carré. Nous minimisons cette distance par descente de gradient.
  
  * Explication rapide de l’algorithme d’optimisation 

  * Pourquoi ça ne peut pas fonctionner en dimension plus élevée 

Le problème rencontré en dimention élevé la compléxité de calcul de l'enveloppe convexe. En effet le calcul des sommets de cette enveloppe ce fait à chaque itération de la descente de gradient. Le nombre de contraintes et de sommets augmentant considérablement avec la dimention, le temps de calcul en est considérablement allongé. 

* Partie 2 : Présentation du problème et choix de la méthode 

  * Objets à disposition : Un polyèdre de référence et un ensemble d’inclinaisons de faces orientées pour générer un polyèdre 2 (en faisant bouger les hauteurs) 

  * Détermination d’une distance entre polyèdres.

  * Nécessité d’une distance sans utilisation des sommets 

  * Construction de la méthode des droites  

  * Démonstration de l’arrivée à une distance entre polyèdre 

  * Explication sur la minimisation selon les hauteurs du  

  * Graphiques en 2D 

* Partie 3 : Présentation de l’algorithme R 

  * Récupération des objets nécessaires au calcul de la distance 

  * Droites, points d’intersections, hauteurs, normales aux hyperplans 

  * Faces fixe, explications 

  * Ajout de droites supplémentaires qui passent à proximité des points extrêmes dans chaque direction (pour réduire le problème des pointes) 

  * Optimisation linéaire pour minimiser la distance et déterminer les nouvelles valeurs de hauteur 

  * Affectation des nouvelles valeurs de hauteur 

  * Présentation et calcul de la métrique de validation (intersection / union des volumes) 

  * Itération 

* Partie 4 : Test des différents paramètres et présentation des résultats 

  * Test des valeurs des différents paramètres 

  * Choix du nombre de droites et du nombre de face 

  * Ajout de droites passant par ou à proximité des sommets extrêmes 

  * Les faces fixes ou non 

  * Critère d’arrêt de l’algorithme 

  * Influence sur la valeur de la métrique et sur le temps d’exécution 

  * Temps d’exécution (pour un domaine ou pour l’ensemble des domaines), comparaison avec la méthode précédente 

  * Valeur de la métrique de validation  

  * Visualisation des résultats avec projections sur différentes combinaisons d’axes 

  * Limites de l’algo? Le fait qu’on ne capte pas toujours les pointes. Illustration où ça marche moins bien sans que ça marche mal?  Explications possibles de ces limites 

* Partie 5: Conclusion 

  * Satisfaction du client 

  * Livraison du package, son nom et le lien de téléchargement? 

 