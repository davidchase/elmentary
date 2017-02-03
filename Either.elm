module Elmentary.Either exposing 
    ( partition
    , either
    , isLeft
    , isRight
    , rights
    , lefts
    , fmap
    , chain
    , ap
    , lift2
    , concat
    , traverse
    , sequence
    , toBoolean
    , eitherToMaybe
    )
 
type Either a b
    = Left a
    | Right b


partition : List (Either c a) -> ( List c, List a )
partition =
    let
        cons either tupleList =
            case either of
                Left a ->
                    Tuple.mapFirst (\xs -> a :: xs) tupleList

                Right b ->
                    Tuple.mapSecond (\xs -> b :: xs) tupleList
    in
        List.foldr cons ( [], [] )


either : (c -> b) -> (a -> b) -> Either c a -> b
either lf rf e =
    case e of
        Right a ->
            rf a

        Left b ->
            lf b


isLeft : Either c a -> Bool
isLeft either =
    case either of
        Left a ->
            True

        Right b ->
            False


isRight : Either c a -> Bool
isRight either =
    case either of
        Right b ->
            True

        Left a ->
            False


rights : List (Either c a) -> List a
rights eitherList =
    let
        getValues either =
            case either of
                Right a ->
                    [ a ]

                Left b ->
                    []
    in
        List.concatMap getValues eitherList


lefts : List (Either c a) -> List c
lefts eitherList =
    let
        getValues either =
            case either of
                Left b ->
                    [ b ]

                Right a ->
                    []
    in
        List.concatMap getValues eitherList


fmap : (a -> b) -> Either c a -> Either c b
fmap f either =
    case either of
        Right a ->
            Right (f a)

        Left b ->
            Left b


chain : (a -> Either c b) -> Either c a -> Either c b
chain f either =
    case either of
        Right a ->
            f a

        Left b ->
            Left b


ap : Either c (a -> b) -> Either c a -> Either c b
ap f g =
    chain (\fn -> fmap fn g) <| f


lift2 : (a -> b -> d) -> Either c a -> Either c b -> Either c d
lift2 f e1 e2 =
    ap (fmap f e1) e2


concat : Either c (List a) -> Either c (List a) -> Either c (List a)
concat m1 m2 =
    lift2 (++) m1 m2


traverse : (a -> Either c b) -> List a -> Either c (List b)
traverse f =
    let
        cons val eitherList =
            case f val of
                Right x ->
                    fmap (\xs -> x :: xs) eitherList

                Left b ->
                    Left b
    in
        List.foldr cons (Right [])


sequence : List (Either c a) -> Either c (List a)
sequence =
    traverse identity


toBoolean : Either c a -> Bool
toBoolean either =
    case either of
        Right a ->
            True

        Left b ->
            False

eitherToMaybe : Either c a -> Maybe a
eitherToMaybe either =
    case either of
        Left a ->
            Nothing

        Right b ->
            Just b
