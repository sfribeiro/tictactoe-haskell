------------------------------------------------------------------------------------------------
--  Universidade de Pernambuco                                                                --
--  Escola Polit�cnica de Pernambuco                                                          --
--  Engenharia de Computa��o                                                                  --
--  Disciplina: Linguagem de Programa��o Funcional                                            --
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
--      Desenvolvimento do projeto referente ao segundo exerc�cio escolar.                    --
--                                                                                            --
--  Descri��o do Projeto:                                                                     --
--      Este projeto � a implementa��o em Haskell do Jogo da Velha, com interface gr�fica     --
--      baseada na biblioteca wxHaskell. Pode-se jogar com dois jogadores humanos ou contra a --
--      CPU. Foram utilizados recursos avan�ados do wxHaskell, visando um visual agrad�vel,   --
--      inclusive com a possibilidade de troca de "skins" e reprodu��o de �udios.             --
------------------------------------------------------------------------------------------------
--  Arquivo: Tipos.hs                                                                         --
--      M�dulo com defini��es dos tipos utilizados e fun��es sobre tipos.                     --
------------------------------------------------------------------------------------------------
--  �ltima Modifica��o: 30/05/2010                                                            --
------------------------------------------------------------------------------------------------

module Tipos (
	Estado (
		X,
		O,
		Vazio
		),
	Jogada,
    Tabuleiro,
	Arvore(
		Nulo,
		No
		),
    Ambiente,
    oposto,
    ambFrm, ambTbl,
    ambMod, ambVez,
    ambAvs, ambSkn,
    ambPos, ambPn1,
    ambPn2, ambPn3,
	ambFch, ambSom,
	ambRel, ambArv, 
	strEstado, toIO
    ) where
	
import Graphics.UI.WX
import Mensagens

-- Defini��es de tipos e dados

-- Poss�vel estado de uma posi��o no tabuleiro
data Estado = X | O | Vazio deriving (Eq)

-- Tupla com a coordenada da jogada e o estado
type Jogada = (Int,Int,Estado)

-- Tabuleiro do jogo (lista das jogadas)
type Tabuleiro = [Jogada]

-- Tipo �rvore
data Arvore = Nulo | No Int Arvore Arvore deriving (Eq)

-- Tupla das vari�veis e elementos do jogo
type Ambiente = (
    Frame (),       -- Janela principal do jogo
    Var Tabuleiro,  -- Tabuleiro do jogo
    Var Int,        -- Modo de jogo
    Var Estado,     -- Estado que est� na vez de jogar
    Var Bool,       -- Vari�vel de aviso de jogada inv�lida
    Var String,     -- Skin do jogo
    [Panel ()],     -- Lista de posi��es (pain�is) do tabuleiro
    Panel (),       -- Painel que represente o fundo da janela
    Panel (),       -- Painel que representa o placar do jogo
	Panel (),		-- Painel que representa o t�tulo do jogo
    MenuItem (),    -- Item do menu que encerra a partida
	Var Bool,		-- Vari�vel de aviso de ativa��o do som
	Var String, 	-- Relat�rio de jogos
    Var Arvore      -- �rvore do jogo
	)
	
-- Fun��es para manipula��o dos tipos
	
-- Recebe um estado e retorna o seu oposto
oposto :: Estado -> Estado
oposto e
    | e == X  = O
    | e == O = X
    | otherwise   = Vazio
	
-- Retorna somenta o elemento janela (frame)
ambFrm :: Ambiente -> Frame ()
ambFrm (a, _, _, _, _, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente o tabuleiro
ambTbl :: Ambiente -> Var Tabuleiro
ambTbl (_, a, _, _, _, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente o modo de jogo
ambMod :: Ambiente -> Var Int
ambMod (_, _, a, _, _, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente a vari�vel de vez
ambVez :: Ambiente -> Var Estado
ambVez (_, _, _, a, _, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente a vari�vel de aviso de jogada inv�lida
ambAvs :: Ambiente -> Var Bool
ambAvs (_, _, _, _, a, _, _, _, _, _, _, _, _, _) = a

-- Retorna somente o skin
ambSkn :: Ambiente -> Var String
ambSkn (_, _, _, _, _, a, _, _, _, _, _, _, _, _) = a

-- Retorna somente a lista de posi��es (pain�is)
ambPos :: Ambiente -> [Panel ()]
ambPos (_, _, _, _, _, _, a, _, _, _, _, _, _, _) = a

-- Retorna somente o painel do t�tulo
ambPn3 :: Ambiente -> Panel ()
ambPn3 (_, _, _, _, _, _, _, a, _, _, _, _, _, _) = a

-- Retorna somente o painel de fundo
ambPn1 :: Ambiente -> Panel ()
ambPn1 (_, _, _, _, _, _, _, _, a, _, _, _, _, _) = a

-- Retorna somente o painel do placar
ambPn2 :: Ambiente -> Panel ()
ambPn2 (_, _, _, _, _, _, _, _, _, a, _, _, _, _) = a

-- Retorna somente o item do menu que encerra a partida
ambFch :: Ambiente -> MenuItem ()
ambFch (_, _, _, _, _, _, _, _, _, _, a, _, _, _) = a

-- Retorna somente a vari�vel de som
ambSom :: Ambiente -> Var Bool
ambSom (_, _, _, _, _, _, _, _, _, _, _, a, _, _) = a

--Retorna somente a vari�vel relat�rio
ambRel :: Ambiente -> Var String
ambRel (_, _, _, _, _, _, _, _, _, _, _, _, a, _) = a

-- Retorna somente a vari�vel da �rvore
ambArv :: Ambiente -> Var Arvore
ambArv (_, _, _, _, _, _, _, _, _, _, _, _, _, a) = a

-- Converte Estado para String
strEstado :: Estado -> String
strEstado e
    | e == X  = strX
    | e == O = strO
    | otherwise   = strVazio

-- Converte um tipo t para o tipo IO t
toIO :: t -> IO t
toIO t = do {return (t)}