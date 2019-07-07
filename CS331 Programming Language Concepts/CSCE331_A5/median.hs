-- median.hs
-- Name : Hanting Yang
-- CSCE331 Assignment 5 part C
-- 3/28/2018
-- Haskell program to ask the user for a list of numbers, it terminates
-- with an empty line, and calculate the median of the list
-- then asks the user if they would like to enter another list

-----------------------------------
--Caution: Inputs are limited
--Only Integers are allowed for the list
-----------------------------------

module Main where

import Data.List(sort)
import System.IO

main = do 
    putStrLn ""
    putStrLn "Enter a list of integers, one on each line."
    putStrLn "I will compute the median of the list."
    putStrLn ""
    medianList[]
    putStrLn ""
    putStr "Compute another median? [y/n] "
    c <- getLine
    if c == "y"
        then main
        else do
            putStrLn "Bye!"
            return ()

medianList :: [Integer] -> IO()
medianList xs = do
    putStr "Enter number (blank line to end): "
    line <- getLine
    if line == ""
        then putStrLn $ medianInput $ median xs
        else medianList $ read line : xs

median [] = Nothing
median xs = Just (sort xs !! div (length xs) 2)
medianInput Nothing = "Empty list - no median"
medianInput (Just median) = "Median: " ++ show median