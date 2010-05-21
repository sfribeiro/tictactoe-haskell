module Auxiliar (
    aplicaSkin,
    --novoJogoP,
    --fecharJogoP,
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