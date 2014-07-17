/**
 * Created by angel777d on 08.06.2014.
 */
package ru.angelovich.as3.music.commands {
import flash.events.IEventDispatcher;

public interface ICommand extends IEventDispatcher {
    function processCommand():Object;

    function setParameters(params:Object):ICommand;
}
}
