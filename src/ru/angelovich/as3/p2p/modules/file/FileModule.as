/**
 * Created by angel777d on 08.06.2014.
 */
package ru.angelovich.as3.p2p.modules.file {

import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.core.CoreMessage;
import ru.angelovich.as3.p2p.modules.AModule;

public class FileModule extends AModule {
    private var sharedItems : Object = {};
    private var pendingItems : Array = [];
    public function FileModule(core:Core, name:String = "") {
        super(core, name);
    }

    override protected function initialize():void {
        for each (var share : IShareble in pendingItems) {
            addShare(share);
        }
        pendingItems = null;
    }

    override protected function processMessage(message:CoreMessage):void {
        //don't need it here now
    }

    /**
     * Add share for upload or download
     * @param share
     */
    public function addShare(share:IShareble):void {
        if (sharedItems[share.id]) return;
        if (core.ready)
            sharedItems[share.id] = new ShareItem(core,share);
        else
            pendingItems.push(share);
    }

    public function removeShare(shareId : String):void {
        var share : ShareItem = sharedItems[shareId];
        if (share) {
            share.close();
            delete sharedItems[shareId];
        }
    }
}
}
