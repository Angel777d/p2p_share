/**
 * Created by angel777d on 08.06.2014.
 */
package ru.angelovich.as3.music.commands {

import flash.events.IEventDispatcher;

import ru.angelovich.as3.music.model.MusicLibraryItem;
import ru.angelovich.as3.utils.LocalStorage;

public class GetStoredLibraryCommand extends ACommand {
    public function GetStoredLibraryCommand(target:IEventDispatcher = null) {
        super(target);
    }

    private function get storage():Object {
        return LocalStorage.getStorageObject("musicLibrary");
    }

    override public function processCommand():Object {
        var result:Array = [];
        for (var itemName:String in storage) {
            result.push(new MusicLibraryItem(storage[itemName]));
        }
        return setResult(result);
    }
}
}
