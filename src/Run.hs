module Run where

import Data.Text
import Expresso
import Expresso.TH.QQ
import Text.Pretty.Simple


run :: IO ()
run = do
  pPrint =<< do loadConfig "./data/example-1.x"
  putStrLn "ok"


data Config = Config
    { configCachePath   :: Overridable Text
    , configTaskThreads :: Overridable Integer
    , configProfiles    :: [Profile]
    } deriving Show

data Overridable a = Default | Override a deriving Show

data Profile = Profile
    { profileName     :: Text
    , profileLocation :: Text
    , profileInclude  :: [Text]
    , profileExclude  :: [Text]
    , profileSource   :: Text
    , profileNum      :: Integer
    } deriving Show


instance HasValue Config where
    proj v = Config
        <$> v .: "cachePath"
        <*> v .: "taskThreads"
        <*> v .: "profiles"
    inj Config{..} = mkRecord
        [ "cachePath"      .= inj configCachePath
        , "taskThreads"    .= inj configTaskThreads
        , "profiles"       .= inj configProfiles
        ]

instance HasValue a => HasValue (Overridable a) where
    proj = choice [("Override", fmap Override . proj)
                  ,("Default",  const $ pure Default)
                  ]
    inj (Override x) = mkVariant "Override" (inj x)
    inj Default = mkVariant "Default" unit

instance HasValue Profile where
    proj v = Profile
        <$> v .: "name"
        <*> v .: "location"
        <*> v .: "include"
        <*> v .: "exclude"
        <*> v .: "source"
        <*> v .: "num"
    inj Profile{..} = mkRecord
        [ "name"     .= inj profileName
        , "location" .= inj profileLocation
        , "include"  .= inj profileInclude
        , "exclude"  .= inj profileExclude
        , "source"   .= inj profileSource
        , "num"      .= inj profileNum
        ]


schema :: Type
schema =
  [expressoType|
    { cachePath   : <Default : {}, Override : Text>
    , taskThreads : <Default : {}, Override : Int>
    , profiles :
        [ { name     : Text
          , location : Text
          , include  : [Text]
          , exclude  : [Text]
          , source   : Text
          , num      : Int
          }
        ]
    }|]


loadConfig :: FilePath -> IO (Either String Config)
loadConfig = evalFile' envs  (Just schema)
  where
    envs = installBinding "doubleit"  (TFun TInt TInt) (inj doubleit)
         $ initEnvironments

    doubleit = (*2) :: Integer -> Integer
