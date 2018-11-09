:- dynamic oui/1, non/1.

verifier(X, Y) :-
    (oui(X) -> true; (non(X) -> false; ask(X, Y))).

verifier_action(X, Y) :-
    (oui(Y) -> true; (non(Y) -> false; ask(X, Y))).

ask(electrique, X) :-
    format('Ton objet est-il electrique ? ', [X]),
    read(Reponse),
    (Reponse = 'oui' -> assert(oui(electrique)); assert(non(electrique)), false).

ask(action, Y) :-
    format('Ton objet sert-il a ~w ? ', [Y]),
    read(Reponse),
    (Reponse = 'oui' -> assert(oui(Y)); assert(non(Y)), false).

ask(lieu, Y) :-
    format('~w se trouve dans le/la ? ', [Y]),
    read(Reponse),
    Reponse = 'oui'.

objet(_) :- undo, fail.
objet(X) :- electromenager(X).
objet(X) :- meuble(X).
objet(X) :- ustensile(X).
objet(X) :- plante(X).


%objet(X) :- electronique(X).

%objet(X) :- instrument(X).
%objet(X) :- outil(X).

%objet(X) :- meuble(X).


electromenager(X) :- est_electrique(X), (sert_a(X, nettoyer); sert_a(X, cuisiner)).

meuble(X) :- \+ est_electrique(X),
    (sert_a(X, manger); sert_a(X, dormir); sert_a(X, contenir); sert_a(X, decorer)).

ustensile(X) :- (sert_a(X, cuisiner); sert_a(X, manger)).

plante(X) :- \+ est_electrique(X), sert_a(X, decorer).

est_electrique(X) :- verifier(electrique, X), electrique(X).
sert_a(X, Y) :- utilite(X, Y), action(Y), verifier_action(action, Y).

utilite(aspirateur, nettoyer).
utilite(detergent_a_vaisselle, nettoyer).
utilite(shampooing, nettoyer).
utilite(table, manger).
utilite(lit, dormir).
utilite(sac_a_dos, contenir).
utilite(ordinateur, travailler).
utilite(casserole, cuisiner).
utilite(four, cuisiner).
utilite(cactus, decorer).


electrique(aspirateur).
electrique(four).
electrique(ordinateur).

lieu(cuisine).
lieu(salle_de_bain).
lieu(bureau).


action(manger).
action(cuisiner).
action(nettoyer).
action(travailler).
action(etudier).
action(dormir).
action(contenir).
action(musique).
action(eclairer).
action(jouer).
action(decorer).

undo :- retract(oui(_)), fail.
undo :- retract(non(_)), fail.
undo.