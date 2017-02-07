module Elmentary.Coyo exposing
  ( liftCoyo
  , fmap
  , chain
  , apply
  , pure
  , empty
  , concat
  , lowerCoyo
  )

import List exposing (map, concatMap, append)


type alias Coyo f a =
    { f : f, a : a }


liftCoyo : b -> Coyo (a -> a) b
liftCoyo =
    Coyo identity


lowerCoyo : Coyo (a -> b) (List a) -> List b
lowerCoyo coyo =
    List.map coyo.f coyo.a


chain : (d -> Coyo (a -> c) (List a)) -> Coyo (b -> d) (List b) -> Coyo (a -> a) (List c)
chain f coyo =
    liftCoyo <| List.concatMap (lowerCoyo << f << coyo.f) coyo.a


fmap : (b -> c) -> Coyo (a -> b) d -> Coyo (a -> c) d
fmap f coyo =
    Coyo (f << coyo.f) coyo.a


ap : List (a -> b) -> List a -> List b
ap f g =
    concatMap (\fn -> map fn <| g) <| f


apply : Coyo (a -> b -> c) (List a) -> Coyo (b -> b) (List b) -> Coyo (a -> a) (List c)
apply m n =
    liftCoyo <| ap (lowerCoyo m) (lowerCoyo n)


concat : Coyo (a -> c) (List a) -> Coyo (b -> c) (List b) -> Coyo (a -> a) (List c)
concat u v =
    liftCoyo <| append (lowerCoyo u) <| lowerCoyo v


toList : a -> List a
toList fn =
    fn :: []


empty : Coyo (a -> a) (List b)
empty =
    liftCoyo []


pure : b -> Coyo (a -> a) (List b)
pure =
    liftCoyo << toList
