module Crypto
    ( digest, digestString
    , DigestAlgorithm(..)
    , Error(..)
    ) where

{-| This module provides an elm wrapper around the SubtleCrypto web API

@docs DigestAlgorithm, digest, digestString

@docs Error

-}

import Native.Crypto

import ArrayBuffer exposing ( ArrayBuffer, encode )
import Task exposing ( Task )
import Maybe exposing ( Maybe(..) )

{-| Describes available types of hash digests to compute
-}
type DigestAlgorithm
    = Sha1
    | Sha256
    | Sha384
    | Sha512

{-| Compute a hash digest of an `ArrayBuffer`

    (Task.fromMaybe UnknownCryptoError (encode Utf8 "Hello"))
        `Task.andThen` (digest Sha1)
        -- results in bytes: f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0

-}
digest : DigestAlgorithm -> ArrayBuffer -> Task Error ArrayBuffer
digest =
    Native.Crypto.digest

{-| Compute the hash digest of a UTF-8 encoded `String`

    digestString sha1 "Hello"
        -- results in bytes: f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0

-}
digestString : DigestAlgorithm -> String -> Task Error ArrayBuffer
digestString algo s =
    let
        encoder = encode ArrayBuffer.Utf8 s
            |> Task.fromMaybe UnknownCryptoError
        digester = digest algo
    in
        encoder `Task.andThen` digester

{-| Generate cryptographically secure random data (for crypto functions).
Could fail if too much randomness is requested (according to Web Crypto spec)

    randomData 16
        -- results in `Just buf` containing 16 cryptographically-random bytes

-}
randomData : Int -> Maybe ArrayBuffer
randomData =
    Native.Crypto.randomData

{-| The different possible failures for crypto promises
-}
type Error
    = UnknownCryptoError
