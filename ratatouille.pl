% nombre, donde viven
rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

% nombre, que sabe cocinar, experiencia del 1 al 10
cocina(linguini, ratatouille, 3).
cocina(airik, ratatouille, 9).
cocina(linguini, sopa, 5). 
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).
cocina(linguini, ensaladaRusa, 6).

trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

restaurante(Restaurante) :-
    trabajaEn(Restaurante, _).

% ------------------- PUNTO 1 -------------------

inspeccionSatisfactoria(Restaurante) :-
    restaurante(Restaurante),
    not(rata(_, Restaurante)).

% ------------------- PUNTO 2 -------------------

chef(Empleado, Restaurante) :-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, _, _).

% ------------------- PUNTO 3 -------------------

chefcito(Rata) :-
    rata(Rata, Restaurante),
    trabajaEn(Restaurante, linguini).

% ------------------- PUNTO 4 -------------------

cocinaBien(Persona, Plato) :-
    cocina(Persona, Plato, Experiencia),
    Experiencia >= 7.

cocinaBien(remy, Plato) :-
    plato(Plato, _).

% ------------------- PUNTO 5 -------------------

encargadoDe(Encargado, Plato, Restaurante) :-
    experienciaDeUnPlatoEnRestaurante(Encargado, Plato, Restaurante, Experiencia1),
    forall((experienciaDeUnPlatoEnRestaurante(OtroEncargado, Plato, Restaurante, Experiencia2), Encargado \= OtroEncargado), Experiencia1 > Experiencia2).

experienciaDeUnPlatoEnRestaurante(Encargado, Plato, Restaurante, Experiencia) :-
    trabajaEn(Restaurante, Encargado), 
    cocina(Encargado, Plato, Experiencia).

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).
plato(helado, postre(200)).

grupo(helado).

% ------------------- PUNTO 6 -------------------

saludable(Plato) :-
    plato(Plato, TipoPlato),
    caloriasSegunPlato(TipoPlato, Calorias),
    Calorias < 75.

saludable(Plato) :-
    plato(Plato, postre(_)),
    grupo(Plato).

caloriasSegunPlato(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.

caloriasSegunPlato(principal(Guarnicion, MinutosCoccion), Calorias) :-
    CaloriasMinutos is MinutosCoccion * 5,
    caloriasSegunGuarnicion(Guarnicion, CaloriasGuarnicion),
    Calorias is CaloriasGuarnicion + CaloriasMinutos.

caloriasSegunPlato(postre(Calorias), Calorias).

caloriasSegunGuarnicion(papasFritas, 50).
caloriasSegunGuarnicion(pure, 20).
caloriasSegunGuarnicion(ensalada, 0).    

% ------------------- PUNTO 7 -------------------

criticaPositiva(Restaurante, Critico) :-
    inspeccionSatisfactoria(Restaurante),
    buenaCriticaSegunCritico(Critico, Restaurante).

buenaCriticaSegunCritico(antonEgo, Restaurante) :-
    forall(chef(Empleado, Restaurante), cocinaBien(Empleado, ratatouille)).

buenaCriticaSegunCritico(christophe, Restaurante) :-
    findall(Persona, trabajaEn(Restaurante, Persona), Empleados),
    length(Empleados, CantidadEmpleados),
    CantidadEmpleados >= 3.

buenaCriticaSegunCritico(cormillot, Restaurante) :-
    todosLosPlatosSonSaludables(Restaurante),
    ningunaEntradaSinZanahoria(Restaurante).

todosLosPlatosSonSaludables(Restaurante) :-
    forall(experienciaDeUnPlatoEnRestaurante(_, Plato, Restaurante, _), saludable(Plato)).
    
ningunaEntradaSinZanahoria(Restaurante) :-
    forall(experienciaDeUnPlatoEnRestaurante(_, Plato, Restaurante, _), tieneZanahoria(Plato)).

tieneZanahoria(Plato) :-
    plato(Plato, entrada(Ingredientes)),
    member(zanahoria, Ingredientes).
    
