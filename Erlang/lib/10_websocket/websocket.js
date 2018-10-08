// Not working...
function connect(host, port, module) {
  enableButtons()
  enableInputs()
  startSession(`ws://${host}:${port}/websocket/${module}`)
}

const enableButtons = () => $(".live_button").each(() => {
  let button = $(this),
      text = button.text()
  button.click(() => sendJSON({"clicked": text}))
})
const sendJSON = (data) => send(JSON.stringify(data))

const enableInputs = () => $(".live_input").each(() => {
  let event = $(this),
      id = event.attr("id")

  event.keyup(event => {if (event.keyCode === 13) readEntry(event, id)})
})
function readEntry(event, id){
  let value = event.value()
  event.value(" ")
  sendJSON({"entry": id, text: value})
}

const onOpen = () => console.log("connected")

const onClose = () => document.body.style.backgroundColor="#aabbcc"

const onMessage = (event) => exec(JSON.parse(event.data))

function exec(json){
  for (var i = 0; i < json.length; i++) {
    var o = json[i];
  	// as a safety measure we only evaluate js that is loaded
  	if(eval("typeof("+o.cmd+")") == "function") {
  	    eval(o.cmd + "(o)");
  	} else {
  	    alert("bad_command:"+o.cmd);
  	};
  }
}

const onError = () => document.body.style.backgroundColor="orange"

function startSession(endpoint) {// https://developer.mozilla.org/en-US/docs/Web/API/WebSocket
  websocket           = new WebSocket(endpoint)
  websocket.onopen    = onOpen
  websocket.onclose   = onClose
  websocket.onmessage = onMessage
  websocket.onerror   = onError

  return false
}

const send = (message) => websocket.send(message)


function appendDiv(object){
  let element = $("#" + object.id)
  element.append(object.text)
  element.animate({scrollTop: element.prop("scrollHeight")}, 1000)
}

const fillDiv = (object) => $("#" + object.id).html(object.text)
