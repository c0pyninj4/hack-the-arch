# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
hints = ""

setup_hooks = ->
  if !document.getElementById('hint_table') 
    return

  $('#filter').keyup ->
    rex = new RegExp($(this).val(), 'i')
    $('.searchable tr').hide()
    $('.searchable tr').filter(->
      rex.test $(this).text()
    ).show()
    return


  $(".hint_row").click ->
    $.post "/problems/add_hint", {
      "csrf-token": $('meta[name=csrf-token]').attr("content")
      "hint_id": $(this).data("hint-id")
      "problem_id": $(this).data("problem-id")
    }, (result) ->
      $("#new_hint").modal("hide")
      location.reload()
      return
  return

$(document).ready(setup_hooks)
$(document).on('page:load', setup_hooks)
