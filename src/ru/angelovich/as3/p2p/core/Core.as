package ru.angelovich.as3.p2p.core {
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.NetStatusEvent;
import flash.net.GroupSpecifier;
import flash.net.NetConnection;
import flash.net.NetGroup;

[Event(name="ready", type="ru.angelovich.as3.p2p.core.CoreEvent")]
[Event(name="message", type="ru.angelovich.as3.p2p.core.CoreEvent")]
public class Core extends EventDispatcher {
    public function Core(target:IEventDispatcher = null) {
        super(target);
    }
    private var _nc:NetConnection;
    private var _ng:NetGroup;
    private var _postUniqCounter:uint = 0;

    private var _ready:Boolean = false;

    public function get ready():Boolean {
        return _ready;
    }

    public function get netConnection():NetConnection {
        return _nc;
    }

    public function init(server:String, devKey:String):Core {
        _nc = new NetConnection();
        _nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
        _nc.connect(server + "/" + devKey);
        return this;
    }

    public function postMessage(message:CoreMessage, group:NetGroup = null):void {
        var targetGroup:NetGroup = group ? group : _ng;
        message.postId = _postUniqCounter++;
        message.from = _nc.nearID;
        if (message.to == CoreMessage.DESTINATION_ALL) {
            var r:* = targetGroup.post(message);
            trace("post all");
        }
        else if (message.to == CoreMessage.DESTINATION_LOCAL) {
            dispatchMessage(message);
            trace("post local");
        }
        else {
            targetGroup.sendToNearest(message, targetGroup.convertPeerIDToGroupAddress(message.to));
            trace("post direct");
        }
    }

    public function postAction(message:CoreMessage, action:String):void {
        dispatchMessage(message, action);
    }

    private function dispatchMessage(message:CoreMessage, action:String = ""):void {
        var e:CoreEvent = new CoreEvent(CoreEvent.MESSAGE);
        e.message = message;
        e.action = action;
        dispatchEvent(e);
        trace("message dispatched");
    }

    private function createGroupSpec(name:String):GroupSpecifier {
        var spec:GroupSpecifier = new GroupSpecifier(CoreConst.TOP_NAME + name);
        spec.postingEnabled = true;
        spec.serverChannelEnabled = true;
        spec.routingEnabled = true;
        return spec;
    }

    private function createMainGroup():void {
        _ng = new NetGroup(_nc, createGroupSpec(CoreConst.TOP_NAME + ".maingroup").groupspecWithAuthorizations());
        _ng.addEventListener(CoreEvent.MESSAGE, onGroupMessage);
    }

    protected function onStatus(event:NetStatusEvent):void {
        trace("core:", event.info.code);
        var e:CoreEvent;
        var message:CoreMessage;
        switch (event.info.code) {
            case "NetConnection.Connect.Success" :
                _ready = true;
                createMainGroup();
                return;
            case "NetGroup.Connect.Success" :
                if (event.info.group == _ng) {
                    dispatchEvent(new CoreEvent("ready"));
                }
                break;
        }
    }

    private function onGroupMessage(event:CoreEvent):void {
        dispatchMessage(event.message);
    }


}
}