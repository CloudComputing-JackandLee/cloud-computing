import './Board.css';
import React, {ChangeEvent} from 'react';
import {elementState} from "./gameBoard";
import {Game, player} from './game';
import Dialog from './Dialog';
import io, {Socket} from "socket.io-client";


type User= {
    id:String;
    start:number;
}
type states= {
    showBoard:boolean,
    showButton:boolean,
    showForm:boolean,
    room:string,
    color:string
};
type prop= {

};

class Board extends React.Component<prop,states>{

    private myField:Game;
    private socket: Socket;

    private user: User;

    constructor(props:prop) {
        super(props);
        this.state ={
            showBoard:false,
            showButton:true,
            showForm:true,
            room:"1",
            color: '#ee5454'
        };

        this.socket = io('http://172.17.0.1:3001');
        //this.socket = io('http://localhost:3001');
        //this.socket = io('http://socket-server:3001');


        this.socket.on('connect',()=> console.log("connected with id: " + this.socket.id));


        this.user = {id:this.socket.id, start:1};
        this.myField = new Game();
        this.handleChange = this.handleChange.bind(this)


    }

    showRow(index:number){
        return <div id ="row"> {this.myField.getRow(index).map((value,localIndex)=>
            this.showElement(this.myField.getElement(index,localIndex),index,localIndex))}</div>;
    }
    showElement = (s :elementState, index1:number, index2:number) => {
        if (s === elementState.yellow) return <div id="yellow" > </div>;
        else if (s === elementState.red) return <div id="red" > </div>;
        else if (s === elementState.empty || !this.myField.yourTurn )return <div id="empty" style={{backgroundColor: 'aliceblue'}} >  </div>;
        else if (s === elementState.playable ){
            if (this.myField.yourTurn) return (
                <div id="playable"
                    onMouseLeave={this.changeBack}
                    onMouseEnter={this.changeBackground}
                    onClick={(e) => this.handleClick(e,index1,index2)}>
                </div>); //add button
            else return <div id="empty"> empty id[{index1},{index2} </div>;

            //red id[{index1},{index2}]
            //yellow id[{index1},{index2}]
            //empty id[{index1},{index2}]
            //playable id[{index1},{index2}]
        }
    }
    changeBackground =(e:any) =>{
        e.target.style.background = '#ee5d5d';
        //if(this.myField.currentPlayer === player.RED) e.target.style.background = '#ee5454'; //falls ich wieder ocal einbauen möchte
        //else e.target.style.background = '#f3f368';
    }
    changeBack = (e:any)=> {
        e.target.style.background = 'darkgrey';
    }
    changePlayerColorBack = (e:any) =>{
        if(this.myField.currentPlayer === player.RED) e.target.style.background = 'red';
    }

    handleClick = (e:any,index1:number, index2:number) => {

        this.myField.calculateTurn(index1,index2);

        this.changePlayerColorBack(e);
        this.forceUpdate();

        this.socket.emit("sendToken", this.state.room ,index1,index2);

    }

    componentDidMount() {
        //alle socketlisteners
        this.socket.on("receiveToken", ( row:number, col:number)=>{
            this.myField.handleNotMyTurn(row,col);

            setTimeout( ()=> {
                this.forceUpdate();
            }, 50);
        });

        //get starting pos
        this.socket.on("informTurn", (turn:number)=> {
            console.log("my start is "+ turn);
            if(turn === 1) {
                this.myField.yourTurn = true;
            }
            if(turn === 2) {
                this.myField.yourTurn = false;
            }
            this.forceUpdate();
        })
    }

    //WIP
    private handleChange(event:ChangeEvent<HTMLInputElement>) {
        this.setState({room : event.target.value});
        //console.log(this.state.room);
    }
    //WIP
    joinRoom = ()=>{
        this.socket.emit('joinRoom', this.state.room);
    }


    render(){
        let field = <div id="board" > {this.myField.field.map((value, index) => this.showRow(index))} </div>;

        let form = (
            <form  onSubmit={(e)=>{e.preventDefault();}}>
                <label>enter room <input placeholder='1' type="number"  onChange={this.handleChange} /></label>
            </form>
        );


        if (this.myField.hasWinner) return <Dialog player={this.myField.currentPlayer} />;

        else return [(
            <div id="text">
                { this.state.showForm && form }
                {this.state.showButton &&
                    (<button
                        onClick={() =>{
                            this.joinRoom();
                            this.setState({showBoard:true });
                            this.setState({showButton:false});
                            this.setState({showForm:false});
                        }}>
                        join the game
                    </button>)}
                { this.state.showBoard && field}
            </div>
        )];
    }
}

export default Board;
