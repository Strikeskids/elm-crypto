Elm.Native.Crypto = {}
Elm.Native.Crypto.make = function(localRuntime) {

    localRuntime.Native = localRuntime.Native || {}
    localRuntime.Native.Crypto = localRuntime.Native.Crypto || {}
    if (localRuntime.Native.Crypto.values) {
        return localRuntime.Native.Crypto.values
    }

    var Task = Elm.Native.Task.make(localRuntime)
    var Maybe = Elm.Maybe.make(localRuntime)

    var digestAlgorithmCtor = {
        'Sha1': 'SHA-1',
        'Sha256': 'SHA-256',
        'Sha384': 'SHA-384',
        'Sha512': 'SHA-512',
    }

    return localRuntime.Native.Crypto.values = {
        digest: F2(digest),
        randomData: randomData,
    }

    function digest(algoType, buf) {
        return Task.asyncFunction(function (callback) {
            crypto.subtle.digest(digestAlgorithmCtor[algoType.ctor], buf)
                .then(function(hash) {
                    callback(Task.succeed(hash))
                }, function() {
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
}
