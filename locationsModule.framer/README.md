# listView Module
This is a module for Framer Studio. It easily let's you create a list of locations with real data.

# Demo
![listModule demo](https://s3.amazonaws.com/f.cl.ly/items/0w2M0L112S19100H230P/Screen%20Recording%202015-06-26%20at%2001.24%20PM.gif)

## Basic usage

Download locationsModule.coffee and put it in the /modules folder of your Framer project. 
Move the included locations.js File into the "images" Folder of your project.

To add the map, you will have to open the index.html from your project folder and add

```html
<script src='https://api.tiles.mapbox.com/mapbox.js/v2.1.5/mapbox.js'></script>
		<link href='https://api.tiles.mapbox.com/mapbox.js/v2.1.5/mapbox.css' rel='stylesheet' />
```

Then add this line at the top of your project in Framer Studio.

```coffeescript
module = require "locationsModule"
```
Then to create the tab bar you do this:
```coffeescript
module.setupLocations()
```


## Change styling
I haven't setup an easy way to change the styling within Framer, but you can edit the styling within the locationsModule.coffee file.
```coffeescript
listHeight = *number* # Height of List item
listWidth = *number*  # Width of List item
yDistance = *number* # Distance between List items
maxLocation = *number* # Set the number of List items
```

When you change the height, you will have to adjust the position of the text overlay by changing it's y position.
Same goes for the underlying gradient.


