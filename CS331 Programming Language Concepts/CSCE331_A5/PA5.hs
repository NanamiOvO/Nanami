-- PA5.hs
-- Name : Hanting Yang
-- CSCE331 Assignment 5 part B
-- 3/28/2018
-- Tested with pa5_test.hs, all tests successful

module PA5 where

-- collatzCounts
collatzCounts :: [Integer]
collatzCounts = map (collatzCount 0) [1..]
collatzCount count 1 = count
collatzCount count n = collatzCount (count + 1) (collatzFunction n)
collatzFunction n
  | odd n     = 3 * n + 1
  | otherwise = n `div` 2

-- findList
findList :: Eq a => [a] -> [a] -> Maybe Int
findList = findList' 0
findList' pos xs [] = Nothing
findList' pos xs ys
  | take (length xs) ys == xs = Just pos
  | otherwise                 = findList' (pos + 1) xs (tail ys)

-- operator ##
(##) :: Eq a => [a] -> [a] -> Int
[] ## _ = 0
_ ## [] = 0
(x:xs) ## (y:ys)
  | x == y    = xs ## ys + 1
  | otherwise = xs ## ys 

-- filterAB
filterAB :: (a -> Bool) -> [a] -> [b] -> [b]
filterAB _ [] _ = []
filterAB _ _ [] = []
filterAB p (x:xs) (y:ys) =
    if (p x)
        then y:(filterAB p xs ys)
        else filterAB p xs ys

-- sumEvenOdd
sumEvenOdd :: Num a => [a] -> (a, a)
{-
  The assignment requires sumEvenOdd to be written using a fold.
  Something like this:

    sumEvenOdd xs = fold* ... xs where
        ...

  Above, "..." should be replaced by other code. The "fold*" must be
  one of the following: foldl, foldr, foldl1, foldr1.
-}
sumEvenOdd xs = (foldl (+) 0 evenNums, foldl (+) 0 oddNums)
    where evenNums = map fst $ filter (even . snd) $ zip xs [0..]
          oddNums = map fst $ filter (odd . snd) $ zip xs [0..]
