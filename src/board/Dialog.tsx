import React from 'react';
import {player} from "./game";

export default function Dialog(props: { player: player}) {
    //text variablen
    //variable with Button for new game


    switch (props.player){
        case player.YELLOW: return <div>YELLOW HAT DAS SPIEL GEWONNEN!</div>;
        case player.RED: return <div>RED HAT DAS SPIEL GEWONNEN!</div>;
    }
    return <div>error</div> ;
}