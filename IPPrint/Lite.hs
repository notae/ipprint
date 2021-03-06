module IPPrint.Lite (pshow, pshowWidth, pprintWidth) where

import Language.Haskell.Parser
import Language.Haskell.Pretty
import Text.Read

defaultLineWidth :: Int
defaultLineWidth = 80

pshow :: Show a => a -> String
pshow = pshowWidth defaultLineWidth

pshowWidth :: Show a => Int -> a -> String
pshowWidth width v =
    case parseModule ("value = "++s) of
      ParseOk         m -> tidy $ prettyPrintStyleMode (Style PageMode width 1.1) defaultMode m
      ParseFailed _ _   -> s
    where
      s = show v
      tidy x =
          case readPrec_to_S skipBoring 0 x of
            [((), tail')] -> "   " ++ tail'
            _             -> s

pprintWidth :: Show a => Int -> a -> IO ()
pprintWidth width = putStrLn . pshowWidth width

skipBoring :: ReadPrec ()
skipBoring =
    do { Ident "value" <- lexP; Punc  "=" <- lexP; return () } <++
    do { _ <- lexP; skipBoring }
