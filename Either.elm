module Elmentary.Either exposing 
    ( ap
    , bimap
    , chain
    , concat
    , either
    , eitherToMaybe
    , fmap
    , getOrElse
    , isLeft
    , isRight
    , lefts
    , lift2
    , maybeToEither
    , merge
    , orElse
    , partition
    , rights
    , sequence
    , swap
    , toBoolean
    , traverse
    )
 
type Either a b
    = Left a
    | Right b


getOrElse : a -> Either a a -> a
getOrElse val either =
    case either of
        Left a ->
            val

        Right b ->
            b


orElse : (a -> a) -> Either a a -> a
orElse f either =
    case either of
        Left a ->
            f a

        Right b ->
            b


merge : Either a a -> a
merge either =
    case either of
        Left a ->
            a

        Right b ->
            b


swap : Either a b -> Either b a
swap either =
    case either of
        Left a ->
            Right a

        Right b ->
            Left b


eitherToMaybe : Either a b -> Maybe b
eitherToMaybe either =
    case either of
        Left a ->
            Nothing

        Right b ->
            Just b


maybeToEither : a -> Maybe b -> Either a b
maybeToEither val maybe =
    case maybe of
        Just a ->
            Right a

        Nothing ->
            Left val


partition : List (Either a b) -> ( List a, List b )
partition =
    let
        extract either tupleList =
            case either of
                Left a ->
                    Tuple.mapFirst (\xs -> a :: xs) tupleList

                Right b ->
                    Tuple.mapSecond (\xs -> b :: xs) tupleList
    in
        List.foldr extract ( [], [] )


either : (a -> c) -> (b -> c) -> Either a b -> c
either lf rf e =
    case e of
        Left a ->
            lf a

        Right b ->
            rf b


bimap : (a -> c) -> (b -> d) -> Either a b -> Either c d
bimap lf rf e =
    case e of
        Left a ->
            Left (lf a)

        Right b ->
            Right (rf b)


isLeft : Either a b -> Bool
isLeft either =
    case either of
        Left a ->
            True

        Right b ->
            False


isRight : Either a b -> Bool
isRight either =
    case either of
        Left a ->
            False

        Right b ->
            True


rights : List (Either a b) -> List b
rights eitherList =
    let
        getValues either =
            case either of
                Left b ->
                    []

                Right a ->
                    [ a ]
    in
        List.concatMap getValues eitherList


lefts : List (Either a b) -> List a
lefts eitherList =
    let
        getValues either =
            case either of
                Left a ->
                    [ a ]

                Right b ->
                    []
    in
        List.concatMap getValues eitherList


fmap : (b -> c) -> Either a b -> Either a c
fmap f either =
    case either of
        Left a ->
            Left a

        Right b ->
            Right (f b)


leftMap : (a -> c) -> Either a b -> Either c b
leftMap f either =
    case either of
        Left a ->
            Left (f a)

        Right b ->
            Right b


chain : (b -> Either a d) -> Either a b -> Either a d
chain f either =
    case either of
        Left a ->
            Left a

        Right b ->
            f b


ap : Either a (b -> c) -> Either a b -> Either a c
ap f g =
    chain (\fn -> fmap fn g) <| f


lift2 : (b -> c -> d) -> Either a b -> Either a c -> Either a d
lift2 f e1 e2 =
    ap (fmap f e1) e2


concat : Either a (List b) -> Either a (List b) -> Either a (List b)
concat m1 m2 =
    lift2 (++) m1 m2


traverse : (c -> Either a b) -> List c -> Either a (List b)
traverse f =
    let
        cons val eitherList =
            case f val of
                Left a ->
                    Left a

                Right b ->
                    fmap (\xs -> b :: xs) eitherList
    in
        List.foldr cons (Right [])


sequence : List (Either a b) -> Either a (List b)
sequence =
    traverse identity


toBoolean : Either a b -> Bool
toBoolean either =
    case either of
        Left a ->
            False

        Right b ->
            True
