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
menuOpcoes = "&Op\231\245es"

menuAvisar :: String
menuAvisar = "Avisar jogada inv\225lida"
ajudaAvisar :: String
ajudaAvisar = "Exibi\231\227o de uma mensagem quando a jogada for inv\225lida"

menuSkins :: String
menuSkins = "Selecionar skin"

menuSkin1 :: String
menuSkin1 = "1. Padr\227o"

menuSkin2 :: String
menuSkin2 = "2. La Vermelha"

menuSkin3 :: String
menuSkin3 = "3. PacMan"

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
    "O tabuleiro \233 uma matriz  de tr\234s linhas por tr\234s colunas.\n" ++
    "Dois jogadores escolhem uma marca\231\227o cada um, geralmente um c\237rculo (O) e um xis (X).\n" ++
    "Os jogadores jogam alternadamente, uma marca\231\227o por vez, numa lacuna que esteja vazia.\n" ++
    "O objetivo \233 conseguir tr\234s c\237rculos ou tr\234s xis em linha, quer horizontal, vertical ou diagonal,"++ 
	"e ao mesmo tempo, quando poss\237vel, impedir o advers\225rio de ganhar na proxima jogada.\n" ++
    "Quando um jogador conquista o objetivo, costuma-se riscar os tr\234s s\237mbolos."



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
dlgInvalidaT = "Jogada Inv\225lida!"

dlgInvalida :: String
dlgInvalida = "Voc\234 deve jogar em outro lugar!"

dlgNovoJogoT :: String
dlgNovoJogoT = "Novo Jogo?"

dlgNovoJogo :: String
dlgNovoJogo = "Deseja iniciar um novo jogo?"

dlgFecharT :: String
dlgFecharT = "Encerrar Partida?"

dlgFechar :: String
dlgFechar = "Deseja encerrar a partida atual?"

dlgConcluidoT :: String
dlgConcluidoT = "Jogo Conclu\237do!"

dlgVX:: String
dlgVX = "X VENCEU!"

dlgVO :: String
dlgVO = "O VENCEU!"

dlgVEmpate :: String
dlgVEmpate = "JOGO EMPATADO!"
