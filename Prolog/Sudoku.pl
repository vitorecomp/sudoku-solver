%VITOR DE ARAUJO VIEIRA 11/0067151
%MATHEUS ROSENDO PEDREIRA
%PAULO

:- use_module(library(clpfd)).

%Operaçoes da Lista
%Aqui irao contar todos os regras que 
%iram reger o regime de um lista
%como as regras de controle para a cada
%uma das listas
nPossui(_, []).
nPossui(X,[K|Y]) :- nPossui(X, Y), X \= K.

nPossuiRepetidos([]).
nPossuiRepetidos([X|Y]):- 
		nPossui(X, Y), 
		nPossuiRepetidos(Y).

possui(X, [X|_]).
possui(X, [_|Y]):- 
		possui(X, Y).
%Add On List of List Pass Cordanates
addOnListOfLists([], T, 0, J ,[R]):-
		addOnList([], T, J, R).

addOnListOfLists([X|Y], T, 0, J, [R|Y]):-
		addOnList(X, T, J, R).

addOnListOfLists([], T, I, J, [[]|R]):-
		I1 is I - 1,
		I1 >= 0,
		addOnListOfLists([], T, I1, J, R).

addOnListOfLists([X|Y], T, I, J, [X|R]) :-
		I1 is I - 1,
		I1 >= 0,
		addOnListOfLists(Y, T, I1, J, R).

%Add on List / ModiFy
addOnList([], P, 0, [P]).

addOnList([X|Y], T, 0, [T|Y]).

addOnList([], P, K, [[]|J]) :-
		T is K - 1,
		K >= 0,
		addOnList([], P, T, J).

addOnList([X|Y], P, K, [X|J]) :-
		T is K - 1,
		T >= 0,
		addOnList(Y, P, T, J).


%sudoKu Final
sudoKu(X, R) :-
	verificaTamanho(X, S),
	validaColunas(X, S),
	validaLinhas(X, S),
	controiLista(S, L),
	sudoKu(X, L, P).

%sudoKu Sem Validações
sudoKu(X, T, P) :-
	prencheN(X, P, T),
	verificaLinhas(P),
	verificaBlocos(P),
	verificaColunas(P).

%Funçoes Verificadoras
%Essas sao as funçoes responsaveis
%pela validaçao do sudoku
verificaColunas([]).

verificaColunas([X|Y]) :-
	verificaColunas(Y),
	nPossuiRepetidos(X).

verificaLinhas([]).

verificaLinhas(X) :- 
		transpose(X, P),
		verificaColunas(P).

verificaBlocos(X) :-
	transforma(2,X,0,P),
	verificaColunas(P).

transforma(_, [], _, P) :- P = [].
transforma(S, [X|Y], I, R):-
	T is I + 1,
	transforma(S, Y, T, P),
	transforma(S, X, I, 0, P, R).
	

transforma(_, [], _, _, P, R):- R = P.
transforma(S, [X|Y], I, J ,P, R):-
	T is J + 1,
	transforma(S, Y, I, T , P, K),
	converte(S, I, J, I1, J1),
	addOnListOfLists(K, X, I1, J1, R).

converte(S,I, J, I1, J1) :- 
		I2 is mod(I, S),
		J2 is mod(J, S),
		I3 is div(I, S),
		J3 is div(J, S),
		I1 is I3 + J3*S, 
		J1 is I2 + J2*S.


%Prenchendo N Listas
%Essa Funçao apenas Prenche N listas sem qualquer
%validaçao ou seja ela apenas remove os zeros das
%listas passadas
prencheN([],P,_ ) :- P = [].

prencheN([X|Y], P, N) :-
	prencheN(Y, Z, N), 
	prenche(X, K, N),
	nPossuiRepetidos(K),
	P = [K|Z].

%Prenchendo uma lista
%Essa Funçao recebe uma lista com uma certa
%guantidade de 0 e retorna todas as possibilidades
%de sustituiçao de zeros desta
prenche([], [], _).

prenche([X|Y], R, T) :- R = [K | P],
		prenche(Y, P, T) ,
		((X = 0 , possui(K, T));
		( X \= 0 , K = X)).
