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
        
jQuery.fn.extend sendTo:(item)->
  @each ->
    that = this
    parentId = $(this).parents(".modal.modal-fixed-footer").attr("id")
    idNumber = parentId.substring parentId.length - 1
    category = $(this).attr("data-category")
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
        deployToast('success','moved to ' + category);
        
        
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
      

