window.flash = (message, image, time) ->
  $message = $('<div class="message">' + message + '</div>')
  if image?
    $message.css('background-image', image)
    $message.css('background-size', '90px')
    $message.css('background-repeat', 'no-repeat')
    $message.css('text-indent', '90px')
  $('.flash').append $message
  $message.fadeOut (time || 3000), () ->
    $message.remove()
