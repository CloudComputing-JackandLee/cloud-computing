const io = require('socket.io')(3001, {
    cors: {
        origin:['http://localhost:80'],
        //origin:['http://localhost:3000'],

    },
})

let userAnzahl = 0;


io.on("connection", socket => {
    console.log(socket.id);

    socket.on("sendToken", (room, row,col)=>{
        console.log("triggered");

        socket.to(room).emit("receiveToken", row, col);
        //socket.broadcast.emit("receiveToken", row, col);
    })







    socket.on("joinRoom", (room)=> {
            socket.join(room);
            userAnzahl = io.sockets.adapter.rooms.get(room).size;
            console.log("user joined room "+ room+ "  position: "+ userAnzahl);
            socket.emit("informTurn", userAnzahl);
            // if room.size > 2 --> emit(staylockedlock) else --> join room inform user  
            
    })
    


})

