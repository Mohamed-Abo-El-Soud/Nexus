# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Rails = {application: "Nexus"}

# general function to deploy a tooltip
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


jQuery.fn.extend makeRead: ->
  @each ->
    that = this
    id = $(this).parents(".card-wrapper").attr "id"
    move_category id, "read", ->
      $(that).removeClass "message-unread"
      $(that).addClass "message-read"
      $(that).removeClass "bright"
      $(that).siblings(".badge.secondary-content").find(".badge-new").remove()
        
jQuery.fn.extend sendTo:(item)->
  @each ->
    that = this
    parent = $(this).parents ".card-wrapper" 
    idNumber = parent.attr("id")
    category = $(this).attr("data-category")
    message = $(this).attr("data-message")
    $(that).parents(".modal").closeModal()
    move_category idNumber, category, ->
      parent = $(that).parents ".card-wrapper"
      parent.remove()
      toastMessage = if message? then message else ('moved to ' + category)
      deployToast('success',toastMessage);
        
        
move_category = (id, category, callback)->
  $.ajax
    url: "/move_category/#{id}"
    type: "GET"
    data:
      id: id
      category: category
      success: (data) ->
        callback(data) if callback?
        
jQuery.fn.extend activation:(callbackObject)->
  @each ->
    origin = $(this)
    activates = $("#" + origin.attr("data-activates"))
    #origin.off('click.' + origin.attr('id'))
    origin.on ("click." + origin.attr('id')), (e)->
      activates.addClass("active")
      # trigger callback on activation
      callbackObject.onActivate() if callbackObject?
      $(document).on 'click.' + activates.attr('id'), (e) ->
        # if target isn't the activates
        if !activates.is(e.target) and
        # or the origin
        !origin.is(e.target) and
        # or the child of the activates
        !activates.find(e.target).length > 0 and
        # or the child of the origin
        !origin.find(e.target).length > 0 or
        # or if the target is the reset button or a child of the reset button
        activates.find("button[type='reset'], button[type='reset'] *").is(e.target)
          callbackObject.onDeactivate() if callbackObject?
          activates.removeClass("active")
          $(document).off 'click.' + activates.attr('id')
        return
        
jQuery.fn.extend searchBar:(callback)->
  @each ->
    # TODO:
    # 1. trigger event when the user starts typing
    $(this).keyup ()->
      $(this).doSearch(callback)
    $(this).siblings("button[type='reset']").click ()->
      callback.onBlank() if callback?
      

jQuery.fn.extend doSearch:(callbackObject)->
  @each ->
    # TODO:
    # 1. get the key-terms from the search bar
    # 2. send ajax request to get search results
    # 3. format the search results
    val = $(this).val()
    if val
      if val != window.$PreviousValue
        window.$PreviousValue = val
        $.ajax
          # TODO:
          # 1. (done) get the key terms
          # 2. (done) get the current page category
          # 3. (done) if the page category is an account's profile, get the account's id
          # 4. (done) get search results (excecute callback maybe?)
          url: "/search"
          type: "GET"
          data:
            type: Rails.page
            other_account: Rails.otherAccount
            key_terms: val
          success: (data) ->
            callbackObject.onSearchResult(data) if callbackObject?
    else
      window.$PreviousValue = null
      callbackObject.onBlank() if callbackObject?
        
window.staticContent = null
window.staticCount = null 
replaceWithSearchResults = (data)->
  window.staticContent ||= $("#content .messages").html()
  window.staticCount ||= $("#messages-count").html()
  $("#content .messages").modifyHTML data
  $("#messages-count").html "Search results (" + $("info.search-count.hide").html() + ")"
  
revertToStaticContent = ()->
  throw("ERROR: no static content!") if window.staticContent is null
  $("#content .messages").modifyHTML window.staticContent
  $("#messages-count").html window.staticCount
  
jQuery.fn.extend modifyHTML:(data)->
  @each ->
    $(this).html(data)
    $('.modal-trigger').leanModal()
    $(".timeago").timeago()

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
      $(this).makeRead()
    
    $(".send-button").click ->
      if confirm "Are you sure?"
        $(this).sendTo()
    
    $(".button-activation").activation()
    
    $(".search-field").searchBar(
      onSearchResult: replaceWithSearchResults
      onBlank: revertToStaticContent
    )
    
# TODO - What's left to be done in this current project:
# 1. (DONE) Rethink the read / unread system in the messsages
# 2. (DONE) Viewing the profile of other accounts, should not show ALL
# of their sent messages, but only the ones which involve you (the current user)
# 3. (DONE) Rework the make_unread and the move_category in the front and back-end
# 4. (DONE) Implement the front-end of the search-bar using existing code and JQuery or AngularJS
# 5. Implement the back-end of the search bar either using the rails framework and AJAX
# requests or through AngularJS