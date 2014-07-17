/**
 * Created by angel777d on 13.06.2014.
 */
package ru.angelovich.as3.music.model {
[Bindable]
public class PlayList extends StorableItem {
    public function PlayList(data:* = null) {
        super(data);
    }

    public function get id():String {
        return _data.id;
    }

    public function set id(value:String):void {
        _data.id = value;
    }

    public function get name():String {
        return _data.name;
    }

    public function set name(value:String):void {
        _data.name = value;
    }

    public function get items():Array {
        return _data.items;
    }

    public function set items(value:Array):void {
        _data.items = value;
    }

}
}
