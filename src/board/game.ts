import {elementState, gameField} from "./gameBoard";

export enum player {
    RED,
    YELLOW,
    NOTHING
}

export class Game extends gameField {
    private _turn:number;
    private _currentPlayer:player;
    private _hasWinner:boolean;
    private _yourTurn:boolean;

    get yourTurn(): boolean {
        return this._yourTurn;
    }

    set yourTurn(value: boolean) {
        this._yourTurn = value;
    }

    get hasWinner(): boolean {
        return this._hasWinner;
    }

    set hasWinner(value: boolean) {
        this._hasWinner = value;
    }

    get currentPlayer(): player {
        return this._currentPlayer;
    }
    set currentPlayer(value: player) {
        this._currentPlayer = value;
    }
    get turn(): number {
        return this._turn;
    }
    turnIncrement() {
        this._turn++;
    }
    elementStateToPlayer(e : elementState):player{
        if (e === elementState.yellow) return player.YELLOW;
        if (e === elementState.red) return player.RED;
        else return player.NOTHING;
    }

    //checing winner
    // horizontal checking
    checkRight(row:number, start:number):number{
        let same:number = 0;

        for (let next:number = start; next < 7; next++) {
            if (this.elementStateToPlayer(this.field[row][next]) === this._currentPlayer) {
                same++;
            } else {
                //console.log("R " + same);
                return same;
            }
        }
        return same;

    }
    checkLeft(row:number, start:number):number{
        let same:number = 0;

        for (let next:number = start-1; next >= 0; next--) {
            if (this.elementStateToPlayer(this.field[row][next]) === this._currentPlayer) {
                same++;
            } else {
                //console.log("L " + same);
                return same;
            }
        }
        return same;

    }
    checkWinnerHorizontal(row:number, start:number) :boolean {
        let sameInARow:number = this.checkLeft(row,start) +this.checkRight(row,start);
        //console.log(sameInARow);
        if(sameInARow >= 4) {
            return true;
        }
        return false;
    }

    //vertical checking
    checkWinnerVertical(start:number, col:number):boolean{
        let same:number = 0;
        for (let next:number = start; next < 6; next++) {
            if (this.elementStateToPlayer(this.field[next][col]) === this._currentPlayer) {
                same++;
                if (same >= 4){
                    return true;
                }
            }else {
                if(start === 0 && same >= 4){
                    return true;
                }
                return false;
            }
        }
        return false;
    }

    //check diagonal
    //check diag up
    checkRightDiagUp(row:number, col:number):number{
        let same:number = 0;

        for (let next:number = col; next < 7; next++) {
            if (this.elementStateToPlayer(this.field[row][next]) === this._currentPlayer) {
                same++;
            } else {
                //console.log("R " + same);
                return same;
            }

            if (row >0)row--;
            else return same;
        }
        //console.log("R " + same);
        return same;

    }
    checkLeftDiagUp(r:number, c:number):number{
        let same:number = -1;

        for (let row = r, col = c; row < 6 && col >= 0;  row++, col--){
            if (this.elementStateToPlayer(this.field[row][col]) === this._currentPlayer) {
                same++;
            } else {
                //console.log("R " + same);
                return same;
            }
        }

        //console.log("R " + same);
        return same;
    }
    checkWinnerDiagonalUp(row:number, col:number) :boolean {
        let sameInARow:number = this.checkRightDiagUp(row,col) + this.checkLeftDiagUp(row,col);
        //console.log(sameInARow);
        if(sameInARow >= 4) {

            return true;
        }
        return false;
    }

    //check diag down
    checkRightDiagDown(r:number, c:number):number{
        let same:number = 0;

        for (let row = r, col = c; row < 6 && col < 7;  row++, col++){
            if (this.elementStateToPlayer(this.field[row][col]) === this._currentPlayer) {
                same++;
            } else {
                //console.log("R " + same);
                return same;
            }
        }
        //console.log("R " + same);
        return same;
    }
    checkLeftDiagDown(r:number, c:number):number{
        let same:number = -1;

        for (let row = r, col = c; row >=0 && col >= 0;  row--, col--){
            if (this.elementStateToPlayer(this.field[row][col]) === this._currentPlayer) {
                same++;
            } else {
                //console.log("L " + same);
                return same;
            }
        }
        //console.log("L " + same);
        return same;
    }
    checkWinnerDiagonalDown(row:number, col:number) :boolean {
        let sameInARow:number = this.checkRightDiagDown(row,col) + this.checkLeftDiagDown(row,col);
        //console.log(sameInARow);
        if(sameInARow >= 4) {

            return true;
        }
        return false;
    }

    //check winner
    checkWinner(row:number, col:number):boolean{
        if (this.checkWinnerHorizontal(row, col)
            || this.checkWinnerVertical(row,col)
            || this.checkWinnerDiagonalUp(row,col)
            || this.checkWinnerDiagonalDown(row,col)
        ){
            return true;
        }
        else return false;
    }


    //help functions
     calculateTurn(index1:number, index2:number):void{
        this.currentPlayer = player.RED;

        this.setFieldElement(elementState.red, index1, index2);

        if(this.checkWinner(index1,index2)){
            this.hasWinner = true;
            console.log("winner bin ICH" + this.currentPlayer);
        }
        //if(this.currentPlayer===player.RED) this.currentPlayer = player.YELLOW; //falls ich local wieder implemente
        //else this.currentPlayer = player.RED;

        if(index1 !== 0) this.setFieldElement(elementState.playable,--index1,index2);

        this.turnIncrement();
        this.yourTurn = false;
    }


    handleNotMyTurn= ( row:number, col:number)=>{
        this.currentPlayer = player.YELLOW
        this.setFieldElement(elementState.yellow, row, col);

        if(this.checkWinner(row, col)){
            this.hasWinner = true;
            console.log("winner ist der GEGNER " + this.currentPlayer);
        }
        //if(this.currentPlayer===player.RED) this.currentPlayer = player.YELLOW;
        //else this.currentPlayer = player.RED;

        if(row !== 0) this.setFieldElement(elementState.playable,--row,col);

        this.turnIncrement();
        this.yourTurn = true;

    }


    constructor() {
        super();
        this._turn = 1;
        this._currentPlayer = player.RED;
        this._hasWinner = false;
        this._yourTurn = true;
    }
}