ask(vivant, Y) :-
      format('~w est-il en vie ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
ask(reel, Y) :-
      format('~w est-il reel ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
ask(homme, Y) :-
      format('~w est-il un homme ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
ask(chanteur, Y) :-
      format('~w est-il un chanteur ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
ask(acteur, Y) :-
      format('~w est-il un acteur ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
ask(ecrivain, Y) :-
      format('~w est-il un ecrivain? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
%#si reponse = non, implique femme(Y)
ask(politicien, Y) :-
	  format('~w est-il un politicien ?', [Y]),
	  read(Reponse),
	  Reponse = 'oui'.
ask(artiste, X) :-
      format('~w est-il un artiste ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(religieux, X) :-
      format('~w est-il relie a la religion ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(pilote, X) :-
      format('~w est-il un pilote de course ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(noir, X) :-
      format('~w a-t-il la peau noire ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(japonais, X) :-
      format('~w est-il japonais ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(vrai_nom, X) :-
      format('~w utilise-t-il son vrai nom ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(americain, X) :-
      format('~w est-il americain ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(demissionne, X) :-
      format('~w a-t-il demissionne ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(fils_dieu, X) :-
      format('~w est-il le fils de Dieu ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(plombier, X) :-
      format('~w est-il un plombier ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.

personne(X) :- ask(reel, X), reel(X).
personne(X) :- ask(homme, X), homme_jeu(X).
personne(X) :- lc(X). % Lara Croft

reel(X) :- ask(homme, X), homme_reel(X).
reel(X) :- ask(artiste, X), femme_artiste(X).
reel(X) :- cleo(X). % Cléopâtre

homme_reel(X) :- ask(artiste, X), homme_artiste(X).
homme_reel(X) :- ask(politicien, X), homme_politicien(X).
homme_reel(X) :- ask(religieux, X), homme_religieux(X).
homme_reel(X) :- /*ask(pilote, X),*/ homme_pilote(X). % Pour catégoriser les pilotes.
% Ici, on pourrait ajouter d'autres catégories pour la flexibilité.
% Si c'est le cas, on décommente ask(pilote, X).

homme_artiste(X) :- ask(noir, X), homme_artiste_noir(X).
homme_artiste(X) :- ask(vivant, X), homme_artiste_pas_noir_vivant(X).
homme_artiste(X) :- vh(X). % Victor Hugo

homme_artiste_noir(X) :- ask(vivant, X), dz(X). % Denzel Washington.
homme_artiste_noir(X) :- mj(X). % Michael Jackson

homme_artiste_pas_noir_vivant(X) :- ask(japonais, X), hk(X). % Hideo Kojima.
homme_artiste_pas_noir_vivant(X) :- ask(vrai_nom, X), qt(X). % Quentin Tarantino.
homme_artiste_pas_noir_vivant(X) :- bk(X). % Banksy.

homme_politicien(X) :- ask(americain, X), homme_politicien_americain(X).
homme_politicien(X) :- ask(vivant, X), mg(X). % Mikhail Gorbachev.
homme_politicien(X) :- staline(X). % Joseph Staline.

homme_politicien_americain(X) :- ask(demissionne, X), nixon(X).
homme_politicien_americain(X) :- eisenhower(X). % Dwight D. Eisenhower

homme_religieux(X) :- ask(fils_dieu, X), js(X). % Jesus
homme_religieux(X) :- ask(vivant, X), pape(X). % Pape Francois
homme_religieux(X) :- ms(X). % Moise

homme_pilote(X) :- ask(vivant, X), alonso(X). % Fernando Alonso
homme_pilote(X) :- senna(X). % Ayrton Senna

femme_artiste(X) :- ask(acteur, X), jl(X). % Jennifer Lawrence
femme_artiste(X) :- ask(ecrivain, X), jkr(X). % J.K. Rowling
femme_artiste(X) :- true, lg(X). % Lady Gaga

homme_jeu(X) :- ask(plombier, X), mr(X). % Mario
homme_jeu(X) :- true, jb(X). % James Bond

lc(lara_croft).
cleo(cleopatre).
vh(victor_hugo).
dz(denzel_washington).
mj(michael_jackson).
hk(hideo_kojima).
bk(banksy).
qt(quentin_tarantino).
mg(mikhail_gorbachev).
staline(joseph_staline).
nixon(richard_nixon).
eisenhower(dwight_d_eisenhower).
js(jesus).
pape(pape_francois).
ms(moise).
alonso(fernando_alonso).
senna(ayrton_senna).
jl(jennifer_lawrence).
jkr(jk_rowling).
lg(lady_gaga).
mr(mario).
jb(james_bond).


