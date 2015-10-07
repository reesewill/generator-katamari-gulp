do ->

  # headerScrollTop = 0
  #
  # stickyHeader = () ->
  #   newScrollTop = $(window).scrollTop()
  #
  #   isGoingDown = newScrollTop > header.offset + header.animD && headerScrollTop <= header.offset + header.animD
  #   isGoingUp = newScrollTop <= header.offset + header.animD && headerScrollTop > header.offset + header.animD
  #   if isGoingDown
  #     $page.addClass("stuck").css("margin-top", header.height + "px")
  #     headerScrollTop = newScrollTop
  #   else if isGoingUp
  #     $page.removeClass("stuck").css("margin-top","")
  #     headerScrollTop = newScrollTop
  #
  # scrollLoop = ->
  #   requestAnimFrame(scrollLoop)
  #   stickyHeader()
  #
  # easeInOutQuad = (t, b, c, d) ->
  #
  #   t /= (d/2)
  #   return c/2*t*t + b if (t < 1)
  #
  #   t--
  #   return -c/2 * (t*(t-2) - 1) + b
  #
  # smoothScroll = () ->
  #   selector = $(this).data("target")
  #   scrollTop = $(window).scrollTop()
  #   scrollTarget = $(selector).offset().top - header.height
  #   time = 0
  #   timer = setInterval ( ->
  #     t = easeInOutQuad(time, scrollTop, scrollTarget - scrollTop, 400)
  #     if Math.abs(scrollTarget - t) <= 1 || time >= 400
  #         $(window).scrollTop scrollTarget
  #         clearTimeout timer
  #     else
  #         $(window).scrollTop t
  #         time+= 17
  #   ), 17
  #
  #   return false
  #
  # scrollLoop()
  #
  # $(".js-anchor-link").on "tap", smoothScroll
