Elm.Native.Crypto = {}
Elm.Native.Crypto.make = function(localRuntime) {

    localRuntime.Native = localRuntime.Native || {}
    localRuntime.Native.Crypto = localRuntime.Native.Crypto || {}
    if (localRuntime.Native.Crypto.values) {
        return localRuntime.Native.Crypto.values
    }

    var Task = Elm.Native.Task.make(localRuntime)
    var Maybe = Elm.Maybe.make(localRuntime)
    var NativeList = Elm.Native.List.make(localRuntime)

    var digestAlgorithmCtor = {
        'Sha1': 'SHA-1',
        'Sha256': 'SHA-256',
        'Sha384': 'SHA-384',
        'Sha512': 'SHA-512',
    }

    return localRuntime.Native.Crypto.values = {
        digest: F2(digest),
        randomData: randomData,
        encrypt: F3(encrypt),
        decrypt: F3(decrypt),
        generateKey: F3(generateKey),
        importKey: F5(generateKey),
        exportKey: F2(generateKey),
    }

    function digest(algoType, buf) {
        return Task.asyncFunction(function (callback) {
            crypto.subtle.digest(digestAlgorithmCtor[algoType.ctor], buf)
                .then(function (hash) {
                    callback(Task.succeed(hash))
                }, function () {
                    callback(Task.fail({ ctor: 'UnknownCryptoError' }))
                })
        })
    }

    function randomData(size) {
        var buf = new Uint8Array(size)
        try {
            crypto.getRandomValues(buf)
            return Maybe.Just(buf)
        } catch (e) {
            return Maybe.Nothing
        }
    }

    function encrypt(options, key, data) {
        return wrapPromise(function () {
            return crypto.subtle.encrypt(options, key, data)
        })
    }

    function decrypt(options, key, data) {
        return wrapPromise(function () {
            return crypto.subtle.decrypt(options, key, data)
        })
    }

    function generateKey(options, extractable, actions) {
        return wrapPromise(function () {
            return crypto.subtle.generateKey(options, extractable,
                NativeList.toArray(actions))
        })
    }

    function importKey(format, options, extractable, actions, data) {
        return wrapPromise(function () {
            return crypto.subtle.importKey(format, data, options, extractable,
                NativeList.toArray(actions))
        })
    }

    function exportKey(format, key) {
        return wrapPromise(function () {
            return crypto.subtle.exportKey(format, key)
        })
    }

    function wrapPromise(prepare) {
        return Task.asyncFunction(function (callback) {
            prepare()
                .then(function (result) {
                    callback(Task.succeed(result))
                }, function () {
                    callback(Task.fail({ ctor: 'UnknownCryptoError'}))
                })
        })
    }
}
