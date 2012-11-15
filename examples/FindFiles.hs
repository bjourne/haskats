import System.Directory.WalkTree (findFiles)

main = do
  files <- findFiles "." ".hs"
  putStrLn $ unlines files
