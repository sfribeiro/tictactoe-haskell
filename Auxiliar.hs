module Auxiliar (
    aplicaSkin,
    novoJogoP,
    fecharJogoP,
    mudaAviso
    ) where
	
import Graphics.UI.WX
import Graphics.UI.WXCore
import Tipos
import Regras
import Mensagens
import Time

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

atualizaTitulo :: Ambiente -> IO ()
atualizaTitulo a = do
	set (ambPn3 a) [on paint := aux a]
	repaint (ambPn3 a)
	where
		aux a dc _ = do
			s <- get (ambSkn a) value
			bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/titulo.bmp")
			drawBitmap dc bmp (pt 0 0) False []			

--Atualiza a vez do jogador.
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
					
atualiza :: Ambiente -> Tabuleiro -> [Panel ()] -> IO ()
atualiza _ [] [] = do {return ()}
atualiza a ((x, y, e):ts) (p:ps) = do
    atualizaPosicao a p e
    atualiza a ts ps		

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
					
aplicaSkin :: Ambiente -> String -> IO ()
aplicaSkin a s = do
    set (ambSkn a) [value := s]
    t1 <- get (ambTbl a) value
    atualiza a t1 (ambPos a)
    atualizaTitulo a
    atualizaVez a
	
--convertDateToString :: DateTime -> String
--convertDateToSrting dt = convertDateToString2 (toGregorian dt)

--convertDateToString2 :: (Integer, Int, Int, Int, Int, Int) -> String
--convertDateToString2 (ano, mes, dia, hora, min, seg) = (dia ++ "/" ++ mes ++ "/" ++ ano ++ " - " ++ hora ++ ":" ++ min ++ ":" ++ seg)
	
jogar :: Ambiente -> (Int,Int) -> Estado -> Point -> IO()
jogar a (x,y) est _ = do
	t0 <- get (ambTbl a) value
	e <- get (ambVez a) value
	m <- get (ambMod a) value
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
					let strTime = (show (ctDay time) ++ "/" ++ show (ctMonth time) ++ "/" ++ show (ctDay time) ++ " - " ++ show (ctHour time) ++ ":" ++ show (ctMin time) ++ ":" ++ show (ctSec time))
					case ganhador of
						X -> do
							appendFile "relatorio/relatorio.txt" (strTime ++ " - Jogador O venceu.\n")
							atualizaTab a t1 (ambPos a) (snd(vencedor t1))
							infoDialog (ambFrm a) dlgConcluidoT dlgVX
						O -> do
							appendFile "relatorio/relatorio.txt" (strTime ++ " - Jogador O venceu.\n")
							atualizaTab a t1 (ambPos a) (snd(vencedor t1))
							infoDialog (ambFrm a) dlgConcluidoT dlgVO
						Vazio -> do
							appendFile "relatorio/relatorio.txt" (strTime ++ " - Empate!\n")
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
							--jogarCPU a
							infoDialog (ambFrm a) "ERRO!" "Ainda nao implementado haha"
						else do
							return ()
	
ativaJogo :: Ambiente -> Tabuleiro -> [Panel()] -> Estado -> IO()
ativaJogo _ [] [] _ = do {return ()}
ativaJogo a ((x,y,e):ts) (p:ps) est = do
	set p [on click := jogar a (x,y) est]
	ativaJogo a ts ps est
	
novoJogo :: Ambiente -> Int -> Estado -> IO()
novoJogo a m e = do
	t0 <- get (ambTbl a) value
	ativaJogo a t0 (ambPos a) e
	atualiza a tabZerado (ambPos a)
	set (ambFch a) [enabled := True]
	set (ambMod a) [value := m]
	set (ambTbl a) [value := tabZerado]
	set (ambVez a) [value := e]
	atualizaVez a
	
novoJogoP :: Ambiente -> Int -> Estado -> IO()
novoJogoP a m e = do
    resp <- confirmDialog (ambFrm a) dlgNovoJogoT dlgNovoJogo True
    if (resp)
        then do
            novoJogo a m e
        else do
            return ()
			
desativaJogo :: [Panel ()] -> IO ()
desativaJogo [] = do {return ()}
desativaJogo (p:ps) = do
    set p [on click := nada]
    desativaJogo ps
    where
        nada _ = do {return ()}
			
fecharJogo :: Ambiente -> IO ()
fecharJogo a = do
    desativaJogo (ambPos a)
    atualiza a tabZerado (ambPos a)
    set (ambFch a) [enabled := False]
    set (ambMod a) [value := 0]
    set (ambTbl a) [value := tabZerado]
    set (ambVez a) [value := Vazio]
    atualizaVez a
	
fecharJogoP :: Ambiente -> IO ()
fecharJogoP a = do
    resp <- confirmDialog (ambFrm a) dlgFecharT dlgFechar False
    if (resp)
        then do
            fecharJogo a
        else do
            return ()
			
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
			
gettime :: IO ClockTime
gettime = getClockTime