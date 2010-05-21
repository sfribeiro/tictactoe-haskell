module Auxiliar (
    aplicaSkin,
    novoJogoP,
    fecharJogoP,
    --mudaAviso
    ) where
	
import Graphics.UI.WX
import Graphics.UI.WXCore
import Tipos
import Regras
import Mensagens

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
		set (ambPn2 a) [on paint := aux2 s (aux1 v)]
		repaint (ambPn2 a)
		where
			aux1 v
				| v == X  = "vezx"
				| v == O = "vezo"
				| otherwise   = ""
			aux2 s v dc viewArea = do
				bmp_fundo <- bitmapCreateFromFile ("skins/" ++ s ++ "/veznada.bmp")
				drawBitmap dc bmp_fundo (pt 0 0) False []
				if (v /= "")
					then do
						bmp <- (bitmapCreateFromFile ("skins/" ++ s ++ "/" ++ v ++ ".bmp"))
						drawBitmap dc bmp (pt 0 0) True []
					else do
						return ()
					
atualiza :: Ambiente -> Tabuleiro -> [Panel ()] -> IO ()
atualiza _ [] [] = do {return ()}
atualiza a ((x, y, e):ts) (p:ps) = do
    atualizaPosicao a p e
    atualiza a ts ps					

aplicaSkin :: Ambiente -> String -> IO ()
aplicaSkin a s = do
    set (ambSkn a) [value := s]
    t1 <- get (ambTbl a) value
    atualiza a t1 (ambPos a)
    atualizaTitulo a
    atualizaVez a
	
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
			--atualizaPlacar a 
			if (jogoConcluido t1)
				then do
					ganhador <- toIO (vencedor t1)
					case ganhador of
						X -> do
							infoDialog (ambFrm a) dlgConcluidoT dlgVX
						O -> do
							infoDialog (ambFrm a) dlgConcluidoT dlgVO
						Vazio -> do
							infoDialog (ambFrm a) dlgConcluidoT dlgVEmpate
					resp <- confirmDialog (ambFrm a) dlgNovoJogoT dlgNovoJogo True
					if (resp)
						then do
							novoJogo a m est
						else do
							fecharJogo a
				else do
					set (ambVez a) [value := oposto e]
					--atualizaPlacar a
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
	--atualizaPlacar a
	
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
    --atualizaPlacar a
	
fecharJogoP :: Ambiente -> IO ()
fecharJogoP a = do
    resp <- confirmDialog (ambFrm a) dlgFecharT dlgFechar False
    if (resp)
        then do
            fecharJogo a
        else do
            return ()
		