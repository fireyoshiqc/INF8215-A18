% prerequis(A,B) A est un prerequis de B
prerequis(inf1005c, inf1010).
prerequis(inf1005c, log1000).
prerequis(inf1005c, inf1600).
prerequis(inf1010, inf2010).
prerequis(inf1010, log2410).
prerequis(log1000, log2410).
prerequis(inf2010, inf2705).

% corequis(A,B) A est un corequis de B
prerequis(log2810, inf2010).
prerequis(mth1007, inf2705).
prerequis(log2990, inf2705).
prerequis(inf1600, inf1900).
prerequis(log1000, inf1900).
prerequis(inf2205, inf1900).

complet(Prerequis,Cours):-prerequis(Prerequis,Cours).

complet(Prerequis,Cours):-prerequis(AutrePrerequis, Cours),
     complet(Prerequis, AutrePrerequis).

complet(Cours):-setof(Prerequis, Prerequis^complet(Prerequis, Cours), List).
