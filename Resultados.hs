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
--  Arquivo: Resultados.hs                                                                    --
--      Módulo resultados. Implementa funções para mostrar os resultados.                     --
------------------------------------------------------------------------------------------------
--  Última Modificação: 30/05/2010                                                            --
------------------------------------------------------------------------------------------------

module Resultados (relatorioJogos, resultados) where

import Graphics.UI.WX  
import Graphics.UI.WXCore
import Auxiliar
import Tipos
import Mensagens
import System.IO.Unsafe
import System.IO
import System.Directory

-- Função que muda a visibilidade de um widget
mudarVisibilidade :: Ambiente -> IO()
mudarVisibilidade amb 
    | unsafePerformIO (get frame enabled) = set frame [enabled := False]
    | otherwise = set frame [visible := True, enabled := True]
        where frame = ambFrm amb
	
-- Função que lê o arquivo
relatorioJogos :: String
relatorioJogos
	| unsafePerformIO (doesFileExist arqRelatorio) == False = ""
	| otherwise = unsafePerformIO (readFile arqRelatorio)	

-- Função que cria a janela com a leitura do arquivo
resultados :: Ambiente -> IO ()
resultados a = do
	rel <- get (ambRel a) value
	if (rel == "")
		then do           
			guiResultado a msgResultadoTitulo "\n\tNenhum hist\243rico de jogo"            
		else do
			guiResultado a msgResultadoTitulo ("  Data      -    Hora     -     Vencedor\n\n" ++ (rel))

guiResultado a titulo resultado = do
            mudarVisibilidade a;
            r <- frameFixed [text:=titulo, picture := "tictactoe.ico",closeable :~ not,position := pt 10 10, minimizeable := False]
            ent <- textCtrl r [font := fontFixed, bgcolor := black , color := white, clientSize:= sz 400 256]
            clean <- button r [text := "Limpar",on command := do
                                                                set ent [text:="\n\tNenhum hist\243rico de jogo\t"]
                                                                set (ambRel a) [value := ""]
                                                                if (unsafePerformIO (doesFileExist arqRelatorio))
                                                                        then do
                                                                                removeFile arqRelatorio;
                                                                        else do
                                                                                return ()]
            close <- button r [text := "Fechar",on command := do 
                                                                close r
                                                                mudarVisibilidade a;]
            set ent [text:=resultado]
            set r [layout:= column 5 [hfill (widget ent),
                                      floatCenter $ row 1 [widget clean, widget close]],
                 clientSize:= sz 350 120]