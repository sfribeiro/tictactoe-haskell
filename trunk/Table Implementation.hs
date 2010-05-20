--Implementar Table em Haskell
module MyTable (Table, newTable, findTable, upTable, remTable) where

newTable :: Table t b
findTable :: (Ord t) => t -> Table t b -> Maybe b
upTable :: (Ord t) => (t,b) -> Table t b -> Table t b
remTable :: (Ord t) => t -> Table t b -> Table t b

data Table t b = Tab [(t,b)]

newTable = Tab []

findTable _ (Tab []) = Nothing
findTable x (Tab ((t,b):as))
				| x < t = Nothing
				| x == t = Just b
				| x > t = findTable x (Tab as)
				
upTable (x,y) (Tab []) = Tab[(x,y)]
upTable (x,y) (Tab ((t,b):as))
				| x < t = Tab ((x,y):(t,b):as)
				| x == t = Tab ((t,y):as)
				| x > t = let (Tab a) = upTable (x,y) (Tab as)
						  in (Tab ((t,b):a))
						  
remTable _ (Tab[]) = Tab[]
remTable x (Tab ((t,b):as))
				| x < t = Tab ((t,b):as) 
				| x == t = Tab as
				| x > t = let (Tab a) = remTable x (Tab as)
						  in Tab ((t,b):a)
						  
instance (Show t, Show b) => Show (Table t b) where
	show (Tab []) = "."
	show (Tab ((t,b):as)) = (show t) ++ "\t" ++ (show b) ++ "\n" ++ (show (Tab as))
	
type Numero = Integer
type Nome = String
type Nota = Integer

pauta :: [(Numero, Nome, Nota)] -> Table Numero (Nome, Nota)
pauta [] = newTable
pauta ((x,y,z):as) = upTable (x,(y,z)) (pauta as)