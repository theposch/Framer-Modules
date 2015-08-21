locationsData = JSON.parse Utils.domLoadScriptSync "images/locations.js"

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
	map.featureLayer.on 'click', (e) ->
  	map.panTo e.layer.getLatLng()
  
  
	setupPins()
	
markers = null
geojson = null

setupPins = () ->
	geojson = []
	markers = L.mapbox.featureLayer();
	pinLayer = L.mapbox.featureLayer().addTo(map);
	
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
		popupContent = '<a target="_blank" class="popup" href="' + feature.properties.url + '">' + '<img src="' + feature.properties.image + '" />' + feature.properties.city + '</a>'
		marker.bindPopup popupContent,
    closeButton: false
    minWidth: 420
  return
	  
	
	pinLayer.setGeoJSON(geojson);
	


		
Utils.delay 0.3, -> initialize() # make sure map is ready