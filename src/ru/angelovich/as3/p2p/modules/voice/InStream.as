/**
 * Created by Dmitry on 22.02.14.
 */
package ru.angelovich.as3.p2p.modules.voice {

import flash.events.NetStatusEvent;
import flash.media.Microphone;
import flash.net.NetConnection;
import flash.net.NetStream;

public class InStream extends NetStream {

    public function InStream(streamName:String, connection:NetConnection, peerID:String = "connectToFMS") {
        super(connection, peerID);
        _streamName = streamName;
        _connection = connection;
        _connection.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
        addEventListener(NetStatusEvent.NET_STATUS, onStatus);
    }
    private var _connection:NetConnection;
    private var _streamName:String;

    private function onStatus(event:NetStatusEvent):void {
        trace("in stream:", event.info.code);
        switch (event.info.code) {
            case "NetStream.Connect.Success" :
                if (event.info.stream != this) break;
                _connection.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);

                var mic:Microphone = Microphone.getMicrophone();
                play(_streamName);

                break;
        }
    }
}
}
