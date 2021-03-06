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
--      baseada na biblioteca wxHaskell. Pode-se jogar com dois jogadores humanos ou contra a --
--      CPU. Foram utilizados recursos avançados do wxHaskell, visando um visual agradável,   --
--      inclusive com a possibilidade de troca de "skins" e reprodução de áudios.             --
------------------------------------------------------------------------------------------------
--  Arquivo: Auxiliar.hs                                                                      --
--      Módulo para auxiliar o principal. Basicamente com funções de IO.                      --
------------------------------------------------------------------------------------------------
--  Última Modificação: 30/05/2010                                                            --
------------------------------------------------------------------------------------------------

module Auxiliar (
    aplicaSkin,
    novoJogoP,
    fecharJogoP,
    mudaAviso,
	mudaSom
	) where
	
import Graphics.UI.WX
import Graphics.UI.WXCore
import Tipos
import Regras
import Mensagens
import Time
import Sounds
import Aleatorio

-- Funções para atualização do tabuleiro

-- Atualiza a figura mostrada em uma posição do tabuleiro
atualizaPosicao :: Ambiente -> Panel () -> Estado -> IO ()
atualizaPosicao a p e = do
    set p [on paint := aux a e]
    repaint p
    where
        aux a e dc _ = do
            s <- get (ambSkn a) value
            case e of
                X -> do
                    bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/x.bmp")
                    drawBitmap dc bmp (pt 0 0) False []
                O -> do
                    bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/o.bmp")
                    drawBitmap dc bmp (pt 0 0) False []
                Vazio -> do
                    bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/vazio.bmp")
                    drawBitmap dc bmp (pt 0 0) False []

-- Atualiza o título do jogo dependendo da skin					
atualizaTitulo :: Ambiente -> IO ()
atualizaTitulo a = do
	set (ambPn3 a) [on paint := aux a]
	repaint (ambPn3 a)
	where
		aux a dc _ = do
			s <- get (ambSkn a) value
			bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/titulo.bmp")
			drawBitmap dc bmp (pt 0 0) False []			

-- Atualiza a vez do jogador
atualizaVez :: Ambiente -> IO ()
atualizaVez a = do
		v <- get (ambVez a) value
		t <- get (ambTbl a) value
		s <- get (ambSkn a) value
		set (ambPn2 a) [on paint := aux1 s v]
		repaint (ambPn2 a)
		where
			aux1 s v dc viewArea = do
				if (strEstado v /= "vazio")
					then do
						bmp <- (bitmapCreateFromFile ("skins/" ++ s ++ "/" ++ strEstado v ++ ".bmp"))
						drawBitmap dc bmp (pt 0 0) True []
					else do
						bmp_fundo <- bitmapCreateFromFile ("skins/" ++ s ++ "/veznada.bmp")
						drawBitmap dc bmp_fundo (pt 0 0) False []

-- Atualiza todas as posições do tabuleiro de acordo com a situação do jogo						
atualiza :: Ambiente -> Tabuleiro -> [Panel ()] -> IO ()
atualiza _ [] [] = do {return ()}
atualiza a ((x, y, e):ts) (p:ps) = do
    atualizaPosicao a p e
    atualiza a ts ps		

-- Insere as figuras de vencedores na posição passada
atualizaWin :: Ambiente -> Panel () -> Estado -> IO ()
atualizaWin a p e = do
    set p [on paint := aux a e]
    repaint p
    where
        aux a e dc _ = do
            s <- get (ambSkn a) value
            case e of
                X -> do
                    bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/winx.gif")
                    drawBitmap dc bmp (pt 0 0) False []
                O -> do
                    bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/wino.gif")
                    drawBitmap dc bmp (pt 0 0) False []
                Vazio -> do
                    bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/vazio.bmp")
                    drawBitmap dc bmp (pt 0 0) False []

-- Atualiza tabuleiro com as figuras dos vencedores					
atualizaTab :: Ambiente -> Tabuleiro -> [Panel()] -> Int -> IO()
atualizaTab _ [] [] _ = do {return ()}
atualizaTab a ((x,y,e):ts) (p:ps) v = do
	if (v == 1)
		then do
			if ((x == 1 && y == 1) || (x == 1 && y == 2) || (x == 1 && y == 3))
				then do
					atualizaWin a p e
				else do
					return ()
		else do
			if (v == 2)
				then do
					if ((x == 2 && y == 1) || (x == 2 && y == 2) || (x == 2 && y == 3))
						then do
							atualizaWin a p e
						else do
							return ()
				else do
					if (v == 3)
						then do
							if ((x == 3 && y == 1) || (x == 3 && y == 2) || (x == 3 && y == 3))
								then do
									atualizaWin a p e
								else do
									return ()
						else do
							if (v == 4)
								then do
									if ((x == 1 && y == 1) || (x == 2 && y == 1) || (x == 3 && y == 1))
										then do
											atualizaWin a p e
										else do
											return ()
								else do
									if (v == 5)
										then do
											if ((x == 1 && y == 2) || (x == 2 && y == 2) || (x == 3 && y == 2))
												then do
													atualizaWin a p e
												else do
													return ()
										else do
											if (v == 6)
												then do
													if ((x == 1 && y == 3) || (x == 2 && y == 3) || (x == 3 && y == 3))
														then do
															atualizaWin a p e
														else do
															return ()
												else do
													if (v == 7)
														then do
															if ((x == 1 && y == 1) || (x == 2 && y == 2) || (x == 3 && y == 3))
																then do
																	atualizaWin a p e
																else do
																	return ()
														else do
															if (v == 8)
																then do
																	if ((x == 1 && y == 3) || (x == 2 && y == 2) || (x == 3 && y == 1))
																		then do
																			atualizaWin a p e
																		else do
																			return ()
																else do
																	atualizaPosicao a p e														
	atualizaTab a ts ps v																

-- Muda a skin do jogo e as figuras do tabuleiro	
aplicaSkin :: Ambiente -> String -> IO ()
aplicaSkin a s = do
    set (ambSkn a) [value := s]
    t1 <- get (ambTbl a) value
    atualiza a t1 (ambPos a)
    atualizaTitulo a
    atualizaVez a
	
-- Funções da jogada

-- Realiza ou rejeita uma jogada feita
jogar :: Ambiente -> (Int,Int) -> Estado -> [Int] -> Point -> IO()
jogar a (x,y) est direcao _ = do
	t0 <- get (ambTbl a) value
	e <- get (ambVez a) value
	m <- get (ambMod a) value
	somJogada (ambSom a) (strEstado e)
	if(not (testaJogada t0 (x,y,e)))
		then do
			av <- get (ambAvs a) value
			if (av)
				then do
					warningDialog (ambFrm a) dlgInvalidaT dlgInvalida
				else do
					return ()
		else do
			set (ambTbl a) [value := executaJogada t0 (x, y, e)]
			t1 <- get (ambTbl a) value
			atualiza a t1 (ambPos a)
			atualizaVez a
			if (jogoConcluido t1)
				then do
					ganhador <- toIO (fst (vencedor t1))
					time2 <- gettime
					time <- toCalendarTime time2
					let strTime = (show (ctDay time) ++ "/" ++  changeMonth (show (ctMonth time)) ++ "/" ++ show (ctYear time) ++ " - " ++ strHour (ctHour time) ++ ":" ++ strHour (ctMin time) ++ ":" ++ strHour (ctSec time))
					case ganhador of
						X -> do
							somVitoria (ambSom a)
							appendFile arqRelatorio (strTime ++ " - Jogador X.\n")
							r <- get (ambRel a) value
							set (ambRel a) [value := (juntaString r (strTime ++ " - Jogador X.\n"))]
							r <- get (ambRel a) value
							atualizaTab a t1 (ambPos a) (snd(vencedor t1))
							infoDialog (ambFrm a) dlgConcluidoT dlgVX
						O -> do
							somVitoria (ambSom a)
							appendFile arqRelatorio (strTime ++ " - Jogador O.\n")
							r <- get (ambRel a) value
							set (ambRel a) [value := (juntaString r (strTime ++ " - Jogador O.\n"))]
							r <- get (ambRel a) value
							atualizaTab a t1 (ambPos a) (snd(vencedor t1))
							infoDialog (ambFrm a) dlgConcluidoT dlgVO
						Vazio -> do
							appendFile arqRelatorio (strTime ++ " - Empate!\n")
							r <- get (ambRel a) value
							set (ambRel a) [value := (juntaString r (strTime ++ " - Empate!\n"))]
							r <- get (ambRel a) value
							infoDialog (ambFrm a) dlgConcluidoT dlgVEmpate
					resp <- confirmDialog (ambFrm a) dlgNovoJogoT dlgNovoJogo True
					if (resp)
						then do
							novoJogo a m est
						else do
							fecharJogo a
				else do
					set (ambVez a) [value := oposto e]
					atualizaVez a
					if(oposto e == oposto est && m == 1)
						then do
							ar <- get (ambArv a) value
							jogarCPU a e ar direcao
						else do
							return ()
							
-- Faz a CPU jogar
jogarCPU :: Ambiente -> Estado -> Arvore -> [Int] -> IO ()
jogarCPU a est ar direcao = do
	desativaJogo (ambPos a)
	tmp <- timer (ambFrm a) [interval := 500]
	set tmp [on command := aux1 a tmp]
	where
		aux1 a tmp = do
			set tmp [enabled := False]
			t0 <- get (ambTbl a) value
			set (ambArv a) [value := gerarArvore ar a direcao]
			ar1 <- get (ambArv a) value
			ativaJogo a t0 (ambPos a) est
			jogar a (quadrado(buscarJogada ar1 direcao)) est direcao (pt 0 0)
			

-- Funções para mudar parâmetros do jogo
							
-- Ativa a ação do click nas posições do tabuleiro
ativaJogo :: Ambiente -> Tabuleiro -> [Panel()] -> Estado -> IO()
ativaJogo _ [] [] _ = do {return ()}
ativaJogo a ((x,y,e):ts) (p:ps) est = do
	set p [on click := jogar a (x,y) est gerarDirecao]
	ativaJogo a ts ps est

-- Desativa a ação do click nas posições do tabuleiro	
desativaJogo :: [Panel ()] -> IO ()
desativaJogo [] = do {return ()}
desativaJogo (p:ps) = do
	set p [on click := nada]
	desativaJogo ps
	where
		nada _ = do {return ()}

-- Inicia um novo jogo		
novoJogo :: Ambiente -> Int -> Estado -> IO()
novoJogo a m e = do
	somInicio (ambSom a)
	t0 <- get (ambTbl a) value
	ativaJogo a t0 (ambPos a) e
	atualiza a tabZerado (ambPos a)
	set (ambFch a) [enabled := True]
	set (ambMod a) [value := m]
	set (ambTbl a) [value := tabZerado]
	set (ambVez a) [value := e]
	set (ambArv a) [value := Nulo]
	atualizaVez a

-- Pergunta se o usuário deseja iniciar um novo jogo	
novoJogoP :: Ambiente -> Int -> Estado -> IO()
novoJogoP a m e = do
    resp <- confirmDialog (ambFrm a) dlgNovoJogoT dlgNovoJogo True
    if (resp)
        then do
            novoJogo a m e
        else do
            return ()
			
-- Encerra a partida ativa, caso exista			
fecharJogo :: Ambiente -> IO ()
fecharJogo a = do
	desativaJogo (ambPos a)
	atualiza a tabZerado (ambPos a)
	set (ambFch a) [enabled := False]
	set (ambMod a) [value := 0]
	set (ambTbl a) [value := tabZerado]
	set (ambArv a) [value := Nulo]
	atualizaVez a

-- Pergunta se o usuário deseja encerrar a partida ativa	
fecharJogoP :: Ambiente -> IO ()
fecharJogoP a = do
    resp <- confirmDialog (ambFrm a) dlgFecharT dlgFechar False
    if (resp)
        then do
            fecharJogo a
        else do
            return ()

-- Muda a variável que avisa quando uma jogada é inválida			
mudaAviso :: Var Bool -> MenuItem () -> IO ()
mudaAviso a m = do
    av <- get a value
    if (av)
        then do
            set a [value := False]
            set m [checked := False]
        else do
            set a [value := True]
            set m [checked := True]

-- Muda a variável que ativa ou desativa o som			
mudaSom :: Var Bool -> MenuItem() -> IO ()
mudaSom a m = do
	s <- get a value
	if(s)
		then do
			set a [value := False]
			set m [checked := False]
		else do
			set a [value := True]
			set m [checked := True]


-- Concatena das strings e retorna			
juntaString :: String -> String -> String
juntaString a b = a ++ b

-- Funções do Tempo

-- Pega a hora local			
gettime :: IO ClockTime
gettime = getClockTime

-- Transforma a hora, minuto, segundo em string
strHour :: Int -> String
strHour x
	| x > 9 = show (x)
	| otherwise = "0" ++ show (x)