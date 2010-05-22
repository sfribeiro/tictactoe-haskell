module Mensagens where

tituloJanela :: String
tituloJanela = "Jogo da Velha"

menuJogo :: String
menuJogo = "&Jogo"

menuNovoJogoCPU :: String
menuNovoJogoCPU = "Novo jogo - contra CPU"
ajudaNovoJogoCPU :: String
ajudaNovoJogoCPU = "Inicia um novo jogo contra a CPU"

menuNovoJogo2P :: String
menuNovoJogo2P = "Novo jogo - 2 jogadores"
ajudaNovoJogo2P :: String
ajudaNovoJogo2P = "Inicia um novo jogo para 2 jogadores"

menuFecha :: String
menuFecha = "Encerrar partida"
ajudaFecha :: String
ajudaFecha = "Encerra a partida atual"

menuSair :: String
menuSair = "Sair"
ajudaSair :: String
ajudaSair = "Sai do Jogo da Velha"

menuOpcoes :: String
menuOpcoes = "&Opcoes"

menuAvisar :: String
menuAvisar = "Avisar jogada invalida"
ajudaAvisar :: String
ajudaAvisar = "Exibicao de uma mensagem quando a jogada for invalida"

menuSkins :: String
menuSkins = "Selecionar skin"

menuSkin1 :: String
menuSkin1 = "1. Padrao"

menuSkin2 :: String
menuSkin2 = "2. LaVermelha"

menuAjuda :: String
menuAjuda = "&Ajuda"

menuRegras :: String
menuRegras = "Regras do Jogo"
ajudaRegras :: String
ajudaRegras = "Mostra as regras do jogo"

menuSobre :: String
menuSobre = "Sobre..."
ajudaSobre :: String
ajudaSobre = "Sobre o Jogo da Velha"

-- Regras do Jogo
msgRegrasTitulo :: String
msgRegrasTitulo = "Regras do Jogo"

msgRegras :: String
msgRegras =
    "REGRAS DO JOGO\n" ++
    "------------------------------------------------------------\n\n" ++
    "O tabuleiro  e uma matriz  de tres linhas por tres colunas.\n" ++
    "Dois jogadores escolhem uma marcacao cada um, geralmente um circulo (O) e um xis (X).\n" ++
    "Os jogadores jogam alternadamente, uma marcacao por vez, numa lacuna que esteja vazia.\n" ++
    "O objetivo e conseguir tres circulos ou tres xis em linha, quer horizontal, vertical ou diagonal,"++ 
	"e ao mesmo tempo, quando possivel, impedir o adversario de ganhar na proxima jogada.\n" ++
    "Quando um jogador conquista o objetivo, costuma-se riscar os tres simbolos."



msgSobreTitulo :: String
msgSobreTitulo = "Sobre o Jogo da Velha"

msgSobre :: String
msgSobre =
    "Jogo da Velha 1.0\n" ++
    "------------------------------------------------------------\n\n" ++
    "Linguagem utilizada: Haskell\n\n" ++ 
    "Equipe:\n" ++
    "- Anderson de Oliveira Marques\n" ++
    "- Rodrigo Cesar Lira da Silva\n" ++
    "- Sergio Ferreira Ribeiro"

strX:: String
strX = "vezx"

strO :: String
strO = "vezo"

strVazio :: String
strVazio = "vazio"

dlgInvalidaT :: String
dlgInvalidaT = "Jogada Invalida!"

dlgInvalida :: String
dlgInvalida = "Voce deve jogar em outro lugar!"

dlgNovoJogoT :: String
dlgNovoJogoT = "Novo Jogo?"

dlgNovoJogo :: String
dlgNovoJogo = "Deseja iniciar um novo jogo?"

dlgFecharT :: String
dlgFecharT = "Encerrar Partida?"

dlgFechar :: String
dlgFechar = "Deseja encerrar a partida atual?"

dlgConcluidoT :: String
dlgConcluidoT = "Jogo Concluido!"

dlgVX:: String
dlgVX = "X VENCEU!"

dlgVO :: String
dlgVO = "O VENCEU!"

dlgVEmpate :: String
dlgVEmpate = "JOGO EMPATADO!"
