module Regras (
	testaJogada,
	executaJogada,
	tabZerado,
	jogoConcluido,
	vencedor,
	gerarArvore,
	buscarJogada,
	quadrado
	)
	where
	
import Tipos
import Aleatorio
import Graphics.UI.WX
import System.IO.Unsafe

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
	| testaJogada t (x, y, e) = alteraEstado t x y e
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
			
			
valores :: (Int,Int) -> Int
valores (x,y)
	|x == 1 && y == 1 = 6
	|x == 1 && y == 2 = 1
	|x == 1 && y == 3 = 8
	|x == 2 && y == 1 = 7
	|x == 2 && y == 2 = 5
	|x == 2 && y == 3 = 3
	|x == 3 && y == 1 = 2
	|x == 3 && y == 2 = 9
	|x == 3 && y == 3 = 4
			
posEstado :: Estado -> Tabuleiro -> [Int]
posEstado _ [] = []
posEstado est ((x,y,e):as)
	|est == e = (valores (x,y)):posEstado est as
	|otherwise = posEstado est as
	
posEstadoAtual :: Ambiente -> [Int]
posEstadoAtual a = (posEstado (unsafePerformIO (get (ambVez a) value)) (unsafePerformIO (get (ambTbl a) value)))

posEstadoOposto :: Ambiente -> [Int]
posEstadoOposto a = (posEstado (oposto (unsafePerformIO (get (ambVez a) value))) (unsafePerformIO (get (ambTbl a) value)))

posEstadoVazio :: Ambiente -> [Int]
posEstadoVazio a = (posEstado Vazio (unsafePerformIO (get (ambTbl a) value)))
	
somatorio :: [Int] -> [Int]
somatorio [] = []
somatorio (a:as)
	| as == [] = [a]
	| otherwise = reverse (drop 1 (reverse(map (+a) as ++ somatorio as))) 
	
defesa :: [Int] -> [Int] -> Int
defesa [] _ = 0
defesa (a:as) lista
	|length l /= 0 = head l
	|otherwise = defesa as lista
	where
		l = filter (\x -> x+a==15) lista

possibilidadeGanhar :: Ambiente -> [Int] -> [Int] -> Int
possibilidadeGanhar am [] _ = head (posEstadoVazio am)
possibilidadeGanhar am (a:as) lista
	|length l /= 0 = head l
	|d /= 0 = d
	|otherwise = possibilidadeGanhar am as lista
	where 
		l = filter (\x -> (x+a==15 && x <= 9  && (x /= 9 && a /= 6))) lista
		d = defesa (somatorio (posEstadoOposto am)) (posEstadoVazio am) 
		
parJogada :: Ambiente -> (Int, Int)
parJogada a = (n,v)
	where
		n = possibilidadeGanhar a (somatorio (posEstadoAtual a)) (posEstadoVazio a)
		v = head(posEstadoVazio a)
		
gerarRaiz :: Arvore -> Ambiente -> Arvore
gerarRaiz ar a
	|n == 5 = No 6 Nulo Nulo
	|otherwise = No 5 Nulo Nulo
	where
		n = head (posEstado (oposto (unsafePerformIO ((get (ambVez a) value)))) (unsafePerformIO (get (ambTbl a) value)))
	
gerarNo :: Arvore -> Ambiente -> [Int] -> Arvore
gerarNo (No x esq dir) a (dire:as)
	|esq == Nulo && dir == Nulo = No x (No n Nulo Nulo) (No m Nulo Nulo)
	|dire == 1 = No x (gerarNo esq a as) dir
	|dire == 2 = No x esq (gerarNo dir a as)
	where
		n = fst (parJogada a)
		m = snd (parJogada a)

gerarArvore :: Arvore -> Ambiente -> [Int] -> Arvore
gerarArvore ar a dire
	|ar == Nulo = gerarRaiz ar a
	|otherwise = gerarNo ar a dire
	
buscarJogada :: Arvore -> [Int] -> Int
buscarJogada (No x esq dir) (a:as)
	|esq == Nulo && dir == Nulo = x
	|a == 1 = buscarJogada esq as
	|a == 2 = buscarJogada dir as
	
quadrado :: Int -> (Int, Int)
quadrado x
	|x == 6 = (1,1)
	|x == 1 = (1,2)
	|x == 8 = (1,3)
	|x == 7 = (2,1)
	|x == 5 = (2,2)
	|x == 3 = (2,3)
	|x == 2 = (3,1)
	|x == 9 = (3,2)
	|x == 4 = (3,3)
	
