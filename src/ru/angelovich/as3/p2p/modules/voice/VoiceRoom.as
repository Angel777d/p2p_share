/**
 * Created by Dmitry on 16.02.14.
 */
package ru.angelovich.as3.p2p.modules.voice {

import flash.net.GroupSpecifier;
import flash.net.NetStream;

import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.core.CoreEvent;
import ru.angelovich.as3.p2p.core.UserGroup;
import ru.angelovich.as3.p2p.core.UserManager;

[Event(name="complete", type="flash.events.Event")]
public class VoiceRoom {
    public var name:String;
    public var address:String;

    private var _out:OutStream
    private var _core:Core;
    private var _ng:UserGroup;

    private var _groupSpec:GroupSpecifier;
    private var _inStreams:Array = [];

    private function get gs():GroupSpecifier {
        if (_groupSpec) return _groupSpec;
        _groupSpec = new GroupSpecifier(address);
        _groupSpec.peerToPeerDisabled = false;
        _groupSpec.serverChannelEnabled = true;
        _groupSpec.ipMulticastMemberUpdatesEnabled = true;
        _groupSpec.multicastEnabled = true;
        _groupSpec.postingEnabled = true;
        return _groupSpec;
    }

    public function connect(core:Core):void {
        _core = core;
        _ng = _core.createNetGroup(address, gs);
        _ng.addEventListener(CoreEvent.USER, onUser);
        _out = new OutStream(UserManager.instance.me.uid, _core.netConnection, gs.groupspecWithAuthorizations());
    }

    public function close():void {
        _ng.removeEventListener(CoreEvent.USER, onUser);
        _ng.close();
        _out.close();
        for each (var inStream:NetStream in  _inStreams) {
            inStream.close();
        }
    }

    private function play(uid:String):NetStream {
        var inStream:InStream = new InStream(uid, _core.netConnection, gs.groupspecWithAuthorizations());
        _inStreams.push(inStream);
        return inStream;
    }

    private function onUser(event:CoreEvent):void {
        switch (event.action) {
            case "add" :
                play(event.user.uid);
                break;
            case "remove" :
                break;
            case "update" :
                break;
        }
    }
}
}
