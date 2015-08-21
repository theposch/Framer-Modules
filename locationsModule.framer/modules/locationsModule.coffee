
# Load JSON File
locationsData = JSON.parse Utils.domLoadScriptSync "images/locations.js"

# 3 steps :
# module = require "locationsModule"
# module.setupLocations()
# And put the locations.js file in images/locations.js


exports.setupLocations = () ->
	# Variables
	listWidth = Framer.Device.screen.width
	listHeight = 416
	#Set distance between cards
	yDistance = listHeight + 0

	# Apply format and positioning to a card's overlay text HTML
	applyCSS = (layer)->
		h2 = layer.querySelector("h2")
		h2.style.font = "600 24px/48px AvenirLTStd-Medium"
		h2.style.textShadow = "0px 2px 1px rgba(0,0,0,0.55);"
		
		h1 = layer.querySelector("h1")
		h1.style.font = "600 32px/48px AvenirLTStd-Medium"
		h1.style.textShadow = "0px 2px 1px rgba(0,0,0,0.55);"
		h1.style.marginBottom = "8px"
		
		container = layer.querySelector(".content")
		container.style.position = "absolute"
		container.style.bottom = "16px"
		
	# Create scroll component
	scroll = new ScrollComponent
		width: listWidth
		height: Framer.Device.screen.height
		scrollHorizontal: false
		
	#Set Number of cards
	maxLocation = 20
	currentCount = 0
	i = 0
	for locationData in locationsData
		if currentCount > maxLocation
			continue;
			
		#Card Setup
		card = new Layer width:listWidth, height:listHeight, y:i*yDistance, clip:false,
		borderRadius: 4, name: "card", superLayer: scroll.content
		currentCount++
		
		# Card Style
		card.backgroundColor = "rgba(255,255,255,1)"
		
		# Create and add a image layer to the card 
		locationImage = new Layer
			width: listWidth, height: listHeight, image: locationData.picture.url, name: "image"
		locationImage.superLayer = card
		
		# Add a gradient to the card
		gradient = new Layer
			width: listWidth, image: "https://s3.amazonaws.com/f.cl.ly/items/2T2n0H1E3U3c3l442W1x/Gradient.png", y:320
		gradient.superLayer = card
			
		# Add the text overlay
		overlay = new Layer
			x: 16, y: 220, width: listWidth, height: 200, backgroundColor: null, name: "overlay"
		overlay.html = "<div class='content'><h1>"+locationData.address1+"</h1><h2>"+locationData.maxPeople+"</h2></div>"
		applyCSS(overlay)
		overlay.superLayer = card
		card.overlay = overlay
		overlay.bringToFront()
		i++

		
exports.setupMap = () ->

	mapLayer = new Layer x:0, y:0, width:750, height:1334,backgroundColor:'#fff'
	mapLayer.html = "<div id='map' style='height:1334px'></div>"
	mapLayer.ignoreEvents = false 
	mapLayer.style["-webkit-select"] = "auto"
	mapLayer.style["opacity"] = "1"
	mapLayer.index = 1

	# MAP
	map = 0
	initialize = () ->
		L.mapbox.accessToken = "pk.eyJ1IjoiY2hwb3NjaG1hbm4iLCJhIjoiWFdsd3dPNCJ9.4IwxXt_tYpGuh1fCu3Hwpg"
		map = L.mapbox.map('map', 'chposchmann.e48838cb').setView([40.7603, -73.979], 14)
		map.featureLayer.on Events.Click, (e) ->
	  	map.panTo e.layer.getLatLng()
	  
	  
		setupPins()
		
	markers = null
	geojson = null

	setupPins = () ->
		geojson = []
		markers = L.mapbox.featureLayer();
		pinLayer = L.mapbox.featureLayer().addTo(map);
		map.featureLayer.on Events.Click, (e) ->
	 		map.panTo e.layer.getLatLng()
		
		markers.addTo(map);
		for current in locationsData
			geolocation = current["geoLocation"]
			
			# create geoJson data
			geoPoint = {
	      		"type": "Feature",
	      		"geometry": {
	      			"type": "Point",
	      			"coordinates": [geolocation["longitude"], geolocation["latitude"]]
	      		},
	      		"properties": {
	      			
	        		"title": current["name"],
	        		"image":current.picture.url
	        		"address1": current.address1
	        		"icon": {
	        			"className": "address1"
	        			"iconUrl": "images/pin.png",
	        			"iconSize": [102,84]
			        	
	        		}
				}
			};
			geojson.push(geoPoint)
			
		#Set a custom icon on each marker based on feature properties.
		pinLayer.on 'layeradd', (e) ->
		
			marker = e.layer
			feature = marker.feature
			marker.setIcon L.icon(feature.properties.icon)
			popupContent =  '<img width="430" src="' + feature.properties.image + '" />' + feature.properties.address1 
			marker.bindPopup popupContent,
	    closeButton: false
	    minWidth: 450
	  	
		  
		
		pinLayer.setGeoJSON(geojson);
		
		


			
	Utils.delay 0.3, -> initialize() # make sure map is ready