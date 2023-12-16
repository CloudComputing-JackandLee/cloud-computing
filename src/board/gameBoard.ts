


export enum elementState{
    empty,
    playable,
    yellow,
    red
}
export class  gameField {
    private _field: elementState[][];

    get field(): elementState[][] {
        return this._field;
    }


    set field(value: elementState[][]) {
        this._field = value;
    }

    getRow(index:number): elementState[]   {
        return this.field[index];
    }
    
    getElement(index1:number, index2:number): elementState  {
        return this.field[index1][index2];
    }
    setFieldElement(value: elementState, i1:number, i2 :number) {
        this._field[i1][i2] = value;
    }



    constructor() {
        this._field = [[elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
            [elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
            [elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
            [elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
            [elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
            [elementState.playable,elementState.playable,elementState.playable,elementState.playable,elementState.playable,elementState.playable,elementState.playable]
        ];
    }
}
