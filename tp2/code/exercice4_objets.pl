ask(comprend, X, Y) :-
    format('~w comprend-il un(e) ~w ? ', [Y, X]),
    read(Reponse),
    Reponse = 'oui'.
ask(est, X, Y) :-
    format('~w est-il ~w ? ', [Y, X]),
    read(Reponse),
    Reponse = 'oui'.
ask(sert_a, X, Y) :-
    format('~w sert-il a ~w ? ', [Y, X]),
    read(Reponse),
    Reponse = 'oui'.
ask(se_trouve, X, Y) :-
    format('~w se trouve-t-il dans ~w ? ', [Y, X]),
    read(Reponse),
    Reponse = 'oui'.

objet(X) :- ask(est, electrique, X), electrique(X).
objet(X) :- non_electrique(X).

electrique(X) :- ask(est, un_appareil_electromenager, X), appareil_electromenager(X).
electrique(X) :- ask(est, un_appareil_electronique, X), appareil_electronique(X).
electrique(X) :- lam(X). % Lampe.

appareil_electromenager(X) :- ask(se_trouve, la_cuisine, X), electromenager_de_cuisine(X).
appareil_electromenager(X) :- asp(X). % Aspirateur.

electromenager_de_cuisine(X) :- ask(est, gros, X), gros_electromenager_de_cuisine(X).
electromenager_de_cuisine(X) :- ask(sert_a, faire_du_cafe, X), caf(X). % Cafetière.
electromenager_de_cuisine(X) :- gri(X). % Grille-pain.

gros_electromenager_de_cuisine(X) :- ask(comprend, plaque_de_cuisson, X), cui(X). % Cuisinière.
gros_electromenager_de_cuisine(X) :- fou(X). % Four.

appareil_electronique(X) :- ask(sert_a, appeler, X), tel(X). % Téléphone.
appareil_electronique(X) :- ord(X). % Ordinateur.

non_electrique(X) :- ask(est, un_meuble, X), meuble(X).
non_electrique(X) :- ask(sert_a, nettoyer_ou_laver, X), nettoyant(X).
non_electrique(X) :- ask(est, un_ustensile_ou_de_la_vaisselle, X), ustensile_ou_vaisselle(X).
non_electrique(X) :- objet_divers(X).

meuble(X) :- ask(sert_a, dormir, X), bed(X). % Lit.
meuble(X) :- ask(sert_a, manger, X), tbl(X). % Table.
meuble(X) :- pia(X). % Piano.

nettoyant(X) :- ask(est, liquide, X), liquide(X).
nettoyant(X) :- bal(X). % Balai.

liquide(X) :- ask(sert_a, se_laver, X), sha(X). % Shampooing.
liquide(X) :- det(X). % Détergent à vaisselle.

ustensile_ou_vaisselle(X) :- ask(est, pointu, X), frk(X). % Fourchette.
ustensile_ou_vaisselle(X) :- ask(sert_a, cuire_des_choses, X), cas(X). % Casserole.
ustensile_ou_vaisselle(X) :- ast(X). % Assiette.

objet_divers(X) :- ask(se_trouve, une_poche, X), objet_de_poche(X).
objet_divers(X) :- ask(se_trouve, une_ecole, X), fourniture_scolaire(X).
objet_divers(X) :- plante(X). % Pour catégoriser le cactus.

objet_de_poche(X) :- ask(sert_a, deverrouiller, X), key(X). % Clé.
objet_de_poche(X) :- por(X). % Portefeuille.

fourniture_scolaire(X) :- ask(sert_a, transporter_des_choses, X), sac(X). % Sac à dos.
fourniture_scolaire(X) :- pap(X). % Papier.

plante(X) :- /*ask(est, pointu, X),*/ cac(X). % Cactus.
% Ici, on pourrait ajouter d'autres sortes de plantes.
% Si c'est le cas, on décommente ask(est, pointu, X).

asp(aspirateur).
ord(ordinateur).
tel(telephone).
frk(fourchette).
bal(balai).
cac(cactus).
ast(assiette).
fou(four).
cui(cuisiniere).
caf(cafetiere).
gri(grille_pain).
tbl(table).
cas(casserole).
sha(shampooing).
det(detergent_a_vaisselle).
bed(lit).
key(cle).
por(portefeuille).
sac(sac_a_dos).
pia(piano).
lam(lampe).
pap(papier).