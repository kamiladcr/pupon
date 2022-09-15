{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

import System.Random
import Data.Time
import Data.Int
import GHC.Generics (Generic)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ

connectInfo :: ConnectInfo
connectInfo = defaultConnectInfo {
  connectHost     = "localhost",
  connectDatabase = "postgres",
  connectUser     = "kamila"
}

data Test = Test {
  datetime :: UTCTime,
  observation :: Int
}
  deriving (Show, Generic, ToRow)

insertRecord :: Connection -> Test -> IO Int64
insertRecord conn row =
  execute conn [sql|
      INSERT INTO test (datetime, observation) VALUES (?, ?)
    |] (datetime row, observation row)

main :: IO ()
main = do
  conn <- connect connectInfo
  now <- getCurrentTime
  value <- randomRIO (0, 100)
  let testRecord = Test now value
  _ <- insertRecord conn testRecord
  putStrLn "Done"
