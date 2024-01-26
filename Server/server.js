
const io = require('socket.io')(3001, {
    cors: {
        origin:'*'
/*
        origin:["*", "http://ecs-lb-1932788872.us-east-1.elb.amazonaws.com" , 'http://react-app:80', "http://172.17.0.1", "http://172.17.0.1:80" ,'http://react-app' ,'http://localhost:3000','http://localhost:80','http://localhost', 'http://localhost:3001'],
*/

    },
})

//test
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

