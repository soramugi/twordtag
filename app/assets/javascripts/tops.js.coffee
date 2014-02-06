$document = $(document)

$document.on 'click', '#analysis-btn', (e) ->
  $("#preview").html('Now Loading...')
  $.post '/analysis.json',
    text:   $("#textArea").val()
    (data) ->
      html = '<ul class="unstyled">'
      for value in data
        html += '<li>' + value.count + ' ' + value.word + '</li>'
      html += '</ul>'
      $("#preview").html(html)
  return false

