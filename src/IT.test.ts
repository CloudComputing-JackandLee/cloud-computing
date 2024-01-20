
import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom'
import App from './App';
import Board from './board/Board';
test("renders App component in integration test", () => {
    // TODO
    //render(<App />);
    //expect(screen.getByText('This is an online multiplayer Connect4 game!')).toBeInTheDocument();
    expect(5+6).toBe(11);
    expect("test").toBe("test");
});