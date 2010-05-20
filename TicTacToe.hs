module Main where

import Graphics.UI.WX
import Graphics.UI.WXCore
import Mensagens
import Tipos
import Regras
import Auxiliar

main :: IO()
main = start gui

gui :: IO()
gui = do
	
	-- Cria a janela do jogo
	f 			<- frameFixed [text := tituloJanela]
	
	-- Cria os paineis da janela
	p1 			<- panel f [clientSize := sz 250 250]
	p2			<- panel f [clientSize := sz 250 48]
	
	p_1_1		<- panel p1 [clientSize := sz 48 48]
	p_1_2		<- panel p1 [clientSize := sz 48 48]
	p_1_3		<- panel p1 [clientSize := sz 48 48]
	
	p_2_1		<- panel p1 [clientSize := sz 48 48]
	p_2_2		<- panel p1 [clientSize := sz 48 48]
	p_2_3		<- panel p1 [clientSize := sz 48 48]
	
	p_3_1		<- panel p1 [clientSize := sz 48 48]
	p_3_2		<- panel p1 [clientSize := sz 48 48]
	p_3_3		<- panel p1 [clientSize := sz 48 48]
	
	mJogo		<- menuPane [text := menuJogo]
	mNovo1		<- menuItem mJogo [text := menuNovoJogoCPU, help := ajudaNovoJogoCPU]
	mNovo2		<- menuItem mJogo [text := menuNovoJogo2P, help := ajudaNovoJogo2P]
	mFecha		<- menuItem mJogo [text := menuFecha, help := ajudaFecha]
	mJogoL		<- menuLine mJogo --separador
	mSair 		<- menuQuit mJogo [text := menuSair, help := ajudaSair]
	
	status		<- statusField [text := ""]
	
	modo		<- variable [value := 0]
	
	aviso		<- variable [value := True]
	
	tabuleiro	<- variable [value := tabZerado]
	
	vez			<- variable [value := Vazio]
	
	skin		<- variable [value := ""]
	
	posicoes	<- toIO [p_1_1,p_1_2,p_1_3,
						p_2_1,p_2_2,p_2_3,
						p_3_1,p_3_2,p_3_3]
						
	amb 		<- toIO (f, tabuleiro, modo, vez, aviso, skin, posicoes, p1, p2, mFecha)
	
	set f [statusBar := [status],
		menuBar := [mJogo],
		layout := column 0 [row 0 [widget p1], row 1 [widget p2]],
		clientSize := sz 250 250]

	set p1 [layout := floatCentre $ column 0 [
			row 1 [row 0 [widget p_1_1, widget p_1_2, widget p_1_3]],
			row 2 [row 0 [widget p_2_1, widget p_2_2, widget p_2_3]],
			row 3 [row 0 [widget p_3_1, widget p_3_2, widget p_3_3]]],
			clientSize := sz 250 250]
			
	aplicaSkin amb "padrao"
	