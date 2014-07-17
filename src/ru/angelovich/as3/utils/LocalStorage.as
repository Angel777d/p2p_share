/**
 * Created by Dmitry on 16.02.14.
 */
package ru.angelovich.as3.utils {

import flash.net.SharedObject;

public class LocalStorage {
    private static var _storages:Object = {};

    public static function getStorageObject(name:String):Object {
        return getSharedObject(name).data;
    }

    public static function save(name:String):void {
        if (!_storages[name]) return;
        (_storages[name] as SharedObject).flush();
    }

    private static function getSharedObject(name:String):SharedObject {
        if (!_storages[name]) {
            _storages[name] = SharedObject.getLocal(name);
        }
        return _storages[name];
    }
}
}
