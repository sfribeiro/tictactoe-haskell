module Main where

import Graphics.UI.WX
import Graphics.UI.WXCore
import Mensagens
import Tipos
import Regras
import Auxiliar
import Resultados
main :: IO()
main = start gui

gui :: IO()
gui = do
	
	-- Cria a janela do jogo o parametro position equivale a posição na tela que ela aparecerá
	f 			<- frameFixed [text := tituloJanela, picture := "tictactoe.ico",position:= pt 10 10]
	
	-- Cria os paineis da janela
	
	p3			<- panel f [clientSize := sz 384 38] -- painel do titulo
	p1 			<- panel f [clientSize := sz 384 384]
	p2			<- panel f [clientSize := sz 384 38] -- painel da vez do jogador
	
	-- Um painel para casa posição no tabuleiro
	p_1_1		<- panel p1 [clientSize := sz 128 128]
	p_1_2		<- panel p1 [clientSize := sz 128 128]
	p_1_3		<- panel p1 [clientSize := sz 128 128]
	
	p_2_1		<- panel p1 [clientSize := sz 128 128]
	p_2_2		<- panel p1 [clientSize := sz 128 128]
	p_2_3		<- panel p1 [clientSize := sz 128 128]
	
	p_3_1		<- panel p1 [clientSize := sz 128 128]
	p_3_2		<- panel p1 [clientSize := sz 128 128]
	p_3_3		<- panel p1 [clientSize := sz 128 128]
	
	-- MENU
	
	-- Jogo
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
	
	-- Opções
	mOpcoes		<- menuPane [text := menuOpcoes]
	mAvisar		<- menuItem mOpcoes [text := menuAvisar, help := ajudaAvisar]
	mSons		<- menuItem mOpcoes [text := menuSons, help := ajudaSons]
	mJogoL		<- menuLine mJogo --separador
	mSkins		<- menuPane [text := menuSkins]
	mSkinsSub	<- menuSub mOpcoes mSkins []
	mSkin1		<- menuRadioItem mSkins [text := menuSkin1]
	mSkin2		<- menuRadioItem mSkins [text := menuSkin2]
	mSkin3      <- menuRadioItem mSkins [text := menuSkin3]
	mResultados <- menuItem mOpcoes [text := menuResultado, help := ajudaResultado]

	-- Ajuda
	mAjuda		<- menuHelp [text := menuAjuda]
	mRegras		<- menuItem mAjuda [text := menuRegras, help := ajudaRegras]
	mSobre		<- menuAbout mAjuda [text := menuSobre, help := ajudaSobre]
	
	-- Barra de status
	status		<- statusField [text := ""]
	
	-- Variáveis do jogo
	
	-- Nenhum = 0
	-- Contra CPU = 1
	-- 2 jogadores = 2
	modo		<- variable [value := 0]
	
	-- Liga e desliga o aviso de jogada inválida
	aviso		<- variable [value := True]
	
	-- Armazena o tabuleiro atual do jogo
	tabuleiro	<- variable [value := tabZerado]
	
	-- Armazena a vez de jogar
	vez			<- variable [value := Vazio]
	
	-- Armazena a skin utilizada no momento
	skin		<- variable [value := ""]
	
	-- Lista de posições para ser utilizada por outras funções
	posicoes	<- toIO [p_1_1,p_1_2,p_1_3,
						p_2_1,p_2_2,p_2_3,
						p_3_1,p_3_2,p_3_3]
						
	-- Ativa ou desativa os sons do jogo
	sons		<- variable [value := True]
	
	-- Carrega o relatório de jogos
	rel			<- variable [value := relatorioJogos]
	
	-- Armazena a árvore de possibilidades
	arvore		<- variable [value := Nulo]
	
	-- Cria a estrutura Ambiente com variáveis e elementos do jogo
	amb 		<- toIO (f, tabuleiro, modo, vez, aviso, skin, posicoes, p3, p1, p2, mFecha, sons, rel, arvore)
	
	--Propriedades do Elementos
	
	-- Menu Jogo
	set mSair [on command := close f]
	set mNovo11 [on command := novoJogoP amb 1 X]
	set mNovo12 [on command := novoJogoP amb 1 O]
	set mNovo21 [on command := novoJogoP amb 2 X]
	set mNovo22 [on command := novoJogoP amb 2 O]
	set mFecha [on command := fecharJogoP amb, enabled := False]
	
	-- Menu Opções
	set mAvisar [on command := mudaAviso aviso mAvisar, checkable := True, checked := True]
	set mSons [on command := mudaSom sons mSons, checkable := True, checked := True]
	set mSkin1 [on command := aplicaSkin amb "padrao", checked := True]
	set mSkin2 [on command := aplicaSkin amb "LaVermelha"]
	set mSkin3 [on command := aplicaSkin amb "pacman"]
	set mResultados [on command := resultados amb]
	
	-- Menu Ajuda
	set mRegras [on command := infoDialog f msgRegrasTitulo msgRegras]
	set mSobre [on command := infoDialog f msgSobreTitulo msgSobre]
	
	-- Define a disposição dos elementos na janela
	set f [statusBar := [status],
		menuBar := [mJogo, mOpcoes, mAjuda],
		layout := column 0 [row 0 [widget p3], row 1 [widget p1], row 2 [widget p2]],
		clientSize := sz 384 460]

	-- Define a disposição dos elementos no tabuleiro
	set p1 [layout := floatCentre $ column 0 [
			row 1 [row 0 [widget p_1_1, widget p_1_2, widget p_1_3]],
			row 2 [row 0 [widget p_2_1, widget p_2_2, widget p_2_3]],
			row 3 [row 0 [widget p_3_1, widget p_3_2, widget p_3_3]]],
			clientSize := sz 384 384]
	
	-- Aplica a skin Padrão
	aplicaSkin amb "padrao"
	
