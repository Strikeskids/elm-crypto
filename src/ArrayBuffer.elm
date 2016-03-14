module ArrayBuffer
    ( ArrayBuffer
    , Encoding(..), encode, decode
    , length
    ) where
{-| This library intends to give access to the binary ArrayBuffer JS
interface.

@docs ArrayBuffer, Encoding

@docs encode, decode, length
-}

import Native.ArrayBuffer

{-| Represent raw buffer values. Equivalent to `ArrayBuffer` in JS
-}
type ArrayBuffer = ArrayBuffer

{-| The different encodings for converting between `String` and `ArrayBuffer`
-}
type Encoding
    = Utf8
    | Hex
    | Utf16Be
    | Utf16Le

{-| Encode a `String` into an `ArrayBuffer`. If the encoding fails, then 
`Nothing` is returned. Otherwise, `Just ArrayBuffer` corresponding to the
encoded string.

    encode Utf8 "Hello World" -- ArrayBuffer representing "Hello World"

    encode Hex "Hello" -- Nothing

-}
encode : Encoding -> String -> Maybe ArrayBuffer
encode =
    Native.ArrayBuffer.encode

{-| Decode an `ArrayBuffer` into a `String`. If the decoding fails, then
`Nothing` is returned. Otherwise, `Just String` corresponding to the decoded
`ArrayBuffer`.

    decode Hex (encode Utf8 "Hello") -- Just "48656c6c6f"

    decode Utf8 (encode Hex "48656b6b6f") -- Just "Hello"

-}
decode : Encoding -> ArrayBuffer -> Maybe String
decode =
    Native.ArrayBuffer.decode

{-| Find the length of an `ArrayBuffer`
    
    length (decode Utf8 "Hello") -- 6

-}
length : ArrayBuffer -> Int
length = 
    Native.ArrayBuffer.length

{-| Turn an `ArrayBuffer` into an `Int List` of the individual bytes in the
buffer

    Maybe.map toList (decode Utf8 "abcd")
        -- results in [97, 98, 99, 100]

-}
toList : ArrayBuffer -> Int List
toList = 
    Native.ArrayBuffer.toList

{-| Turn an `Int List` of bytes (0-255) into an `ArrayBuffer`

    Maybe.andThen (fromList [97, 98, 99, 100]) (decode Utf8)
        -- results in Just "abcd"

    fromList [500, 300, 300]
        -- results in Nothing (out of bounds)
    
-}
fromList : Int List -> Maybe ArrayBuffer
fromList =
    Native.ArrayBuffer.fromList

{-| An impure function that clears an ArrayBuffer. This should be used if the
ArrayBuffer in question contains sensitive data

    zero buf -- Returns ()
        -- Modify buf in place, storing zeroes into every byte

-}
zero : ArrayBuffer -> ()
zero = 
    Native.ArrayBuffer.zero
