/**
 * Created by angel777d on 27.07.2014.
 */
package ru.angelovich.as3.p2p.modules.file {
import flash.events.EventDispatcher;
import flash.events.NetStatusEvent;
import flash.geom.Point;
import flash.net.GroupSpecifier;
import flash.net.NetGroup;
import flash.net.NetGroupReplicationStrategy;

import ru.angelovich.as3.p2p.core.Core;

public class ShareItem extends EventDispatcher {
    private var core : Core;
    private var share : IShareble;
    private var group : NetGroup;
    public function ShareItem(core : Core, share : IShareble) {
        super();
        this.core = core;
        this.share = share;
        init();
    }

    public function close() : void {
        group.close();
        group.removeEventListener(NetStatusEvent.NET_STATUS,onSatatus);
        group = null;

        core.removeEventListener(NetStatusEvent.NET_STATUS,onSatatus);
        core = null;
        share = null;
    }

    private function init() : void {
        var spec:GroupSpecifier = new GroupSpecifier("share::" + share.id);
        spec.serverChannelEnabled = true;
        spec.objectReplicationEnabled = true;
        group = new NetGroup(core.netConnection, spec.groupspecWithAuthorizations());

        core.addEventListener(NetStatusEvent.NET_STATUS,onSatatus);
        group.addEventListener(NetStatusEvent.NET_STATUS,onSatatus);
    }

    private function initHave() : void {
        if (share.complete){
            group.addHaveObjects(0,share.parts-1);
        }
        else{
            var startIndex : int = -1;
            for (var i : int = 0; i < share.parts; i++) {
                if (share.havePart(i)) {
                    if (startIndex < 0) startIndex = i;
                }
                else {
                    if (startIndex > -1) {
                        group.addHaveObjects(startIndex, i-1);
                        startIndex = -1;
                    }
                }
            }
            if (startIndex > -1) {
                group.addHaveObjects(startIndex, i);
            }
        }
    }

    private function initWant() : void {
        if (share.complete) return;

        var startIndex : int = -1;
        for (var i : int = 0; i < share.parts; i++) {
            if (!share.havePart(i)) {
                if (startIndex < 0) startIndex = i;
            }
            else {
                if (startIndex > -1) {
                    group.addWantObjects(startIndex, i-1);
                    startIndex = -1;
                }
            }
        }
        if (startIndex > -1) {
            group.addWantObjects(startIndex, i);
        }

    }

    private function onSatatus(event:NetStatusEvent):void {
        switch(event.info.code) {
            case "NetGroup.Connect.Success" :
                core.removeEventListener(NetStatusEvent.NET_STATUS, onSatatus);
                group.replicationStrategy = NetGroupReplicationStrategy.LOWEST_FIRST;
                break;
            case "NetGroup.Replication.Fetch.SendNotify": // e.info.index
                trace("____ index: "+event.info.index);
                break;
            case "NetGroup.Replication.Fetch.Failed": // e.info.index
                trace("FAIL ____ index: "+event.info.index);
                break;
            case "NetGroup.Replication.Fetch.Result": // e.info.index, e.info.object
                trace("INFO ___ ")
                share.setPart(event.info.index, event.info.object);
                group.addHaveObjects(event.info.index,event.info.index);
                break;
            case "NetGroup.Replication.Request": // e.info.index, e.info.requestID
                group.writeRequestedObject(event.info.requestID,share.getPart(event.info.index));
                break;

        }
    }
}
}
