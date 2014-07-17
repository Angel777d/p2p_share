/**
 * Created by Dmitry on 16.02.14.
 */
package ru.angelovich.as3.p2p.modules.voice {

import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.utils.LocalStorage;

public class RoomManager {
    public function RoomManager() {
    }

    public function get rooms():Object {
        return LocalStorage.getStorageObject("rooms");
    }

    public function createRoom(core:Core, address:String, name:String):VoiceRoom {
        var room:VoiceRoom = new VoiceRoom();
        room.address = address;
        room.name = address.split(":")[0];
        room.connect(core);
        return room;
    }

    public function generateAddress():String {
        var result:String = "room:" + new Date().getTime().toFixed() + ":" + Math.round(1000000000 * Math.random());
        return result;
    }

    public function saveRoom(room:VoiceRoom):void {
        LocalStorage.getStorageObject("rooms")[room.address] = room;
    }
}
}
