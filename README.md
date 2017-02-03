![](https://img.shields.io/badge/functional-%CE%BB-blue.svg?style=flat-square)
[![API stability](https://img.shields.io/badge/stability-experimental-orange.svg?style=flat-square)](https://nodejs.org/api/documentation.html#documentation_stability_index)

# elmentary
> Your one-stop shop for Algebraic Data Types (ADT) in elm 

## Types

### Maybe Type  

**reduce** : `(a -> b -> a) -> a -> Maybe b -> a`

**filter** : `(a -> Bool) -> Maybe a -> Maybe a`

**isJust** : `Maybe a -> Bool`

**catMaybes** : `List (Maybe b) -> List b`

**fmap** : `(a -> b) -> Maybe a -> Maybe b`

**chain** : `(a -> Maybe b) -> Maybe a -> Maybe b`

**join** : `Maybe (Maybe a) -> Maybe a`

**ap** : `Maybe (b -> a) -> Maybe b -> Maybe a`

**lift2** : `(b -> c -> a) -> Maybe b -> Maybe c -> Maybe a`

**concat** : `Maybe (List a) -> Maybe (List a) -> Maybe (List a)`

**mapMaybe** : `(a -> Maybe b) -> List a -> List b`

**maybe** : `a -> (b -> a) -> Maybe b -> a`

**empty** : `Maybe a`

**traverse** : `(a -> Maybe b) -> List a -> Maybe (List b)`

**sequence** : `List (Maybe a) -> Maybe (List a)`

### Inspired by

[sanctuary](http://sanctuary.js.org)

[crocks](https://github.com/evilsoft/crocks)
