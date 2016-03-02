import Crypto exposing ( DigestAlgorithm(..), digestString )
import Graphics.Input.Field exposing ( field, defaultStyle, noContent, Content )
import Graphics.Element exposing ( show, flow, right )
import Signal exposing ( Signal )
import Task exposing ( Task )
import ArrayBuffer exposing ( decode, Encoding(Hex) )

plaintext : Signal.Mailbox Content
plaintext = Signal.mailbox noContent

port hasher : Signal (Task Crypto.Error ())
port hasher =
    Signal.map 
        (\content -> digestString Sha1 content.string
            `Task.andThen` \digest -> Task.fromMaybe Crypto.UnknownCryptoError (decode Hex digest)
            `Task.andThen` (Signal.send hash.address))
        plaintext.signal

hash = Signal.mailbox ""

plaintextField =
    Signal.map (field defaultStyle (Signal.message plaintext.address) "") plaintext.signal

main =
    Signal.map2 (\field -> \hash -> flow right [ field , show hash ]) plaintextField hash.signal
