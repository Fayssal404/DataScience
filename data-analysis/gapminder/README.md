# GapMinder Interactive Visualization

### Data Description


### Post Data Interaction


### Bokeh Server
- Python creates a series of objects, the series of objects get turned into JSON
- JSON get send to the browser, where there is a JS library that consume that JSON & turn it into a plot seen on the webpage

## What happens in the background?
- Setup a WebSocket between the server & the python process, any changes that happens on the webserver side get reflected back to the server

- Build Dashboard using Bokeh Widget
- There is no need to update this and push that
