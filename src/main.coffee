box = document.getElementById("image")
box.ondragover = (event) ->
  this.className = 'hover'
  event.preventDefault()
box.ondragend = (event) ->
  this.className = ''
  event.preventDefault()
box.ondrop = (event) ->
  event.preventDefault()
  file = event.dataTransfer.files[0]
  reader = new FileReader
  reader.onload = (event) ->
    dataURL = event.target.result
    clustering {maxWidth: 100, maxHeight: 100, url: dataURL, debug: off}, (centers) ->
      console.log centers
    image = new Image
    image.src = dataURL
    image.width = 400
    document.body.appendChild image
  reader.readAsDataURL file
