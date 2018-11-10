:- dynamic oui/2, non/2.

liste(X, list) :- findall(X, X, list).

verifier(X, Y) :-
    (oui(X, Y) -> true; (non(X, Y) -> false; ask(X, Y))).

ask(X, Y) :-
    format('~w de ton objet est : ~w ? ', [X, Y]),
    read(Reponse),
    (Reponse = 'oui' -> assert(oui(X, Y))); assert(non(X, Y)), false.

objet(_) :- undo, fail.
objet(X):-
    est_alimente_par(X, _),
    est_de_taille(X, _),
    sert_a(X, _),
    se_trouve(X, _).

portable(X) :- (est_alimente_par(X, electrique); est_alimente_par(X, inerte)), (est_de_taille(X, petit); est_de_taille(X, moyen)), se_trouve(X, nimporte_ou).
appareil_electromenager(X) :- est_alimente_par(X, electrique), (se_trouve(X, maison); se_trouve(X, cuisine)), (sert_a(X, nettoyer); sert_a(X, cuisiner); sert_a(X, faire_du_cafe); sert_a(X, cuire)).
gros_electromenager(X) :- appareil_electromenager(X), est_de_taille(X, gros).
petit_electromenager(X) :- appareil_electromenager(X), est_de_taille(X, moyen). % petit est vraiment pour les petits objets comme une fourchette
electronique(X) :- \+ appareil_electromenager(X), est_alimente_par(X, electrique), (est_de_taille(X, petit); est_de_taille(X, moyen)), (sert_a(X, appeler); sert_a(X, travailler); sert_a(X, jouer)).
ustensile(X) :- est_alimente_par(X, inerte), (se_trouve(X, salle_a_manger); se_trouve(X, cuisine)), (est_de_taille(X, petit); est_de_taille(X, moyen)), (sert_a(X, manger); sert_a(X, cuisiner)).
meuble(X) :- est_alimente_par(X, inerte), (est_de_taille(X, moyen); est_de_taille(X, gros)).
plante(X) :- est_alimente_par(X, vivant), sert_a(X, decorer).

est_alimente_par(X, Y) :-
    alimentation(Y),
    cobjet(X, Y, _, _, _),
    (verifier(alimentation, Y) -> foreach(alimentation(Z), assert(non(alimentation, Z)))).

est_de_taille(X, Y) :-
    taille(Y),
    cobjet(X, _, Y, _, _),
    (verifier(taille, Y) -> foreach(taille(Z), assert(non(taille, Z)))).
sert_a(X, Y) :-
    action(Y),
    cobjet(X, _, _, Y, _),
    (verifier(action, Y) -> foreach(action(Z), assert(non(action, Z)))).
se_trouve(X, Y) :-
    lieu(Y),
    cobjet(X, _, _, _, Y),
    (verifier(lieu, Y) -> foreach(lieu(Z), assert(non(lieu, Z)))).


% cobjet(nom, alimentation, taille, utilite, lieu)
cobjet(aspirateur, electrique, moyen, nettoyer, maison).
cobjet(ordinateur, electrique, moyen, travailler, bureau).
cobjet(ordinateur, electrique, moyen, etudier, ecole).
cobjet(ordinateur, electrique, moyen, jouer, maison).
cobjet(telephone, electrique, petit, appeler, _).
cobjet(fourchette, inerte, petit, manger, salle_a_manger).
cobjet(balai, inerte, moyen, nettoyer, maison).
cobjet(cactus, vivant, petit, decorer, _).
cobjet(assiette, inerte, moyen, manger, salle_a_manger).
cobjet(four, electrique, gros, cuire, cuisine).
cobjet(cuisiniere, electrique, gros, cuisiner, cuisine).
cobjet(cafetiere, electrique, moyen, faire_du_cafe, cuisine).
cobjet(cafetiere, electrique, moyen, faire_du_cafe, bureau).
cobjet(grille_pain, electrique, moyen, griller, cuisine).
cobjet(table, inerte, gros, manger, salle_a_manger).
cobjet(table, inerte, gros, travailler, bureau).
cobjet(casserole, inerte, moyen, cuisiner, cuisine).
cobjet(shampooing, inerte, petit, nettoyer, salle_de_bain).
cobjet(detergent_a_vaisselle, inerte, petit, nettoyer, cuisine).
cobjet(lit, inerte, gros, dormir, chambre).
cobjet(cle, inerte, petit, deverrouiller, poche).
cobjet(portefeuille, inerte, petit, payer, poche).
cobjet(sac_a_dos, inerte, moyen, transporter, ecole).
cobjet(sac_a_dos, inerte, moyen, transporter, bureau).
cobjet(piano, inerte, gros, jouer_de_la_musique, maison).
cobjet(lampe, electrique, moyen, eclairer, maison).
cobjet(papier, inerte, moyen, ecrire, _).


alimentation(electrique).
alimentation(inerte).
alimentation(vivant).

taille(petit).
taille(moyen).
taille(gros).

lieu(cuisine).
lieu(salle_de_bain).
lieu(bureau).
lieu(maison).
lieu(ecole).
lieu(partout).
lieu(salle_a_manger).
lieu(salle_de_bain).
lieu(chambre).
lieu(poche).

action(manger).
action(cuisiner).
action(nettoyer).
action(travailler).
action(dormir).
action(transporter).
action(jouer_de_la_musique).
action(eclairer).
action(jouer).
action(decorer).
action(appeler).
action(griller).
action(faire_du_cafe).
action(deverrouiller).
action(ecrire).
action(payer).
action(cuire).

undo :- retract(oui(_, _)), fail.
undo :- retract(non(_, _)), fail.
undo.