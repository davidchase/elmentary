module Elmentary.Coyo exposing
  ( liftCoyoneda
  , fmap
  , chain
  , ap
  , lowerCoyoneda
  , lift2
  , traverse
  , sequence
  , show
  )
  
import List exposing (map, concatMap, append, foldr)


type alias Coyoneda f b =
    { f : f, a : List b }


liftCoyoneda : List a -> Coyoneda (a -> a) a
liftCoyoneda =
    Coyoneda identity


lowerCoyoneda : Coyoneda (a -> b) a -> List b
lowerCoyoneda coyo =
    List.map coyo.f coyo.a


fmap : (b -> c) -> Coyoneda (a -> b) d -> Coyoneda (a -> c) d
fmap f coyo =
    Coyoneda (f << coyo.f) coyo.a


show : Coyoneda (a -> a) a -> String
show coyo =
    "liftCoyoneda " ++ (toString coyo.a)


chain : (b -> Coyoneda (c -> d) c) -> Coyoneda (a -> b) a -> Coyoneda (d -> d) d
chain f coyo =
    liftCoyoneda <| concatMap (lowerCoyoneda << f << coyo.f) coyo.a


ap : Coyoneda (a -> b -> c) a -> Coyoneda (a -> b) a -> Coyoneda (c -> c) c
ap f coyo =
    chain (\fn -> fmap fn coyo) <| f


lift2 : (a -> b -> c) -> Coyoneda (a -> a) a -> Coyoneda (a -> b) a -> Coyoneda (c -> c) c
lift2 f m m2 =
    ap (fmap f m) m2


traverse : (a -> Coyoneda (List b -> b) (List b)) -> List a -> Coyoneda (List b -> List b) (List b)
traverse f =
    let
        cons x acc =
            ap (fmap (::) <| f x) acc
    in
        foldr cons (liftCoyoneda [ [] ])


sequence : List (Coyoneda (List a -> a) (List a)) -> Coyoneda (List a -> List a) (List a)
sequence =
    traverse identity
