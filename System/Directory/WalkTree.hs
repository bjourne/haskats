------------------------------------------------------------------------------
-- |
-- Module: System.Directory.WalkTree
-- Copyright: (c) Björn Lindqvist
--
-- Simple module to list files in a directory tree. It only does what
-- I need it to.
--
------------------------------------------------------------------------------
module System.Directory.WalkTree where

import Control.Monad (forM)
import System.Directory (doesDirectoryExist, getDirectoryContents)
import System.FilePath ((</>), takeExtension)

findFilesMatching :: String -> (String -> Bool) -> IO [String]
findFilesMatching dir predF = do
  names <- getDirectoryContents dir
  let properNames = filter (`notElem` [".", ".."]) names
  paths <- forM properNames $ \name -> do
    let path = dir </> name
    isDirectory <- doesDirectoryExist path
    if isDirectory
      then findFilesMatching path predF
      else return (if predF path then [path] else [])
  return (concat paths)

findFiles :: String -> String -> IO [String]
findFiles dir ext = findFilesMatching dir (\x -> takeExtension x == ext)
