import '@testing-library/jest-dom';
import {Game, player} from "./board/game";
import {elementState} from "./board/gameBoard";

let game = new Game();

let testField =
    [
        [elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
        [elementState.yellow,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
        [elementState.yellow,elementState.yellow,elementState.empty,elementState.empty,elementState.empty,elementState.empty,elementState.empty],
        [elementState.yellow,elementState.empty,elementState.yellow,elementState.red,elementState.empty,elementState.empty,elementState.empty],
        [elementState.yellow,elementState.empty,elementState.red,elementState.yellow,elementState.empty,elementState.empty,elementState.empty],
        [elementState.red,elementState.red,elementState.red,elementState.red,elementState.red,elementState.playable,elementState.playable]
    ]

game.field = testField;
game.currentPlayer = player.YELLOW;

test("vertical:", () => {
    game.currentPlayer = player.YELLOW;
    expect(game.checkWinnerVertical(1,0)).toBe(true);
});

test("horizontal:", () => {
    game.currentPlayer = player.RED;
    expect(game.checkWinnerHorizontal(5,1)).toBe(true);
});
test("horizontal Right:", () => {
    game.currentPlayer = player.RED;
    expect(game.checkRight(5,1)).toBe(4);
});
test("horizontal Left:", () => {
    game.currentPlayer = player.RED;
    expect(game.checkRight(5,1)).toBe(4);
});

test("Diagonal right going up:", () => {
    game.currentPlayer = player.RED;
    expect(game.checkRightDiagUp(5,1)).toBe(3);
});
test("Diagonal left going up:", () => {
    game.currentPlayer = player.RED;
    expect(game.checkLeftDiagUp(3,3)).toBe(2);
});
test("Diagonal winner up:", () => {
    game.setFieldElement(elementState.red, 2,4);
    game.currentPlayer = player.RED;
    expect(game.checkWinnerDiagonalUp(3,3)).toBe(true);
});

test("Diagonal right going down:", () => {
    game.currentPlayer = player.YELLOW;
    expect(game.checkRightDiagDown(1,0)).toBe(4);
});
test("Diagonal left going down:", () => {
    game.currentPlayer = player.YELLOW;
    expect(game.checkLeftDiagDown(3,2)).toBe(2);
});
test("Diagonal winner going down:", () => {
    game.currentPlayer = player.YELLOW;
    expect(game.checkWinnerDiagonalDown(3,2)).toBe(true);
});

test("element state --> player:", () => {
    expect(game.elementStateToPlayer(elementState.red)).toBe(player.RED);
});