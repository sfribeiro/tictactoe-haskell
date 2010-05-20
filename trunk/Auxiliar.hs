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

atualizaFundo :: Ambiente -> IO ()
atualizaFundo a = do
    set (ambPn1 a) [on paint := aux a]
    repaint (ambPn1 a)
    where
        aux a dc _ = do
            s <- get (ambSkn a) value
            bmp <- bitmapCreateFromFile ("skins/" ++ s ++ "/fundo.bmp")
            drawBitmap dc bmp (pt 0 0) False []					
					
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
    atualizaFundo a
    --atualizaPlacar a