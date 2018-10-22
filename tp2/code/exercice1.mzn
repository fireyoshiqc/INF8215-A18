include "globals.mzn";

set of int: colors = 0..4;
int: red = 0;
int: green = 1;
int: white = 2;
int: yellow = 3;
int: blue = 4;

set of int: nationalities = 0..4;
int: english = 0;
int: spanish = 1;
int: ukrainian = 2;
int: norwegian = 3;
int: japanese = 4;

set of int: drinks = 0..4;
int: coffee = 0;
int: tea = 1;
int: milk = 2;
int: orange = 3;
int: water = 4;

set of int: jobs = 0..4;
int: sculptor = 0;
int: diplomat = 1;
int: doctor = 2;
int: violonist = 3;
int: acrobat = 4;

set of int: animals = 0..4;
int: dog = 0;
int: snail = 1;
int: fox = 2;
int: horse = 3;
int: zebra = 4;

set of int: houses = 1..5;

array[colors] of var houses: color;
array[nationalities] of var houses: nation;
array[drinks] of var houses: drink;
array[jobs] of var houses: job;
array[animals] of var houses: animal;

predicate next_to(var houses:h1, var houses:h2) =
    h1 == h2 + 1 \/ h2 == h1 + 1;

predicate right_of(var houses:h1, var houses:h2) =
    h1 == h2 + 1;

predicate leftmost(var houses:h) =
    h == 1;

predicate middle(var houses:h) =
    h == 3;

constraint
    alldifferent(color) /\
    alldifferent(nation) /\
    alldifferent(drink) /\
    alldifferent(job) /\
    alldifferent(animal) /\
    nation[english] == color[red] /\
    nation[spanish] == animal[dog] /\
    color[green] == drink[coffee] /\
    nation[ukrainian] == drink[tea] /\
    right_of(color[green], color[white]) /\
    job[sculptor] == animal[snail] /\
    job[diplomat] == color[yellow] /\
    middle(drink[milk]) /\
    leftmost(nation[norwegian]) /\
    next_to(job[doctor], animal[fox]) /\
    next_to(job[diplomat], animal[horse]) /\
    job[violonist] == drink[orange] /\
    nation[japanese] == job[acrobat] /\
    next_to(nation[norwegian], color[blue]);

solve satisfy;

output [
        "color = [",
	show(color[0]), ", ",
	show(color[1]), ", ",
	show(color[2]), ", ",
	show(color[3]), ", ",
	show(color[4]), "]\n",
        "nation = [",
	show(nation[0]), ", ",
	show(nation[1]), ", ",
	show(nation[2]), ", ",
	show(nation[3]), ", ",
	show(nation[4]), "]\n",
	"drink  = [",
	show(drink[0]), ", ",
	show(drink[1]), ", ",
	show(drink[2]), ", ",
	show(drink[3]), ", ",
	show(drink[4]), "]\n",
	"job  = [",
	show(job[0]), ", ",
	show(job[1]), ", ",
	show(job[2]), ", ",
	show(job[3]), ", ",
	show(job[4]), "]\n",
	"animal = [",
	show(animal[0]), ", ",
	show(animal[1]), ", ",
	show(animal[2]), ", ",
	show(animal[3]), ", ",
	show(animal[4]), "]\n"
];

