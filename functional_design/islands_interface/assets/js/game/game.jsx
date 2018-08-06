import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'underscore';
import {Socket} from "phoenix";

const socket = new Socket("/socket", {});
socket.connect();

function blankBoard() {
  let board = {};

  for (let i = 1; i <= 10; i++) {
    for (let j = 1; j <= 10; j++) {
      board[i + ":" + j] = {row: i, col: j, className: "coordinate"};
    }
  }
  return board;
}

function getRows(board) {
  let rows = {1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [], 8: [], 9: [], 10: []};
  let boardValues = Object.values(board);

  _.each(boardValues, function(value) {
    rows[value.row].push(value);
  })
  return rows;
}

function hit(board, row, col) {
  board[row + ":" + col].className = "coordinate hit";
  return board;
}

function miss(board, row, col) {
  board[row + ":" + col].className = "coordinate miss";
  return board;
}

function inIsland(board, coordinates) {
  _.each(coordinates, function(coord) {
    board[coord.row + ":" + coord.col].className = "coordinate island";
  });
  return board;
}

function Coordinate(props) {
  return (
    <td
      className={props.className}
      data-row={props.row}
      data-col={props.col}
      onClick={props.onClick}
      onDragOver={props.onDragOver}
      onDrop={props.onDrop}
    />
  )
}

function Box(props) {
  return (
    <td className="box">
      {props.value}
    </td>
  );
}

function MessageBox(props) {
  return (
    <div className="message_box">
      {props.message}
    </div>
  )
}

function Button(props) {
  return (
    <div className="button" id={props.id} onClick={props.onClick}>
      {props.value}
    </div>
  )
}

function HeaderRow(props) {
  const range = _.range(1,11);

  return (
    <thead className="row">
      <tr>
        <Box />
        {range.map(function(i) {
          return (<Box value={i} key={i} />)
        })}
      </tr>
    </thead>
  );
}

class OwnBoard extends React.Component {
  constructor(props) {
    super(props);
    this.allowDrop = this.allowDrop.bind(this);
    this.dropHandler = this.dropHandler.bind(this);
    this.state = {
      board: blankBoard(),
      player: props.player,
      channel: props.channel,
      message: "Welcome!",
      islands: ["atoll", "dot", "L", "S", "square"]
    }
  }

  componentDidMount() {
    this.state.channel.on("guessed_coordinate", response => {
      this.processOpponentGuess(response);
    })
  }

  componentWillUnmount() {
    this.state.channel.off("guessed_coordinate", response => {
      this.processOpponentGuess(response);
    })
  }

  allowDrop(event) {
    event.preventDefault();
  }

  dropHandler(event) {
    event.preventDefault();
    const data = event.dataTransfer.getData("text");
    const image = document.getElementById(data);
    const row = Number(event.target.dataset.row);
    const col = Number(event.target.dataset.col);
    this.positionIsland(event.target, image, row, col);
  }

  positionIsland(coordinate, island, row, col) {
    const params = {"player": this.state.player, "island": island.id, "row": row, "col": col};
    this.state.channel.push("place_island", params)
      .receive("ok", response => {
         coordinate.appendChild(island);
         island.className = "positioned_island_image";
         this.setState({message: "Island Positioned!"});
       })
      .receive("error", response => {
         this.setState({message: "Oops!"});
       })
  }

  handleClick() {
    this.setIslands(this.state.player);
  }

  setIslands(player) {
    this.state.channel.push("set_islands", player)
      .receive("ok", response => {
        this.removeIslandImages(this.state.islands);
        this.setIslandCoordinates(response.board);
        this.setState({message: "Islands set!"});
        document.getElementById("set_islands").remove();
       })
      .receive("error", response => {
        this.setState({message: "Oops. Can't set your islands yet."});
       })
  }

  extractCoordinates(board) {
    let coords = this.state.islands.reduce(
      function(acc, island) {
        return acc.concat(board[island].coordinates);
      }, []
    );
    return coords;
  }

  removeIslandImages() {
    const images = document.getElementsByTagName("img");
    this.state.islands.forEach(function(island) { images[island].remove(); });
  }

  setIslandCoordinates(responseBoard) {
    const coordinates = this.extractCoordinates(responseBoard, this.state.islands);
    const newBoard = inIsland(this.state.board, coordinates);
    this.setState({board: newBoard});
  }

  processOpponentGuess(response) {
    let board = this.state.board;
    if (response.player !== this.state.player) {
      if (response.result.win === "win") {
        this.setState({message: "Your opponent won."});
        board = hit(board, response.row, response.col);
      } else if (response.result.island !== "none") {
        this.setState({message: "Your opponent forested your " + response.result.island + " island."});
        board = hit(board, response.row, response.col);
      } else if (response.result.hit === true) {
        this.setState({message: "Your opponent hit your island."});
        board = hit(board, response.row, response.col);
      } else {
        this.setState({message: "Your opponent missed."});
        board = miss(board, response.row, response.col);
      }
    }

    this.setState({board: board});
  }

  renderRow(coordinates, key) {
    const context = this;

    return (
      <tr className="row" key={key}>
        <Box value={key} />
        {coordinates.map(function(coord, i) {
          return ( <Coordinate
                      row={coord.row}
                      col={coord.col}
                      key={i}
                      onDragOver={context.allowDrop}
                      onDrop={context.dropHandler}
                      className={coord.className}
                   />)
        })}
      </tr>
    )
  }

  render() {
    const rows = getRows(this.state.board);
    const range = _.range(1,11);
    const context = this;

    return (
      <div id="own_board">
        <MessageBox message={context.state.message} />
        <table className="board" id="ownBoard">
          <caption className="board_title">your board</caption>
          <HeaderRow />
          <tbody>
            {range.map(function(i) {
              return (context.renderRow(rows[i], i))
            })}
          </tbody>
        </table>
        <Button value="Set Islands" id="set_islands" onClick={() => this.handleClick("start-game")} />
      </div>
    );
  }
}

class OpponentBoard extends React.Component {
   constructor(props) {
    super(props);
    this.state = {
      board: blankBoard(),
      player: props.player,
      message: "No opponent yet.",
      channel: props.channel
    }
  }

  componentDidMount() {
    this.state.channel.on("player_added", response => {
      this.processPlayerAdded();
    })

    this.state.channel.on("player_set_islands", response => {
      this.processOpponentSetIslands(response);
    })

    this.state.channel.on("player_guessed_coordinate", response => {
      this.processGuess(response);
    })
  }

  componentWillUnmount() {
    this.state.channel.off("player_added", response => {
      this.processPlayerAdded();
    })

    this.state.channel.off("player_set_islands", response => {
      this.processOpponentSetIslands();
    })

    this.state.channel.off("player_guessed_coordinate", response => {
      this.processGuess(response);
    })
  }

  processPlayerAdded() {
    this.setState({message: "Both players present."});
  }

  processOpponentSetIslands(response) {
    if (this.state.player !== response.player) {
      this.setState({message: "Your opponent set their islands."});
    }
  }

  handleClick(row, col) {
    this.guessCoordinate(this.state.player, row, col);
  }

  guessCoordinate(player, row, col) {
    const params = {"player": player, "row": row, "col": col};
    this.state.channel.push("guess_coordinate", params)
      .receive("error", response => {
          this.setState({message: response.reason});
        })
  }

  processGuess(response) {
    let board = this.state.board;
    if (response.player === this.state.player) {
      if (response.result.win === "win") {
        this.setState({message: "You won!"});
        board = hit(board, response.row, response.col);
      } else if (response.result.island !== "none") {
        this.setState({message: "You forested your opponent's " + response.result.island + " island!"});
        board = hit(board, response.row, response.col);
      } else if (response.result.hit === true) {
        this.setState({message: "It's a hit!"});
        board = hit(board, response.row, response.col);
      } else {
        this.setState({message: "Oops, you missed."});
        board = miss(board, response.row, response.col);
      }
    }

    this.setState({board: board});
  }

  renderRow(coordinates, key) {
    const context = this;

    return (
      <tr className="row" key={key}>
        <Box value={key} />
        {coordinates.map(function(coord, i) {
          return ( <Coordinate
                      row={coord.row}
                      col={coord.col}
                      onClick={() => context.handleClick(coord.row, coord.col)}
                      key={i}
                      className={coord.className}
                   /> )
        })}
      </tr>
    )
  }

  render() {
    const rows = getRows(this.state.board);
    const range = _.range(1,11);
    const context = this;

    return (
      <div id="opponent_board">
        <MessageBox message={context.state.message} />
        <table className="board" id="opponentBoard">
          <caption className="board_title">your opponent's board</caption>
          <HeaderRow />
          <tbody>
            {range.map(function(i) {
              return (context.renderRow(rows[i], i))
            })}
          </tbody>
        </table>
      </div>
    );
  }
}

class Game extends React.Component {
  constructor(props) {
    super(props),
    this.handleClick = this.handleClick.bind(this),
    this.state = {
      isGameStarted: false,
      channel: null,
      player: null,
    }
  }

  renderStartButtons(props) {
    return (
      <div>
        <Button value="Start the Demo Game" onClick={() => this.handleClick("start-game")} />
        <Button value="Join the Demo Game" onClick={() => this.handleClick("join-game")} />
      </div>
    )
  }

  newChannel(screen_name) {
    return socket.channel("game:player1", {screen_name: screen_name});
  }

  join(channel) {
    channel.join()
      .receive("ok", response => {
         console.log("Joined successfully!");
       })
      .receive("error", response => {
         console.log("Unable to join");
       })
  }

  // DEPRECATED: join now covers this functionality
  // newGame(channel) {
  //   channel.push("new_game")
  //     .receive("ok", response => {
  //        console.log("New Game!");
  //      })
  //     .receive("error", response => {
  //        console.log("Unable to start a new game.");
  //      })
  // }

  addPlayer(channel, player) {
    channel.push("add_player", player)
      .receive("ok", response => {
         console.log("Player added!");
       })
      .receive("error", response => {
          console.log("Unable to add new player: " + player, response);
        })
  }

  handleClick(action) {
    const player1_channel = this.newChannel("player1");
    const player2_channel = this.newChannel("player2");

    if (action === "start-game") {
      this.setState({channel: player1_channel});
      this.setState({player: "player1"});
      this.join(player1_channel);
      // this.newGame(player1_channel);
    } else {
      this.setState({channel: player2_channel});
      this.setState({player: "player2"});
      this.join(player2_channel);
      this.addPlayer(player2_channel, "player2");
    }
    this.setState({isGameStarted: true})
  }

  renderGame(props) {
    const context = this;

    function dragStartHandler(event) {
      event.dataTransfer.setData("text/plain", event.target.id);
    }

    return (
      <div>
         <div id="holder">
           <img id="atoll" src="images/atoll.png" width="60" height="90" draggable="true" onDragStart={dragStartHandler} />
           <img id="dot" src="images/dot.png" width="30" height="30" draggable="true" onDragStart={dragStartHandler} />
           <img id="L" src="images/l_shape.png" width="60" height="90" draggable="true" onDragStart={dragStartHandler} />
           <img id="S" src="images/s_shape.png" width="90" height="60" draggable="true" onDragStart={dragStartHandler} />
           <img id="square" src="images/square.png" width="60" height="60" draggable="true" onDragStart={dragStartHandler} />
         </div>
        {<OwnBoard channel={context.state.channel} player={context.state.player} />}
        {<OpponentBoard channel={context.state.channel} player={context.state.player}/>}
      </div>
    )
  }

  render() {
    let contents;
    if (this.state.isGameStarted) {
      contents = this.renderGame();
    } else {
      contents = this.renderStartButtons();
    }

    return (
      <div>
        {contents}
      </div>
    )
  }
}

if (document.getElementById('islands')) {
  ReactDOM.render(
    <Game />,
    document.getElementById('islands')
  );
}
