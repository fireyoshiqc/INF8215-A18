ask(statut, Y) :-
      format('~w est en vie ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
ask(reel, Y) :-
      format('~w existe ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
ask(homme, Y) :-
      format('~w est un homme ? ', [Y]),
      read(Reponse),
      Reponse = 'oui'.
#si reponse = non, implique femme(Y)
ask(politicien, Y) :-
	  format('~w est un politicien ?', [Y]),
	  read(Reponse),
	  Reponse = 'oui'.
ask(artiste, X) :-
      format('~w est un artiste ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.
ask(religion, X) :-
      format('~w est relie a la religion ? ', [X]),
      read(Reponse),
      Reponse = 'oui'.

personne(X) :- politicien(X).
personne(X) :- artiste(X).
artiste(X) :- ask(chanteur, X), chanteur(X).
artiste(X) :- ask(musicien, X), musicien(X).
!homme(X) :- femme(X)

