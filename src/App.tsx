import React, {useState} from 'react';

import './App.css';

import Board from "./board/Board";




function App() {
    const [showBoard, setShowBoard] = useState(false);
    const [showButton, setShowButton] = useState(true);


    return (
        <div id="app"> This is an online multiplayer Connect4 game!
            {showButton &&
                (<button
                onClick={() =>{ setShowBoard(true);setShowButton(false)}}>
                start game
            </button>)}
            { showBoard && (<Board/>) }

        </div>
    );
}

export default App;
