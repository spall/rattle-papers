{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralisedNewtypeDeriving #-}

import GHC.Generics
import Test.QuickCheck
import Data.Hashable
import Data.List
import qualified Data.Map as Map
import qualified Data.Set as Set

newtype Name = Name Int
    deriving (Arbitrary, Hashable, Show)

data RW a = RW {r :: Set.Set a, w :: Set.Set a}
    deriving (Generic, Show)

instance (Ord a, Arbitrary a) => Arbitrary (RW a) where
    arbitrary = do
        r <- arbitrary
        w <- arbitrary
        return $ RW (r `Set.difference` w) w

newtype Store k v = Store (Map.Map k v)
    deriving Eq

instance (Show k, Show v) => Show (Store k v) where
    show (Store mp)
        | null xs = "[] |-> []"
        | otherwise = "[" ++ show (fst $ head xs) ++ ".." ++ show (fst $ last xs) ++ "] |-> " ++ show (map snd xs)
        where xs = Map.toAscList mp

instance (Bounded k, Enum k, Ord k, Arbitrary v) => Arbitrary (Store k v) where
    arbitrary = do
        let ks = [minBound .. maxBound]
        vs <- vector $ length ks
        return $ Store $ Map.fromList $ zip ks vs

storeUpdate :: Ord k => Store k v -> [(k, v)] -> Store k v
storeUpdate (Store mp) xs = Store $ Map.fromList xs `Map.union` mp

storeGet :: Ord k => Store k v -> k -> v
storeGet (Store mp) k = mp Map.! k

apply :: (Hashable a, Ord a) => Name -> RW a -> Store a Int -> Store a Int
apply name RW{..} mp = storeUpdate mp [(v, hash (v, input)) | v <- Set.toAscList w]
    where input = hash (name, [(v, storeGet mp v) | v <- Set.toAscList r])

applys :: (Hashable a, Ord a) => [(Name, RW a)] -> Store a Int -> Store a Int
applys cmds mp = foldl' (\mp (name, rw) -> apply name rw mp) mp cmds

data Hazard a = ReadWrite a | WriteWrite a

hazard :: Ord a => [RW a] -> Maybe (Hazard a)
hazard = f Set.empty Set.empty
    where
        f _ _ [] = Nothing
        f reads writes (RW{..}:rws)
            | bad:_ <- Set.toList $ Set.intersection writes w = Just $ WriteWrite bad
            | bad:_ <- Set.toList $ Set.intersection reads w = Just $ ReadWrite bad
            | otherwise = f (Set.union r reads) (Set.union w writes) rws


newtype File = File Int
    deriving (Hashable, Eq, Ord, Enum, Show)

instance Bounded File where
    minBound = File 0
    maxBound = File 9

instance Arbitrary File where
    arbitrary = arbitraryBoundedEnum

-- Prove that if the reads/writes are ordered, then a no-rebuild does nothing observable
quiesence :: Store File Int -> [(Name, RW File)] -> Property
quiesence first cmds = case hazard (map snd cmds) of
        Just ReadWrite{} -> label "ReadWrite" True
        Just WriteWrite{} -> label "WriteWrite" True
        Nothing -> label "valid" $ second === third
    where
        second = applys cmds first
        third = applys cmds second

-- Prove that if you don't cause a hazard, any ordering will do
reordering :: Store File Int -> [(Int, (Name, RW File))] -> Property
reordering store cmds1
    | length cmds1 == 1 = label "Single command" True
    | Just _ <- hazard $ map (snd . snd) cmds1 = label "Hazardous initially" True
    | Just _ <- hazard $ map (snd . snd) cmds2 = label "Hazardous reordered" True
    | otherwise = label "valid" $ applys (map snd cmds1) store === applys (map snd cmds2) store
    where
        cmds2 = sortOn fst cmds1

main :: IO ()
main = do
    quickCheck $ withMaxSuccess 10000 quiesence
    quickCheck $ withMaxSuccess 10000 reordering
