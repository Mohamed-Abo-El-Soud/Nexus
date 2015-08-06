# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# general function to deploy a tooltip

#console.log "static_pages"
window.deployToast = (type, message)->
  typeClass = switch type
    when "success"
    then "green"
    when "danger"
    then "red"
    when "warning"
    then "yellow"
  textOpen = "<span class=\"alert #{typeClass}-text\">"
  textClose = "#{message}</span>"
  dismissToast = "$(this)[0].parentNode.parentNode.removeChild($(this)[0].parentNode)"
  dismissLink = "<a class=\"btn-flat text-accent\" onClick=\"#{dismissToast}\">Dismiss</a>"
  Materialize.toast "#{textOpen}#{textClose}#{dismissLink}",50000

#window.makeUnread = (item)->
  #console.log item 
  
jQuery.fn.extend
  makeUnread: ()->
    return this.each  ->
      $(this).removeClass "message-unread"
      $(this).addClass "message-read"
      
jQuery.fn.extend makeUnread: ->
  @each ->
    that = this
    id = $(this).attr "id"
    $.ajax
      url: "/make_unread/#{id}"
      type: "GET"
      data:
        id: id
      success: (data) ->
        $(that).removeClass "message-unread"
        $(that).addClass "message-read"
        $(that).children(".collection-item.avatar.modal-trigger").removeClass "bright"
      failure: (data) ->
        console.log "failure!!"
      response: ()->
        console.log "this is a response!"
        
    
      
$(document).ready ()->
  
    $('.modal-trigger').leanModal()
    
    $(".button-collapse").sideNav()
    
    # set when the user starts changing the password, a second input appears asking the user to enter it a second time
    $('#password-input #shown').keypress ()->
      $("#password-input #hidden").removeClass "hide"
      
    # adds the content of the email in the front page to the form in the modal
    $("button[data-target='sign-up']").click ()->
      email = $(this).siblings("input").val()
      input = $ "#sign-up-form #account_email"
      if (/^\s*$/).test input.val()
        if !(/^\s*$/).test email
          input.val(email).siblings("label").addClass "active"
    
    $(".timeago").timeago()
    
    #$("#message-unread").click ->
      #console.log "woah!"
      #makeUnread($(this))
    $(".message-unread").click ->
      #console.log $(this)
      $(this).makeUnread()

