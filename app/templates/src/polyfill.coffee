module.exports = do ->
  window.requestAnimFrame = do ->
    return  window.requestAnimationFrame       or
            window.webkitRequestAnimationFrame or
            window.mozRequestAnimationFrame    or
            (callback) ->
              window.setTimeout(callback, 1000 / 60)
