// "Programming Phoenix", 162
export default {
  player: null,

  init(domId, playerId, onReady) {
    window.onYouTubeIframeAPIReady = () => {
      this.onIframeReady(domId, playerId, onReady);
    };

    let youtubeScriptTag = document.createElement("script");
    youtubeScriptTag.src = "//www.youtube.com/iframe_api";
    document.head.appendChild(youtubeScriptTag);
  },

  // creates player w/ YouTube iframe API
  onIframeReady(domId, playerId, onReady) {
    this.player = new YT.Player(domId, {
      height: "360",
      width: "420",
      videoId: playerId,
      events: { "onReady": (event => onReady(event)),
                "onStateChange": (event => this.onPlayerStateChange(event)) }
    });
  },

  onPlayerStateChange(event) {},
  // convenience fn's; makes less dependent on YouTube API
  getCurrentTime() { return Math.floor(this.player.getCurrentTime() * 1000); },

  seekTo(msec) { return this.player.seekTo(msec/1000); }
};
