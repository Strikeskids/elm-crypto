Elm.Native.ArrayBuffer = {}
Elm.Native.ArrayBuffer.make = function(localRuntime) {

    localRuntime.Native = localRuntime.Native || {}
    localRuntime.Native.ArrayBuffer = localRuntime.Native.ArrayBuffer || {}
    if (localRuntime.Native.ArrayBuffer.values) {
        return localRuntime.Native.ArrayBuffer.values
    }

    var Maybe = Elm.Maybe.make(localRuntime)
    var NativeList = Elm.Native.List.make(localRuntime)
    var List = Elm.List.make(localRuntime)

    var utfLabelMapping = {
        'Utf16Be': 'utf-16be',
        'Utf16Le': 'utf-16le',
        'Utf8': 'utf-8',
    }

    return localRuntime.Native.ArrayBuffer.values = {
        encode: F2(encode),
        decode: F2(decode),
        length: length,
    }

    function encode(encoding, s) {
        encoding = encoding.ctor

        if (encoding === 'Hex') {
            var encoded = encodeHex(s)
            return encoded
                ? Maybe.Just(encoded)
                : Maybe.Nothing
        } else if (utfLabelMapping[encoding]) {
            var encoder = new TextEncoder(utfLabelMapping[encoding])
            return Maybe.Just(encoder.encode(s).buffer)
        } else {
            throw RangeError("Invalid encoding")
        }
    }

    function encodeHex(s) {
        if (s.length % 2) return

        var buf = new ArrayBuffer(s >> 1)
        var view = new DataView(buf)
        var i = 0

        for (i=0; i<view.byteLength-3; i+=4) {
            var value = parseInt(s.substring(2*i, 2*i+8), 16)
            if (isNaN(value)) return
            view.setUint32(value, false)
        }

        for (; i<view.byteLength; i+=4) {
            var value = parseInt(s.substring(2*i, 2*i+2), 16)
            if (isNaN(value)) return
            view.setUint8(value)
        }

        return buf
    }

    function decode(encoding, buf) {
        encoding = encoding.ctor

        if (encoding === 'Hex') {
            return Maybe.Just(decodeHex(buf))
        } else if (utfLabelMapping[encoding]) {
            try {
                var decoder = new TextDecoder(utfLabelMapping[encoding])
                return Maybe.Just(decoder.decode(buf))
            } catch (e) {
                return Maybe.Nothing
            }
        } else {
            throw RangeError("Invalid encoding")
        }
    }

    function decodeHex(buf) {
        var hexCodes = []
        var view = new DataView(buf)
        var i = 0
        for (i=0; i<view.byteLength-3; i+=4) {
            var value = view.getUint32(i, false)
            hexCodes.push(('00000000' + value.toString(16)).slice(-8))
        }
        for (; i<view.byteLength; ++i) {
            var value = view.getUint8(i)
            hexCodes.push(('00' + value.toString(16)).slice(-2))
        }

        return hexCodes.join('')
    }

    function length(buf) {
        return buf.byteLength
    }

    function toList(buf) {
        return NativeList.fromArray(new Uint8Array(buf))
    }

    function fromList(xs) {
        var length = List.length(xs)
        var arr = new Uint8Array(length)
        for (var i=0; i<length; ++i, xs = xs._1) {
            if (0 <= xs._0 <= 255) {
                arr[i] = xs._0;
            } else {
                return Maybe.Nothing
            }
        }
        return Maybe.Just(arr.buffer)
    }
}
