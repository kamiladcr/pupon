{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric  #-}
{-# LANGUAGE QuasiQuotes #-}

module Main where

-- From base:
import Data.Int
import GHC.Generics (Generic)

-- From time package:
import Data.Time

-- From random package:
import System.Random

-- From postgres package:
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.SqlQQ

-- Create postgres credentials to use my
-- local postgres in docker container
connectInfo :: ConnectInfo
connectInfo = defaultConnectInfo {
  connectHost     = "localhost",
  connectDatabase = "postgres",
  connectUser     = "kamila"
}

-- This is local haskell type that represents database record. We're going to
-- generate a list of those and then insert them into database.
data TableEntry = TableEntry {
  datetime :: UTCTime,
  observation :: Int
}
  deriving (Show, Generic, ToRow)

-- We're using this function to insert data into database
-- It currently takes one row but we're going to improve it.
insertRecords :: Connection -> [ TableEntry ] -> IO Int64
insertRecords conn table =
  executeMany conn [sql|
      INSERT INTO test VALUES (?, ?)
    |] table

-- As a first iteration we'll generate artificial records. Entries will be
-- generated with a recursive function. Parameters for generation is time range
-- and upper/lower boundaries for random: [ entry1 entry2 entry3 entry4 ]
generateRecords :: IO [ TableEntry ]
generateRecords =
  let
    generateRecord :: Int -> [ TableEntry ] -> IO [ TableEntry ]
    generateRecord count acc
      | count == 0 =
          return acc
      | otherwise = do
          now <- getCurrentTime
          value <- randomRIO (0, 100)
          let entry = TableEntry now value
          generateRecord (count - 1) (entry:acc)
  in
    generateRecord 1000000 []

main :: IO ()
main = do
  -- Open connection to PostgreSQ
  -- We need do syntax to extract Connection value
  -- from IO wrapper let conn :: IO Connection = connect connectInfo
  conn <- connect connectInfo

  -- Generate records
  table <- generateRecords

  -- Perform insert
  _ <- insertRecords conn table
  putStrLn "Done"
