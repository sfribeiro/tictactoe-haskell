module Sounds (
	somJogada,
	somVitoria,
	somInicio
	) where

import Graphics.UI.WX

--Reproduz o som de jogada.
somJogada :: Var Bool -> IO ()
somJogada s = do
		x <- get s value
		if (x)
			then do
				play(sound "sounds/somJogada.wav")
			else do
				play(sound "")
		
--Reproduz o som de vitória.
somVitoria :: Var Bool -> IO ()
somVitoria s = do
		x <- get s value     
		if (x)
			then do
				play(sound "sounds/somVitoria.wav")
			else do
				play(sound "")

--Reproduz o som de Início.
somInicio :: Var Bool -> IO ()
somInicio s = do
		x <- get s value
		if (x)
			then do
				play(sound "sounds/somInicio.wav")
			else do
				play(sound "")