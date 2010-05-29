module Aleatorio (aleatorio, gerarDirecao) where

import System.IO.Unsafe
import System.Random

aleatorio :: a -> a -> a
aleatorio a b = unsafePerformIO (aux1 a b)
	where
	aux1 a b = do
		newStdGen
		x <- getStdGen;
		if (aux2 (fst (next x)))
			then do
				return a
			else do
				return b
	aux2 x = (mod x 2) == 0

gerarDirecao :: [Int]
gerarDirecao = [(aleatorio 1 2),(aleatorio 1 2),(aleatorio 1 2)]