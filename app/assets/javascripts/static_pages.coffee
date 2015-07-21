# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# general function to deploy a tooltip

#console.log "static_pages"
window.deployToast = (type, message)->
  typeClass = switch type
    when "success"
    then "green"
    when "failure"
    then "red"
    when "warning"
    then "yellow"
  textOpen = "<span class=\"alert #{typeClass}-text\">"
  textClose = "#{message}</span>"
  dismissToast = "$(this)[0].parentNode.parentNode.removeChild($(this)[0].parentNode)"
  dismissLink = "<a class=\"btn-flat text-accent\" onClick=\"#{dismissToast}\">Dismiss</a>"
  Materialize.toast "#{textOpen}#{textClose}#{dismissLink}",50000
  #Materialize.toast('<span>Item Deleted</span><a class=&quot;btn-flat yellow-text&quot; href=&quot;#!&quot;>Undo<a>', 5000)

#console.log deployToast
#Materialize.toast('text <a class="btn-flat yellow-text" onClick="console.log(
  #$(this)[0].parentNode.parentNode.removeChild($(this)[0].parentNode))" href="#!">hello</a>',5000)
#dismissToast = (toast) ->
  #Vel toast,
  		#marginTop: "-40px"
    	#,
      #duration: 375
    #easing: "easeOutExpo"
    #queue: false
    #complete: ->
      #toast.parentNode.removeChild toast
      
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
