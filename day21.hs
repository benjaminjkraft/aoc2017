import qualified Data.List as List
import qualified Data.Map.Strict as Map

split _ [] = [[]]
split c (x:xs)
    | x == c    = []:split c xs
    | otherwise = let s:ss = split c xs in (x:s):ss

rotate ([]:_) = []
rotate g = rotate (map tail g) ++ [map head g]

rotations = (List.nub
             . concatMap (\g -> [g, map reverse g])
             . take 4
             . iterate rotate)

parseRules :: String -> Map.Map [String] [String]
parseRules = Map.fromList . concatMap parseRule . lines where
    parseRule rule =
        let (pat, ' ':'=':'>':' ':repl) = span (/= ' ') rule
        in  [(a, split '/' repl) | a <- rotations $ split '/' pat]

slice :: [[a]] -> [[[[a]]]]
slice xs
    | length xs `mod` 2 == 0 = slice' 2 xs
    | length xs `mod` 3 == 0 = slice' 3 xs
    | otherwise = error $ "invalid size for slicing " ++ show (length xs)
    where slice' n = map List.transpose . slice'' n . map (slice'' n)
          slice'' n [] = []
          slice'' n xs = let (front, back) = splitAt n xs
                         in  front:slice'' n back

unslice :: [[[[a]]]] -> [[a]]
unslice = map concat . concat . map List.transpose

enhance ruleMap = unslice . map (map (ruleMap Map.!)) . slice

runFractal n rules = 
    let ruleMap = parseRules rules
        startGrid = [".#.", "..#", "###"]
        finalGrid = iterate (enhance ruleMap) startGrid !! n
    in  sum $ map (length . filter (== '#')) finalGrid

main = do
    input <- getContents
    putStrLn $ show $ runFractal 5 input
    putStrLn $ show $ runFractal 18 input
