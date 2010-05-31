------------------------------------------------------------------------------------------------
--  Universidade de Pernambuco                                                                --
--  Escola Politécnica de Pernambuco                                                          --
--  Engenharia de Computação                                                                  --
--  Disciplina: Linguagem de Programação Funcional                                            --
--  Professora: Eliane Loiola                                                                 --
------------------------------------------------------------------------------------------------
--  Projeto: hs#                                                                              --
------------------------------------------------------------------------------------------------
--  Equipe:                                                                                   --
--      Anderson de Oliveira Marques <andersonoliveiramarques@gmail.com>                      --
--      Rodrigo Cesar Lira da Silva  <rodrigocliras@gmail.com>                                --
--      Sergio Ferreira Ribeiro      <serginhofribeiro@gmail.com>                             --
------------------------------------------------------------------------------------------------
--  Objetivo:                                                                                 --
--      Desenvolvimento do projeto referente ao segundo exercício escolar.                    --
--                                                                                            --
--  Descrição do Projeto:                                                                     --
--      Este projeto é a implementação em Haskell do Jogo da Velha, com interface gráfica     --
--      baseada na biblioteca hxHaskell. Pode-se jogar com dois jogadores humanos ou contra a --
--      CPU. Foram utilizados recursos avançados do wxHaskell, visando um visual agradável,   --
--      inclusive com a possibilidade de troca de "skins" e reprodução de áudios.             --
------------------------------------------------------------------------------------------------
--  Arquivo: Sounds.hs                                                                        --
--      Módulo de sons. Contém as funções que reproduzem os áudios do jogo.                   --
------------------------------------------------------------------------------------------------
--  Última Modificação: 30/05/2010                                                            --
------------------------------------------------------------------------------------------------

module Sounds (
	somJogada,
	somVitoria,
	somInicio
	) where

import Graphics.UI.WX

--Reproduz o som de jogada.
somJogada :: Var Bool -> String ->IO ()
somJogada s estado = do
		x <- get s value
		if (x)
			then do
				play(sound ("sounds/somJogada" ++ estado ++ ".wav"))
			else do
				return ()
		
--Reproduz o som de vitória.
somVitoria :: Var Bool -> IO ()
somVitoria s = do
		x <- get s value     
		if (x)
			then do
				play(sound "sounds/somVitoria.wav")
			else do
				return ()

--Reproduz o som de Início.
somInicio :: Var Bool -> IO ()
somInicio s = do
		x <- get s value
		if (x)
			then do
				play(sound "sounds/somInicio.wav")
			else do
				return ()