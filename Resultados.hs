module Resultados where

import Graphics.UI.WX  
import Graphics.UI.WXCore
import Auxiliar
import Tipos
import Mensagens
import System.IO.Unsafe
import System.IO
import System.Directory


{-

FAZER mais tarde, ligar o botão Limpar ao comando de apagar o relatorio
e testar a formatação da mensagem quando não houver histórico

-}

-- Função que muda a visibilidade de um widget
mudarVisibilidade :: Ambiente -> IO()
mudarVisibilidade amb 
    | unsafePerformIO (get frame visible) = set frame [visible := False]
    | otherwise = set frame [visible := True]
        where frame = ambFrm amb



	
relatorioJogos :: String
relatorioJogos
	| unsafePerformIO (doesFileExist arqRelatorio) == False = ""
	| otherwise = unsafePerformIO (readFile arqRelatorio)


guiResultado a titulo resultado = do
            mudarVisibilidade a;
            r <- frameFixed [text:=titulo, picture := "tictactoe.ico",closeable :~ not] -- closeable é a negação do valor padrão
            ent <- textCtrl r [font := fontFixed,bgcolor := colorSystem (ColorBackground) , textColor := black,clientSize:= sz 350 128]

            clean <- button r [text := "Limpar"] 
            close <- button r [text := "Fechar",on command := do 
                                                                close r
                                                                mudarVisibilidade a;]
            set ent [text:=resultado,enabled:=False]
            set r [layout:= column 5 [hfill (widget ent),
                                      floatCenter $ row 5 [widget clean, widget close]],
                  clientSize:= sz 350 128]


resultados :: Ambiente -> IO ()
resultados a = do
	rel <- get (ambRel a) value
	if (rel == "")
		then do
           
			guiResultado a msgResultadoTitulo "\tNenhum hist\243rico de jogo"
            
		else do
			guiResultado a msgResultadoTitulo ("  Data      -    Hora     -     Vencedor\n\n" ++ (rel))


