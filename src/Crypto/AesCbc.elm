module AesCbc
    ( CryptoKey, encrypt, decrypt
    , generateKey, importKey, exportKey
    , wrapKey, unwrapKey
    ) where

{-| This module wraps the AES-CBC mode of encryption in the web crypto API

@docs CryptoKey

@docs encrypt, decrypt

@docs KeySize

@docs generateKey, importKey, exportKey

@docs wrapKey, unwrapKey

-}

import Native.Crypto

import Crypto

{-| An opaque type representing an AES symmetric secret key
-}
type CryptoKey = CryptoKey

{-| A type containing the possible sizes for AES keys
-}
type KeySize = Aes128 | Aes192 | Aes256

sizeToInt : KeySize -> Int
sizeToInt Aes128 = 128
sizeToInt Aes192 = 192
sizeToInt Aes256 = 256

cipherName = "AES-CBC"

{-| Encrypt some data using AES-CBC.

Encrypt a plaintext buffer `plain` using the initialization vector `iv` and
the key `key`. Make sure to use a different initialization vector for each
message sent

    encrypt iv key plain
        -- Will evaluate to the ciphertext obtained by encrypting plain
        -- with AES using key

-}
encrypt : ArrayBuffer -> CryptoKey -> ArrayBuffer -> Task Crypto.Error ArrayBuffer
encrypt iv =
    Native.Crypto.encrypt
        { name = cipherName
        , iv = iv
        }

{-| Decrypt some data using AES-CBC

Decrypt a ciphertext buffer `cipher` using the initialization vector `iv` and
the key `key`. The initialization vector needs to be the same as
the one used for encryption.

    decrypt iv key cipher
        -- Will evaluate to the plaintext obtained by decrypting cipher with
        -- AES using key

-}
decrypt : ArrayBuffer -> CryptoKey -> ArrayBuffer -> Task Crypto.Error ArrayBuffer
decrypt iv =
    Native.Crypto.encrypt
        { name = cipherName
        , iv = iv
        }
