include "globals.mzn";

int: nbTeams;
array[1..nbTeams, 1..nbTeams] of int: pv;
int: nbRounds = nbTeams - 1;

set of int: equipes = 1..nbTeams;
set of int: rondes = 1..nbRounds;

array[equipes, rondes] of var equipes: opposant; % numero de l'equipe adverse
array[equipes, rondes] of var 0..1: emplacement; % 1 joue a domicile, 0 a l'exterieur

constraint forall (i in equipes, k in rondes) (emplacement[i,k] = pv[i, opposant[i, k]]); % contrainte pour le tableau d'emplacements

constraint forall (i in equipes, k in rondes) (opposant[i,k] != i); % ne peut jouer contre lui-meme

constraint forall (i in equipes, k in rondes) (opposant[opposant[i,k],k] = i); % L'opposant de l'opposant de i, c'est i

constraint forall (i in equipes) (alldifferent([opposant[i,k] | k in rondes])); % Doit jouer contre des opposants differents a chaque ronde

constraint forall (k in rondes) (alldifferent([opposant[i,k] | i in equipes])); % Toutes les rondes doivent faire jouer toutes les equipes (differentes)

constraint opposant[1, 1] < opposant[1, nbRounds]; % Contrainte pour briser la symétrie


% vérifier qu'il n'y pas 4 rounds à home de suite
constraint forall (k in 4..nbRounds, i in equipes) (
    emplacement[i, k-3] != 1 \/
    emplacement[i, k-2] != 1 \/
    emplacement[i, k-1] != 1 \/
    emplacement[i, k] != 1
  );

% vérifier qu'il n'y a pas 4 rounds à away de suite  
constraint forall (k in 4..nbRounds, i in equipes) (
    emplacement[i, k-3] != 0 \/
    emplacement[i, k-2] != 0 \/
    emplacement[i, k-1] != 0 \/
    emplacement[i, k] != 0
  );

solve
:: seq_search([
        int_search([opposant[i, j] | i in equipes, j in rondes], input_order, indomain_min, complete),
        int_search([emplacement[i, j] | i in equipes, j in rondes], input_order, indomain_min, complete),
    ]) satisfy;




