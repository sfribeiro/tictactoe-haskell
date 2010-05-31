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
--  Arquivo: Aleatorio.hs                                                                     --
--      Módulo aleatório. Implementa funções de retorno aleatório.                            --
------------------------------------------------------------------------------------------------
--  Última Modificação: 30/05/2010                                                            --
------------------------------------------------------------------------------------------------

module Aleatorio (aleatorio, gerarDirecao) where

import System.IO.Unsafe
import System.Random

-- Retorna um dos argumentos recebidos aleatoriamente
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

-- Gera a direção para seguir na árvore aleatoriamente
gerarDirecao :: [Int]
gerarDirecao 
	|aleatorio 1 2 == 1 = [(aleatorio 1 2),(aleatorio 1 2),(aleatorio 1 2), (aleatorio 1 2)]
	|otherwise = [1,1,1,1]