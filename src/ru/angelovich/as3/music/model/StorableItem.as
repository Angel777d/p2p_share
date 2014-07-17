/**
 * Created by angel777d on 13.06.2014.
 */
package ru.angelovich.as3.music.model {
public class StorableItem {

    public function StorableItem(data:* = null) {
        if (data is String)
            importData(data);
        else
            _data = data;
    }
    protected var _data:Object;

    public function importData(json:String):void {
        _data = JSON.parse(json);
    }

    public function exportData():String {
        return JSON.stringify(_data);
    }

}
}
