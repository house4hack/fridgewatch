module Main where

import Network
import Control.Concurrent
import System.IO
import System.Serial

main = withSocketsDo $ do
    sock <- listenOn $ PortNumber 5002
    loop sock

loop sock = do
   (h,_,_) <- accept sock
   forkIO $ body h
   loop sock
  where
   body h = do
       serial <- openSerial "/dev/ttyACM0" B9600 8 One Even Software
       out <- hGetLine serial
       hPutStr h (msg out)
       hFlush h
       hClose serial
       hClose h

msg :: String -> String
msg content =
  concat [ "HTTP/1.0 200 OK\r\nContent-Length: "
         , show (length content)
         , "\r\n\r\n"
         , content
         , "\r\n"]
