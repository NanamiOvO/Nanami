\ collcount.fs
\ Name : Hanting Yang
\ CSCE331 Assignment 7 part B
\ 4/29/2019

\ Calculates the number of iterations needed for a given number to be reduced to 1
\ Sample input & output:
\ include collcount.fs  ok
\ 1 collcount . 0  ok
\ 7 collcount . 16  ok
\ 9 collcount 3 collcount . . 7 19  ok

\ collatz function
\ divide by 2 if n is even, else multiply by 3 and add 1
: collatz ( n -- n )
  dup 2 mod
  0 = if
    2 /
  else
    3 * 1 +
  endif
;

\ collcount
\ given positive integer n, return the number of iterations in collatz function
: collcount ( n -- c )
  dup 1 > if
    collatz recurse 1+
  else
    1-
  endif
;