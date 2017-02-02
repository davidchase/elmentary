module Elmentary.Maybe exposing
  ( reduce
  , fmap
  , chain
  , ap
  , filter
  , isJust
  , catMaybes
  , join
  , lift2
  , concat
  , mapMaybe
  , maybe,
  , empty
  , sequence
  )

reduce : (a -> b -> a) -> a -> Maybe b -> a
reduce f seed maybe =
    case maybe of
        Just a ->
            f seed a

        Nothing ->
            seed


filter : (a -> Bool) -> Maybe a -> Maybe a
filter f maybe =
    case maybe of
        Just a ->
            if (f a) then
                Just a
            else
                Nothing

        Nothing ->
            Nothing


isJust : Maybe a -> Bool
isJust maybe =
    case maybe of
        Just a ->
            True

        Nothing ->
            False


catMaybes : List (Maybe b) -> List b
catMaybes xs =
    let
        getMaybe just =
            case just of
                Just x ->
                    [ x ]

                Nothing ->
                    []
    in
        List.concatMap getMaybe xs


fmap : (a -> b) -> Maybe a -> Maybe b
fmap f maybe =
    case maybe of
        Just value ->
            Just (f value)

        Nothing ->
            Nothing


chain : (a -> Maybe b) -> Maybe a -> Maybe b
chain f maybe =
    case maybe of
        Just value ->
            f value

        Nothing ->
            Nothing


join : Maybe (Maybe a) -> Maybe a
join =
    chain identity


ap : Maybe (b -> a) -> Maybe b -> Maybe a
ap f g =
    chain (\fn -> fmap fn g) <| f


lift2 : (b -> c -> a) -> Maybe b -> Maybe c -> Maybe a
lift2 f a1 a2 =
    ap (fmap f a1) a2


concat : Maybe (List a) -> Maybe (List a) -> Maybe (List a)
concat m m1 =
    lift2 (++) (m) (m1)


mapMaybe : (a -> Maybe b) -> List a -> List b
mapMaybe f xs =
    catMaybes <| List.map f xs


maybe : a -> (b -> a) -> Maybe b -> a
maybe val f m =
    case m of
        Just v ->
            f v

        Nothing ->
            val

empty : Maybe a
empty =
    Nothing

sequence : List (Maybe a) -> Maybe (List a)
sequence =
    Just << catMaybes
