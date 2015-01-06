fbUrls = 
    "jQuery": [
        "//cdnjs.cloudflare.com/ajax/libs/jquery/1.11.1/jquery.min.js"
        "/common/js/libs/jquery.min.js"
    ]

fbShim = []

fallback.load fbUrls, shim: fbShim

fallback.ready ->
    console.log "Hello"