/**
 * Created by angel777d on 13.06.2014.
 */
package ru.angelovich.as3.music.commands {
import flash.events.IEventDispatcher;

import ru.angelovich.as3.music.model.MusicLibraryItem;
import ru.angelovich.as3.music.model.PlayList;
import ru.angelovich.as3.utils.LocalStorage;

public class GetStoredPlayLists extends ACommand {
    public function GetStoredPlayLists(target:IEventDispatcher = null) {
        super(target);
    }

    private function get storage():Object {
        return LocalStorage.getStorageObject("playLists");
    }

    private function get customStorage():Object {
        return LocalStorage.getStorageObject("customStorage");
    }

    override public function processCommand():Object {
        var result:Array = [];
        for (var itemName:String in storage) {
            result.push(new PlayList(storage[itemName]));
        }
        return setResult({savedPlayLists: result, currentPlayList: new PlayList(customStorage.playList), currentItem: new MusicLibraryItem(customStorage.currentItem)});
    }
}
}
