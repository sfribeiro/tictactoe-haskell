module Regras (
	testaJogada,
	executaJogada,
	tabZerado,
	jogoConcluido,
	vencedor
	)
	where
	
import Tipos

tabZerado :: Tabuleiro
tabZerado = [(1,1,Vazio),(1,2,Vazio),(1,3,Vazio),
			(2,1,Vazio),(2,2,Vazio),(2,3,Vazio),
			(3,1,Vazio),(3,2,Vazio),(3,3,Vazio)]
			
alteraEstado :: Tabuleiro -> Int -> Int -> Estado -> Tabuleiro
alteraEstado [] _ _ _ = error "Tabuleiro Invalido!"
alteraEstado ((tx, ty, te):ts) x y e
	| tx == x && ty == y = (tx, ty, e) : ts
    | otherwise          = (tx, ty, te) : alteraEstado ts x y e
			
retornaEstado :: Tabuleiro -> Int -> Int -> Estado
retornaEstado [] _ _ = error "Tabuleiro Invalido!"
retornaEstado ((tx, ty, te):ts) x y
    | tx == x && ty == y = te
    | otherwise          = retornaEstado ts x y
	
testaJogada :: Tabuleiro -> Jogada -> Bool
testaJogada t (x, y, e)
	|retornaEstado t x y == Vazio = True
	|otherwise = False

executaJogada :: Tabuleiro -> Jogada -> Tabuleiro
executaJogada t (x , y, e) 
	| testaJogada t (x, y, e) == True = alteraEstado t x y e
	| otherwise = t
	
verificaVazio :: Tabuleiro -> Int
verificaVazio [] = 0
verificaVazio ((_,_,a):as)
	|a == Vazio = 1 + verificaVazio as
	|otherwise = verificaVazio as
	
vencedor :: Tabuleiro -> Estado
vencedor [(_,_,a),(_,_,b),(_,_,c),
		(_,_,d),(_,_,e),(_,_,f),
		(_,_,g),(_,_,h),(_,_,i)]
		|(a == b) && (b == c) && (a /= Vazio) = a
		|(d == e) && (e == f) && (d /= Vazio) = d
		|(g == h) && (h == i) && (g	/= Vazio) = g
		|(a == d) && (d == g) && (a /= Vazio) = a
		|(b == e) && (e == h) && (b /= Vazio) = b
		|(c == f) && (f == i) && (c /= Vazio) = c
		|(a == e) && (e == i) && (a /= Vazio) = a
		|(c == e) && (e == g) && (c /= Vazio) = c
		|otherwise = Vazio
	
jogoConcluido :: Tabuleiro -> Bool
jogoConcluido t
	|verificaVazio t >= 5 = False
	|verificaVazio t == 0 = True
	|vencedor t == Vazio = False
	|otherwise = True
			
