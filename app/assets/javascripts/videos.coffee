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
    return 0 if r_state.current isnt "repeat_a"
    r_state.current = "repeat_b"
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

videoId = (id)->
  parseInt $(id).attr("data-id")

currentVideoId = (id="#video_player")->
  window.current_video_id

setCurrentVideoId = (id)->
  window.current_video_id = id

setActivePlaylist = ->
  $("ul#playlist  li").removeClass("active")
  $("ul#playlist  li#video-"+currentVideoId()).addClass("active")

changePlayerData = (data) ->
  setCurrentVideoId(data.id)
  $("#video_title").html(data.title + " By " + data.user.email)
  setActivePlaylist()
  player = getPlayer()
  player.src({type: "video/"+ data.type, src: data.authenticated_url})
  player.play()

createPlayer = (video_anchor_ele)->
  ele_data = $(video_anchor_ele).data("video")
  $("#current_video_box").html(JST['videos/video_player'](ele_data));
  ele_data

renderComments = (comments)->
  $("#comment_view").html(JST['videos/comments_view']({comments: comments}));

getPlayer = (id="video_player")->
  videojs(id)

setupPlayer = ->
  console.log "setupPlayer"
  window.player_set = true
  player = getPlayer()
  myButton = player.controlBar.addChild('button');
  $(myButton.el()).append(JST["player/playlist_controls"])
  myButton.addClass("player_next_prev");
  $("#previous",$(myButton.el())).on 'click', ->
    ele = $("#video-"+currentVideoId())
    prev_ele = $(ele).parent().prev()
    if prev_ele.length > 0
      changeVideo(videoId(prev_ele))
    else
      alert("no more videos in playlist")
  $("#next",$(myButton.el())).on 'click', ->
    ele = $("#video-"+currentVideoId())
    next_ele = $(ele).parent().next()
    if next_ele.length > 0
      changeVideo(videoId(next_ele))
    else
      alert("no more videos in playlist")

initPlayer = (id, markers)->
  videojs(document.getElementById(id)).ready ->
    player = this
    setupPlayer() unless window.player_set
    speedControl(player)
    positionControl(player)

changeVideo = (id) ->
  ele = $("#video-"+id).parent()
  data = $(ele).data('video')
  changePlayerData(data)
  initPlayer("video_player", data.markers)
  renderComments(data.markers)


$ ->
  $("#comment_notice").hide()
  $("#comment_notice").click (e)->
    $(this).hide();
  if $("#current_video_box").length > 0
    ele = $("#playlist > a:first-child")
    data = $("#video_player").data("comment")
    initPlayer("video_player", data)
    setActivePlaylist()
    renderComments(data)

  $(".set_play_video").click (e)->
    time = parseInt($(this).data("time"))
    getPlayer().currentTime(time)
    getPlayer().play()

  $("#playlist > a").click ->
    ele = this
    changeVideo(videoId(this)) unless currentVideoId() == videoId(this)



  $(".comment_on_video").click (e)->
    getPlayer().pause()
    time = parseInt(getPlayer().currentTime())
    $("#comment_form").html(JST['videos/comment_form']({id: currentVideoId()}));
    $("#comment_form").show()
    $("#comment_form #comment_time").val(time);
    $("#comment_form #comment_timestamp").html("at "+ time + " sec")

  $('#comment_form').on('ajax:success',(data, status, xhr)->
    $('#comment_notice').html('Comment was added');
    video_id = currentVideoId()
    video_data = $("#video-"+video_id).parent().data('video')
    video_data.markers.push(status)
    renderComments(video_data.markers)
    $("#video-"+video_id).parent().data('video', video_data)
    $("#comment_form").hide()
    $("#comment_form").html('')

  ).on('ajax:error', (xhr, status, error)->
    $('#comment_notice').text('Comment coudn\'t be added. Try again');
  );
