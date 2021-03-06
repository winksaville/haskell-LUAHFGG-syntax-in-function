import Dbg (db)
import System.IO
import System.Directory
import Data.List

lvl :: Int
lvl = 4

main = do
    handle <- openFile "todo.txt" ReadMode
    (tempName, tempHandle) <- openTempFile "." "temp"
    contents <- hGetContents handle `db` lvl $ "tempName:=" ++ show tempName ++ " tempHandle:=" ++ show tempHandle
    let todoTasks = lines contents
        numberedTasks = zipWith (\n line -> show n ++ " - " ++ line) [0..] todoTasks `db` lvl $ "todoTasks:=" ++ show todoTasks
    putStrLn "These are your TO-DO itemp:"
    putStr $ unlines numberedTasks `db` lvl $ "numberedTasks:=" ++ show numberedTasks
    putStrLn "Which on do you want to delete?"
    numberString <- getLine
    let number = read numberString
        newTodoItems = delete (todoTasks !! number) todoTasks
    hPutStr tempHandle $ unlines newTodoItems
    hClose handle
    hClose tempHandle
    removeFile "todo.txt"
    renameFile tempName "todo.txt"
