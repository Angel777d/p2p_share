/**
 * Created by Dmitry on 16.02.14.
 */
package ru.angelovich.as3.p2p.modules {

import flash.events.Event;
import flash.events.EventDispatcher;

import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.core.CoreEvent;
import ru.angelovich.as3.p2p.core.CoreMessage;
import ru.angelovich.as3.p2p.core.UserManager;

[Event(name="complete", type="flash.events.Event")]
public class AModule extends EventDispatcher {
    public function AModule(core:Core, name:String = "") {
        super();
        if (!core) throw  new Error("core must be not null", 1);
        _core = core;
        _moduleName = name;
        if (_core.ready) init();
        else _core.addEventListener(CoreEvent.READY, onReady);
    }

    private var _moduleName:String = "";

    public function get moduleName():String {
        return _moduleName;
    }

    private var _core:Core;

    protected function get core():Core {
        return _core;
    }

    protected function get userManager():UserManager {
        return UserManager.instance;
    }

    public function destroy():void {
        _core.removeEventListener(CoreEvent.MESSAGE, onMessage);
        _core = null;
    }

    protected function initialize():void {
        //for overrides
    }

    protected function processMessage(message:CoreMessage):void {
        //for overrides
    }

    private function init():void {
        _core.addEventListener(CoreEvent.MESSAGE, onMessage);
        initialize();
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onReady(event:CoreEvent):void {
        _core.removeEventListener(CoreEvent.READY, onReady);
        init();
    }

    private function onMessage(event:CoreEvent):void {
        processMessage(event.message);
    }

}
}
