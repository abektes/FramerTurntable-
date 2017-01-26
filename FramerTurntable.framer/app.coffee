
Framer.Info = 
	title: "Turntable with video player"
	author: "Ahmet Bektes"
	twitter: "abektes"

# Ratio for Ipad 
widthRatio = 899 / Screen.width
heightRatio = 1259 / Screen.height
smallest = Math.min(widthRatio, heightRatio)

# Video Container 
videoContainer = new Layer
	backgroundColor:'#fff'
	shadowBlur:2
	shadowColor:'rgba(0,0,0,0.24)'
	width: 1536
	height: 2048
	z:3
	opacity: 0

videoContainer.states.add
	StateB: 
		opacity: 1 

videoLayer = new VideoLayer
	video: "images/v5.mov"
	backgroundColor:'#fff'
	superLayer: videoContainer
	width: 1540
	height: 1027
	y:450
		

# Video - 360 Toggle

# Video Button 	
videoButton = new Layer
	z:4
	x: 1269
	y: 1860
	image: "images/video.png"
	width: 101
	height: 101

#360 Toggle
videoButton.states.add
	stateB: 
		image: "images/360.png"
			
	
videoButton.onTap -> 
	videoContainer.states.next()
	videoButton.states.next()

## Video Player
# center everything on screen	
videoContainer.center()

# when the video is clicked
videoLayer.on Events.Click, ->
	# check if the player is paused
	if videoLayer.player.paused == true
		# if true call the play method on the video layer
		videoLayer.player.play()
		playButton.image = 'images/pause.png'
	else
		# else pause the video
		videoLayer.player.pause()
		playButton.image = 'images/play.png'
		
	# simple bounce effect on click	
	playButton.scale = 2
	playButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'
		
# control bar to hold buttons and timeline
controlBar = new Layer
	width:videoLayer.width - 20
	height:48		
	backgroundColor:'rgba(0,0,0,0.75)'	
	clip:false
	borderRadius:'8px'
	superLayer:videoContainer

# center the control bar
controlBar.center()

# position control bar towards the bottom of the video
controlBar.y = videoLayer.maxY - controlBar.height - 10


# play button
playButton = new Layer
	width:48
	height:48
	image:'images/play.png'
	superLayer:controlBar

# on/off volume button
volumeButton = new Layer
	width:48
	height:48
	image:'images/volume_on.png'
	superLayer:controlBar

# position the volume button to the right of play
volumeButton.x = playButton.maxX

# Function to handle play/pause button
playButton.on Events.Click, ->
	if videoLayer.player.paused == true
		videoLayer.player.play()
		playButton.image = "images/pause.png"
	else
		videoLayer.player.pause()
		playButton.image = "images/play.png"
		
	# simple bounce effect on click	
	playButton.scale = 1.15
	playButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'	

# Volume on/off toggle
volumeButton.on Events.Click, ->
	if videoLayer.player.muted == false
		videoLayer.player.muted = true
		volumeButton.image = "images/volume_off.png"
	else
		videoLayer.player.muted = false
		volumeButton.image = "images/volume_on.png"
		
	# simple bounce effect on click	
	volumeButton.scale = 1.15
	volumeButton.animate
		properties:
			scale:1
		time:0.1	
		curve:'spring(900,30,0)'
		
# white timeline bar
timeline = new Layer
	width:1380
	height:10
	y:volumeButton.midY - 5
	x:volumeButton.maxX + 10
	borderRadius:'10px'
	backgroundColor:'#fff'
	clip:false
	superLayer: controlBar

# progress bar to indicate elapsed time
progress = new Layer
	width:0
	height:timeline.height
	borderRadius:'10px'
	backgroundColor:'#03A9F4'
	superLayer: timeline

# scrubber to change current time
scrubber = new Layer
	width:18
	height:18
	y:-4
	borderRadius:'50%'
	backgroundColor:'#fff'
	shadowBlur:10
	shadowColor:'rgba(0,0,0,0.75)'
	superLayer: timeline

# make scrubber draggable
scrubber.draggable.enabled = true

# limit dragging along x-axis	
scrubber.draggable.speedY = 0

# prevent scrubber from dragging outside of timeline
scrubber.draggable.constraints =
	x:0
	y:timeline.midY
	width:timeline.width
	height:-10		
	
# Disable dragging beyond constraints 
scrubber.draggable.overdrag = false

# Update the progress bar and scrubber as video plays
videoLayer.player.addEventListener "timeupdate", ->
	# Calculate progress bar position
	newPos = (timeline.width / videoLayer.player.duration) * videoLayer.player.currentTime
	
	# Update progress bar and scrubber
	scrubber.x = newPos
	progress.width = newPos	+ 10

# Pause the video at start of drag
scrubber.on Events.DragStart, ->
	videoLayer.player.pause()

# Update Video Layer to current frame when scrubber is moved
scrubber.on Events.DragMove, ->
	progress.width = scrubber.x + 10

# When finished dragging set currentTime and play video
scrubber.on Events.DragEnd, ->
	newTime = Utils.round(videoLayer.player.duration * (scrubber.x / timeline.width),0);
	videoLayer.player.currentTime = newTime
	videoLayer.player.play()
	playButton.image = "images/pause.png"
		

# Logo 

logo = new Layer 
	image: "images/logo.png"
	z:5
	x: 80
	y: 80

# Background 

bg = new Layer
	backgroundColor: "white"
	image: "images/0_#{0}.jpg"
	x: 0
	size: Screen
	style: 
		backgroundSize: "#{smallest * 130}%"
		

# Slider 360 
slider = new SliderComponent
	x: Align.center
	maxY: Screen.height - 120
	min: 1
	max: 23
	knobSize: 60
	width: 500
	
slider.fill.backgroundColor = "#004cdf"


slider.onValueChange ->
	frame = Math.floor(slider.value)
	bg.image = "images/0_#{frame}.jpg"


# Automator is handy for renaming files. 

i = 0 

for i in [0...30]
	l = new Layer
		image: "images/0_{i}.jpg"
		opacity: 0




