# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

SERVICE_URL = "http://localhost:8000"

stopLXC = (lxc_id) ->
  url = "#{SERVICE_URL}/lxc/#{lxc_id}/state"
  $.ajax "#{url}",
    type : 'PATCH'
    contentType: 'application/x-www-form-urlencoded'
    dataType: 'html'
    data: 'state=stopped'
    error: (jqXHR, textStatus, errorThrown) ->
      alert(textStatus)
    success: (data, textStatus, jqXHR) ->
      $("#lxc-status-button-"+lxc_id).prop("onclick", null).off("click");
      $("#lxc-status-"+lxc_id).text("stopped")
      $("#lxc-status-button-"+lxc_id).removeClass("btn-danger stopLXC").addClass("btn-primary startLXC")
      $("#lxc-status-button-"+lxc_id).children("i").removeClass("fa-stop").addClass("fa-play")
      $("#lxc-status-button-"+lxc_id).on "click", ->
        startLXC(lxc_id)
  
startLXC = (lxc_id) ->
  url = "#{SERVICE_URL}/lxc/#{lxc_id}/state"
  $.ajax "#{url}",
    type : 'PATCH'
    contentType: 'application/x-www-form-urlencoded'
    dataType: 'html'
    data: 'state=started'
    error: (jqXHR, textStatus, errorThrown) ->
      alert(textStatus)
    success: (data, textStatus, jqXHR) ->
      $("#lxc-status-button-"+lxc_id).prop("onclick", null).off("click");
      $("#lxc-status-"+lxc_id).text("started")
      $("#lxc-status-button-"+lxc_id).removeClass("btn-primary startLXC").addClass("btn-danger stopLXC")
      $("#lxc-status-button-"+lxc_id).children("i").removeClass("fa-play").addClass("fa-stop")
      $("#lxc-status-button-"+lxc_id).on "click", ->
        stopLXC(lxc_id)

deleteLXC = (lxc_id) ->
  url = "#{SERVICE_URL}/lxc/#{lxc_id}/state"
  $.ajax "#{url}",
    type : 'PATCH'
    contentType: 'application/x-www-form-urlencoded'
    dataType: 'html'
    data: 'state=deleted'
    error: (jqXHR, textStatus, errorThrown) ->
      alert(textStatus)
    success: (data, textStatus, jqXHR) ->
      window.location.reload()

pageReady = ->
  $(".stopLXC").on "click", ->
    lxc_id = $(this).data().id
    stopLXC(lxc_id)
  $(".startLXC").on "click", ->
    lxc_id = $(this).data().id
    startLXC(lxc_id)
  $(".deleteLXC").on "click", ->
    lxc_id = $(this).data().id
    deleteLXC(lxc_id)

$(document).ready(pageReady)
$(document).on('page:load', pageReady)
$(document).on('turbolinks:load', pageReady)
