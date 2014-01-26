$document = $(document)

$document.on 'click', '#tags-get', (e) ->
  location.href = '/tags/' + $("#tags-param").val()

$document.on 'keypress', '#tags-param', (e) ->
  if (e.which == 13)
    location.href = '/tags/' + $("#tags-param").val()
