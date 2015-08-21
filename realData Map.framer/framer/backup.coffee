# This imports all the layers for "searchTest" into searchtestLayers
br = Framer.Importer.load "imported/searchTest"

mapLayer = new Layer x:0, y:130, width:640, height:910,backgroundColor:'#fff'
mapLayer.html = "<div id='map' style='height:910px'></div>"
mapLayer.ignoreEvents = false 
mapLayer.style["-webkit-select"] = "auto"
mapLayer.style["opacity"] = "1"
mapLayer.index = 1

searchButton = new Layer x:530, y:900, width:90, height:90, backgroundColor:'#333'
searchButton.borderRadius = 5

###FILTER
timeSelect = new Layer x:500, y:130, width:300, height:910

slider = new Layer x:0, y:100, width:300, height:60, backgroundColor: "green"
slider.draggable.enabled = true
slider.draggable.speedX = 0.0
slider.draggable.speedY = 1.0

timeSelect.addSubLayer(slider)
timeSelect.bringToFront()
searchButton.placeBefore(mapLayer)

# FILTER
timeSelect.states.add
	on: {x:500}
	off: {x:650}
timeSelect.states.switch "off"

# EVENTS
searchButton.on Events.Click, () ->
	timeSelect.states.next(["on", "off"])

lastY = 0
slider.on Events.DragMove, (event, layer) ->
	# Only trigger this every X px
	if layer.y > lastY + 50 || layer.y < lastY - 50
		lastY = layer.y
		filterIcons()
###	
###
map = 0
initialize = () ->
	L.mapbox.accessToken = "pk.eyJ1IjoiY2hwb3NjaG1hbm4iLCJhIjoiWFdsd3dPNCJ9.4IwxXt_tYpGuh1fCu3Hwpg"
	map = L.mapbox.map('map', 'chposchmann.e48838cb').setView([40.7603, -73.979], 14)
	setupPins()
	
markers = null
geojson = null

setupPins = () ->
	geojson = []
	markers = L.mapbox.featureLayer();
	markers.addTo(map);
	for current in data
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
        		"marker-size": "large",
        		"marker-symbol": "park",
		        "marker-color": "#1FA561"
			}
		};
		geojson.push(geoPoint)
	markers.setGeoJSON(geojson);

filterIcons = () ->
	print "filter"
	markers.setFilter = (mkr) ->
		return (Math.round(Math.random()))
###	
Utils.delay 0.3, -> initialize() # make sure map is ready