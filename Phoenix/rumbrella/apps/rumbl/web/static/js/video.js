import Player from "./player";

export default ({
  init(socket, element) {
    if (!element) return;

    let playerId = element.getAttribute("data-player-id");
    let videoId = element.getAttribute("data-id");

    socket.connect();

    Player.init(element.id, playerId, () => this.onReady(videoId, socket));
  },

  esc(str) {
    let div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  },

  formatTime(at) {
    let date = new Date(null);
    date.setSeconds(at/1000);
    return date.toISOString().substr(14, 5);
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    let template = document.createElement("div");

    template.innerHTML = `
      <a href="#" data-seek="${this.esc(at)}">
        [${this.formatTime(at)}]
        <b>${this.esc(user.username)}</b>: ${this.esc(body)}
      </a>
    `;

    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter(a => {
      if (a.at > seconds) {
        return true;
      } else {
        this.renderAnnotation(msgContainer, a);
        return false;
      }
    });
  },

  scheduleMessages(msgContainer, annotations) {
    setTimeout(() => {
      let cTime = Player.getCurrentTime();
      let remaining = this.renderAtTime(annotations, cTime, msgContainer);
      this.scheduleMessages(msgContainer, remaining);
    }, 1000);
  },

  onReady(videoId, socket) {
    let msgContainer = document.getElementById("msg-container");
    let msgInput = document.getElementById("msg-input");
    let postButton = document.getElementById("msg-submit");
    let videoChannel = socket.channel("videos:" + videoId);

    msgContainer.addEventListener("click", event => {
      event.preventDefault();
      let seconds = event.target.getAttribute("data-seek") ||
                    event.target.parentNode.getAttribute("data-seek");

      if (!seconds) return;
      Player.seekTo(seconds);
    });

    postButton.addEventListener("click", event => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()};
      videoChannel.push("new_annotation", payload)
        .receive("error", err => console.log(err));

      msgInput.value = "";
    });

    videoChannel.on("new_annotation", response => {
      videoChannel.params.last_seen_id = response.id;
      this.renderAnnotation(msgContainer, response);
    });

    videoChannel.join()
      .receive("ok", response => {
        let ids = response.annotations.map(a => a.id);

        if (ids.length > 0) videoChannel.params.last_seen_id = Math.max(...ids);

        this.scheduleMessages(msgContainer, response.annotations);
      }).receive("error", reason => console.log("failed to join", reason));
  },
});
