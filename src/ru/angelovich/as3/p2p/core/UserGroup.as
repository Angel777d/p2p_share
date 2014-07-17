/**
 * Created by Dmitry on 17.02.14.
 */
package ru.angelovich.as3.p2p.core {

import flash.events.NetStatusEvent;
import flash.net.NetGroup;

[Event(name="user", type="ru.angelovich.as3.p2p.core.CoreEvent")]
public class UserGroup extends NetGroup {

    private const MODULE_NAME:String = "internal::userGroup";

    public function UserGroup(core:Core, groupspec:String) {
        super(core.netConnection, groupspec);
        _core = core;
        _core.netConnection.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
        addEventListener(NetStatusEvent.NET_STATUS, onStatus);
    }
    private var _core:Core;
    private var _ready:Boolean = false;

    public function get userManager():UserManager {
        return UserManager.instance;
    }

    override public function close():void {
        _core = null;
        removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
        super.close();
    }

    public function sendResponse(inMessage:CoreMessage):void {
        trace("send response");
        _core.postMessage(getMessage(inMessage.from, "userResponse"), this);
    }

    private function sendRequest():void {
        _core.postMessage(getMessage(CoreMessage.DESTINATION_ALL, "userRequest"), this);
    }

    private function createMessage(message:CoreMessage, action:String = ""):void {
        var e:CoreEvent = new CoreEvent(CoreEvent.MESSAGE);
        e.message = message;
        e.action = action;
        dispatchEvent(e);
        onMessage(e);
    }

    private function getMessage(destination:String, type:String):CoreMessage {
        var message:CoreMessage = new CoreMessage();
        message.to = destination;
        message.module = MODULE_NAME;
        message.type = type;
        message.body = userManager.me;
        return message;
    }

    private function dispatchUserEvent(user:CoreUser, action:String):void {
        dispatchEvent(userManager.getUserEvent(user, action));
    }

    protected function onStatus(event:NetStatusEvent):void {
        trace("user:", event.info.code);
        var e:CoreEvent;
        var message:CoreMessage;
        switch (event.info.code) {
            case "NetGroup.Connect.Success":
                _core.netConnection.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
                break;
            case "NetGroup.Neighbor.Connect" :
                if (_ready) break;
                sendRequest();
                _ready = true;
                break;
            case "NetGroup.Posting.Notify" :
                createMessage(event.info.message as CoreMessage);
                break;
            case "NetGroup.SendTo.Notify":
                message = event.info.message as CoreMessage;
                if (event.info.fromLocal == true) createMessage(message);
                else sendToNearest(message, convertPeerIDToGroupAddress(message.to));
                break;
        }
    }

    private function onMessage(event:CoreEvent):void {
        trace("user:", "have message");
        if (event.message.module != MODULE_NAME) return;
        switch (event.message.type) {
            case "userRequest" :
                sendResponse(event.message);
                dispatchUserEvent(event.message.body as CoreUser, UserManager.ADD);
                break;
            case "userResponse" :
                dispatchUserEvent(event.message.body as CoreUser, UserManager.ADD);
                break;
        }
    }


}
}
