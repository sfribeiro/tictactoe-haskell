module Regras (
	testaJogada,
	executaJogada,
	tabZerado,
	jogoConcluido,
	vencedor
	)
	where
	
import Tipos

--Tabuleiro zerado
tabZerado :: Tabuleiro
tabZerado = [(1,1,Vazio),(1,2,Vazio),(1,3,Vazio),
			(2,1,Vazio),(2,2,Vazio),(2,3,Vazio),
			(3,1,Vazio),(3,2,Vazio),(3,3,Vazio)]

-- Altera o estado de uma determinada posição do tabuleiro"			
alteraEstado :: Tabuleiro -> Int -> Int -> Estado -> Tabuleiro
alteraEstado [] _ _ _ = error "Tabuleiro Invalido!"
alteraEstado ((tx, ty, te):ts) x y e
	| tx == x && ty == y = (tx, ty, e) : ts
    | otherwise          = (tx, ty, te) : alteraEstado ts x y e

-- Recebe as coordenadas e retorna o estado naquela posição	
retornaEstado :: Tabuleiro -> Int -> Int -> Estado
retornaEstado [] _ _ = error "Tabuleiro Invalido!"
retornaEstado ((tx, ty, te):ts) x y
    | tx == x && ty == y = te
    | otherwise          = retornaEstado ts x y

-- Funções de verificações e efetivações de jogadas
	
-- Função para testar se uma jogada é válida ou não	
testaJogada :: Tabuleiro -> Jogada -> Bool
testaJogada t (x, y, e)
	|retornaEstado t x y == Vazio = True
	|otherwise = False

-- Executa a jogada
executaJogada :: Tabuleiro -> Jogada -> Tabuleiro
executaJogada t (x , y, e) 
	| testaJogada t (x, y, e) == True = alteraEstado t x y e
	| otherwise = t

-- Verifica a quantidade de Vazios no tabuleiro	
verificaVazio :: Tabuleiro -> Int
verificaVazio [] = 0
verificaVazio ((_,_,a):as)
	|a == Vazio = 1 + verificaVazio as
	|otherwise = verificaVazio as
	
-- Determina o jogador vencedor e a sequência
-- Horizontais: 1,2,3
-- Verticais: 4,5,6
-- Diagonais: 7,8
vencedor :: Tabuleiro -> (Estado, Int)
vencedor [(_,_,a),(_,_,b),(_,_,c),
		(_,_,d),(_,_,e),(_,_,f),
		(_,_,g),(_,_,h),(_,_,i)]
		|(a == b) && (b == c) && (a /= Vazio) = (a,1)
		|(d == e) && (e == f) && (d /= Vazio) = (d,2)
		|(g == h) && (h == i) && (g	/= Vazio) = (g,3)
		|(a == d) && (d == g) && (a /= Vazio) = (a,4)
		|(b == e) && (e == h) && (b /= Vazio) = (b,5)
		|(c == f) && (f == i) && (c /= Vazio) = (c,6)
		|(a == e) && (e == i) && (a /= Vazio) = (a,7)
		|(c == e) && (e == g) && (c /= Vazio) = (c,8)
		|otherwise = (Vazio,0)
	
-- Verifica se o jogo terminou
jogoConcluido :: Tabuleiro -> Bool
jogoConcluido t
	|verificaVazio t >= 5 = False
	|verificaVazio t == 0 = True
	|fst (vencedor t) == Vazio = False
	|otherwise = True
			
