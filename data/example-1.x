let awsTemplate =
    {| location ="s3://s3-eu-west-1.amazonaws.com/tim-backup"
    , include  = []
    , exclude  = []
    , num      = 0 : Int
    |} {}
in
{ cachePath   = Default{}
, taskThreads = Override 2
, profiles =
   [ { name = "pictures"
     , source = "~/Pictures"
     | awsTemplate
     }
   , { name = "music"
     , source = "~/Music"
     , exclude := ["**/*.m4a"]
     , num := doubleit (1+1 : Int)
     | awsTemplate }
   ]
}
