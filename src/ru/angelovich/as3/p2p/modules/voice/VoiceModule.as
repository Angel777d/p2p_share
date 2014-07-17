/**
 * Created by Dmitry on 16.02.14.
 */
package ru.angelovich.as3.p2p.modules.voice {

import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.core.CoreMessage;
import ru.angelovich.as3.p2p.modules.AModule;

public class VoiceModule extends AModule {
    public static const NAME:String = "voiceModule"

    public function VoiceModule(core:Core) {
        super(core, NAME);
    }
    private var _currentRoom:VoiceRoom;

        private var _roomManager:RoomManager;;

public function get roomManager():RoomManager {
        return _roomManager
    }

    override protected function initialize():void {
        _roomManager = new RoomManager();
    }

    override protected function processMessage(message:CoreMessage):void {

    }

    public function create():VoiceRoom {
        return connect(roomManager.generateAddress(), "testRoom");
    }

    public function connect(address:String, name:String, save:Boolean = true):VoiceRoom {
        var room:VoiceRoom = roomManager.createRoom(core, address, name);
        if (_currentRoom) _currentRoom.close();
        _currentRoom = room;
        //room.publish(userManager.me.uid);
        return room;
    }
}
}
