# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

speedControl = (player)->
  play_rate = 1
  $("#speed_up").click ->
    play_rate = play_rate*2 if play_rate < 8
    player.playbackRate(play_rate)
    $("#speed_display").html(play_rate + "X")

  $("#speed_down").click ->
    play_rate = play_rate/2 if play_rate > 0.25
    player.playbackRate(play_rate)
    $("#speed_display").html(play_rate + "X")

positionControl = (player)->
  r_state = {current: "none", state_a: 0, state_b: 0}
  player.on "timeupdate", ->
    time = player.currentTime()
    if r_state.current is "repeat_b"
      player.currentTime(r_state.state_a) if time > r_state.state_b

  $("#repeat_b").click ->
    r_state.current = "repeat_b" if r_state.current is "repeat_a"
    r_state.state_b = player.currentTime()
    $("#repeat_b > .glyphicon").html(parseInt(r_state.state_b))

  $("#repeat_a").click ->
    r_state.current = "repeat_a"
    r_state.state_a = player.currentTime()
    $("#repeat_a > .glyphicon").html(parseInt(r_state.state_a))

  $("#repeat_reset_button").click ->
    r_state.current = "none"
    $("#repeat_b > .glyphicon").html('')
    $("#repeat_a > .glyphicon").html('')


$ ->
  $("#comment_notice").hide()
  $("#comment_notice").click (e)->
    $(this).hide();
  player = null;
  if $("#video_player").length > 0
    videojs("video_player").ready ->
      player = this
      speedControl(player)
      positionControl(player)
      comments = $("#video_player > video").data('comment')
      player.markers({
         markers: comments,
         breakOverlay:{
          display: true,
          displayTime: 1,
          text: (marker)->
         },
         onMarkerReached: (marker) ->
            $('#comment_viewer > .time > .value').html(marker.time);
            comment = marker.text + " By " + marker.user.email
            $('#comment_viewer > .comment').html(comment);
      });


  $(".comment_on_video").click (e)->
    time = parseInt(player.currentTime())
    $("#comment_form").html($("#comment_form_template").html());
    $("#comment_form").show()
    $("#comment_form #comment_time").val(time);
    $("#comment_form #comment_timestamp").html("at "+ time + " sec")

  $('#comment_form').on('ajax:success',(data, status, xhr)->
    player.markers.add([{
       time: $("#comment_time").val(),
       text: $("#comment_content").val()
    }]);
    $('#comment_notice').html('Comment was added');
    $("#comment_form").hide()
    $("#comment_form").html('')

  ).on('ajax:error', (xhr, status, error)->
    $('#comment_notice').text('Comment coudn\'t be added. Try again');
  );
