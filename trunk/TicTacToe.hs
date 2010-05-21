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
	
	p3			<- panel f [clientSize := sz 384 38]
	p1 			<- panel f [clientSize := sz 384 384]
	p2			<- panel f [clientSize := sz 384 38]
	
	p_1_1		<- panel p1 [clientSize := sz 128 128]
	p_1_2		<- panel p1 [clientSize := sz 128 128]
	p_1_3		<- panel p1 [clientSize := sz 128 128]
	
	p_2_1		<- panel p1 [clientSize := sz 128 128]
	p_2_2		<- panel p1 [clientSize := sz 128 128]
	p_2_3		<- panel p1 [clientSize := sz 128 128]
	
	p_3_1		<- panel p1 [clientSize := sz 128 128]
	p_3_2		<- panel p1 [clientSize := sz 128 128]
	p_3_3		<- panel p1 [clientSize := sz 128 128]
	
	--MENU
	
	--Jogo
	mJogo		<- menuPane [text := menuJogo]
	mNovo1		<- menuPane [text := menuNovoJogoCPU]
	mNovo1Sub	<- menuSub mJogo mNovo1[]
	mNovo11		<- menuItem mNovo1 [text := "X", help := ajudaNovoJogoCPU]
	mNovo12		<- menuItem mNovo1 [text := "O", help := ajudaNovoJogoCPU]
	mNovo2		<- menuPane [text := menuNovoJogo2P]
	mNovo2Sub	<- menuSub mJogo mNovo2 []
	mNovo21		<- menuItem mNovo2 [text := "X", help := ajudaNovoJogo2P]
	mNovo22		<- menuItem mNovo2 [text := "O", help := ajudaNovoJogo2P]
	mFecha		<- menuItem mJogo [text := menuFecha, help := ajudaFecha]
	mJogoL		<- menuLine mJogo --separador
	mSair 		<- menuQuit mJogo [text := menuSair, help := ajudaSair]
	
	--Opções
	mOpcoes		<- menuPane [text := menuOpcoes]
	mAvisar		<- menuItem mOpcoes [text := menuAvisar, help := ajudaAvisar]
	mJogoL		<- menuLine mJogo --separador
	mSkins		<- menuPane [text := menuSkins]
	mSkinsSub	<- menuSub mOpcoes mSkins []
	mSkin1		<- menuRadioItem mSkins [text := menuSkin1]
	mSkin2		<- menuRadioItem mSkins [text := menuSkin2]
	
	--Ajuda
	mAjuda		<- menuHelp [text := menuAjuda]
	mRegras		<- menuItem mAjuda [text := menuRegras, help := ajudaRegras]
	mSobre		<- menuAbout mAjuda [text := menuSobre, help := ajudaSobre]
	
	status		<- statusField [text := ""]
	
	modo		<- variable [value := 0]
	
	aviso		<- variable [value := True]
	
	tabuleiro	<- variable [value := tabZerado]
	
	vez			<- variable [value := Vazio]
	
	skin		<- variable [value := ""]
	
	posicoes	<- toIO [p_1_1,p_1_2,p_1_3,
						p_2_1,p_2_2,p_2_3,
						p_3_1,p_3_2,p_3_3]
						
	amb 		<- toIO (f, tabuleiro, modo, vez, aviso, skin, posicoes, p3, p1, p2, mFecha)
	
	--PROPRIEDADES DOS ELEMENTOS
	
	--Jogo
	set mSair [on command := close f]
	set mNovo11 [on command := novoJogoP amb 1 X, checkable := True]
	set mNovo12 [on command := novoJogoP amb 1 O, checkable := True]
	set mNovo21 [on command := novoJogoP amb 2 X, checkable := True]
	set mNovo22 [on command := novoJogoP amb 2 O, checkable := True]
	
	--Opções
	set mSkin1 [on command := aplicaSkin amb "padrao", checked := True]
	set mSkin2 [on command := aplicaSkin amb "LaVermelha"]
	
	--Ajuda
	set mRegras [on command := infoDialog f msgRegrasTitulo msgRegras]
	set mSobre [on command := infoDialog f msgSobreTitulo msgSobre]
	
	
	set f [statusBar := [status],
		menuBar := [mJogo, mOpcoes, mAjuda],
		layout := column 0 [row 0 [widget p3], row 1 [widget p1], row 2 [widget p2]],
		clientSize := sz 384 460]

	set p1 [layout := floatCentre $ column 0 [
			row 1 [row 0 [widget p_1_1, widget p_1_2, widget p_1_3]],
			row 2 [row 0 [widget p_2_1, widget p_2_2, widget p_2_3]],
			row 3 [row 0 [widget p_3_1, widget p_3_2, widget p_3_3]]],
			clientSize := sz 384 384]
			
	aplicaSkin amb "padrao"
	
