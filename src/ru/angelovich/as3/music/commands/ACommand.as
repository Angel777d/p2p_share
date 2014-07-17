/**
 * Created by angel777d on 08.06.2014.
 */
package ru.angelovich.as3.music.commands {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

public class ACommand extends EventDispatcher implements ICommand {

    public function ACommand(target:IEventDispatcher = null) {
        super(target);
    }
    protected var _params:Object;
    protected var _result:Object;

    public function processCommand():Object {
        return null;
    }

    public function setParameters(params:Object):ICommand {
        _params = params;
        return this;
    }

    public function getResult():Object {
        return _result;
    }

    protected function setResult(value:Object):Object {
        _result = value;
        dispatchEvent(new Event(Event.COMPLETE));
        return _result;
    }

}
}
