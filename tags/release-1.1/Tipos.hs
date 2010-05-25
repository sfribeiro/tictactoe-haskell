module Tipos (
	Estado (
		X,
		O,
		Vazio
		),
	Jogada,
    Tabuleiro,
    Ambiente,
    oposto,
    ambFrm, ambTbl,
    ambMod, ambVez,
    ambAvs, ambSkn,
    ambPos, ambPn1,
    ambPn2, ambPn3,
	ambFch, ambSom,
	ambRel, strEstado,
    toIO
    ) where
	
import Graphics.UI.WX
import Mensagens

-- Definições de tipos e dados

-- Possível estado de uma posição no tabuleiro
data Estado = X | O | Vazio deriving (Eq)

-- Tupla com a coordenada da jogada e o estado
type Jogada = (Int,Int,Estado)

-- Tabuleiro do jogo (lista das jogadas)
type Tabuleiro = [Jogada]

-- Tupla das variáveis e elementos do jogo
type Ambiente = (
    Frame (),       -- Janela principal do jogo
    Var Tabuleiro,  -- Tabuleiro do jogo
    Var Int,        -- Modo de jogo
    Var Estado,     -- Estado que está na vez de jogar
    Var Bool,       -- Variável de aviso de jogada inválida
    Var String,     -- Skin do jogo
    [Panel ()],     -- Lista de posições (painéis) do tabuleiro
    Panel (),       -- Painel que represente o fundo da janela
    Panel (),       -- Painel que representa o placar do jogo
	Panel (),		-- Painel que representa o título do jogo
    MenuItem (),     -- Item do menu que encerra a partida
	Var Bool,		-- Variável de aviso de ativação do som
	Var String			--Relatório de jogos
    )
	
-- Funções para manipulação dos tipos
	
-- Recebe um estado e retorna o seu oposto
oposto :: Estado -> Estado
oposto e
    | e == X  = O
    | e == O = X
    | otherwise   = Vazio
	
-- Retorna somenta o elemento janela (frame)
ambFrm :: Ambiente -> Frame ()
ambFrm (a, _, _, _, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente o tabuleiro
ambTbl :: Ambiente -> Var Tabuleiro
ambTbl (_, a, _, _, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente o modo de jogo
ambMod :: Ambiente -> Var Int
ambMod (_, _, a, _, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente a variável de vez
ambVez :: Ambiente -> Var Estado
ambVez (_, _, _, a, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente a variável de aviso de jogada inválida
ambAvs :: Ambiente -> Var Bool
ambAvs (_, _, _, _, a, _, _, _, _, _, _, _, _) = a

-- Retorna somente o skin
ambSkn :: Ambiente -> Var String
ambSkn (_, _, _, _, _, a, _, _, _, _, _, _, _) = a

-- Retorna somente a lista de posições (painéis)
ambPos :: Ambiente -> [Panel ()]
ambPos (_, _, _, _, _, _, a, _, _, _, _, _, _) = a

-- Retorna somente o painel do título
ambPn3 :: Ambiente -> Panel ()
ambPn3 (_, _, _, _, _, _, _, a, _, _, _, _, _) = a

-- Retorna somente o painel de fundo
ambPn1 :: Ambiente -> Panel ()
ambPn1 (_, _, _, _, _, _, _, _, a, _, _, _, _) = a

-- Retorna somente o painel do placar
ambPn2 :: Ambiente -> Panel ()
ambPn2 (_, _, _, _, _, _, _, _, _, a, _, _, _) = a

-- Retorna somente o item do menu que encerra a partida
ambFch :: Ambiente -> MenuItem ()
ambFch (_, _, _, _, _, _, _, _, _, _, a, _, _) = a

-- Retorna somente a variável de som
ambSom :: Ambiente -> Var Bool
ambSom (_, _, _, _, _, _, _, _, _, _, _, a, _) = a

--Retorna somente a variável relatório
ambRel :: Ambiente -> Var String
ambRel (_, _, _, _, _, _, _, _, _, _, _, _, a) = a

-- Converte Estado para String
strEstado :: Estado -> String
strEstado e
    | e == X  = strX
    | e == O = strO
    | otherwise   = strVazio


-- Converte um tipo t para o tipo IO t
toIO :: t -> IO t
toIO t = do {return (t)}