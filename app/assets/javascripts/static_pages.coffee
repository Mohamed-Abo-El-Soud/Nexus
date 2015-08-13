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


jQuery.fn.extend makeUnread: ->
  @each ->
    that = this
    #id = $(this).attr "id"
    id = $(this).parents(".card-wrapper").attr "id"
    $.ajax
      url: "/make_unread/#{id}"
      type: "GET"
      data:
        id: id
      success: (data) ->
        $(that).removeClass "message-unread"
        $(that).addClass "message-read"
        #$(that).children(".collection-item.avatar.modal-trigger").removeClass "bright"
        $(that).removeClass "bright"
        #$(that).find(".badge-new").remove()
        $(that).siblings(".badge.secondary-content").find(".badge-new").remove()
        
jQuery.fn.extend sendTo:(item)->
  @each ->
    that = this
    parent = $(this).parents ".card-wrapper" #.parents(".modal.modal-fixed-footer")
    idNumber = parent.attr("id")
    #parentId = idNumber = null
    #if (parent.length)
      #idNumber = parent.attr("id")
      #parentId = parent.attr("id")
      #idNumber = parentId.substring parentId.length - 1
    category = $(this).attr("data-category")
    message = $(this).attr("data-message")
    $.ajax
      url: "/move_category/#{idNumber}"
      type: "GET"
      data:
        id: idNumber
        category: category
      success: (data) ->
        #console.log "the data has been changed?"
        #console.log data
        parent = $(that).parents ".card-wrapper"
        parent.remove()
        toastMessage = if message? then message else ('moved to ' + category)
        deployToast('success',toastMessage);
        
        
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
    
    $(".message-unread").click ->
      $(this).makeUnread()
      
    #$(".send-junk").click ->
      #$(this).sendTo("Junk")
      #
    #$(".send-trash").click ->
      #if confirm "Are you really sure?"
        #$(this).sendTo("Trash")
        
    
    $(".send-button").click ->
      if confirm "Are you sure?"
        $(this).sendTo()
      

