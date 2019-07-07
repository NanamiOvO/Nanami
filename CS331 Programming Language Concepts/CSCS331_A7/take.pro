% take.pro
% Name: Hanting Yang
% CSCE331 Assignment 7 part D
% 4/29/2019

% take(+n, +x, ?e)
% n is a nonnegative integer, x is a list, and e is a list consisting of the first
% n items in x, or all of x, if x has fewer than n items

take(_, [], []).
take(0, _, []).
take(N, [H|Xs], [H|Es]) :- N > 0, M is N-1, take(M, Xs, Es).