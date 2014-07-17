/**
 * Created by angel777d on 31.05.2014.
 */
package ru.angelovich.as3.music.model {


import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

import ru.angelovich.as3.music.commands.GetStoredLibraryCommand;
import ru.angelovich.as3.music.commands.GetStoredPlayLists;
import ru.angelovich.as3.music.commands.ScanForMusicCommand;
import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.core.CoreConst;
import ru.angelovich.as3.p2p.modules.file.FileModule;
import ru.angelovich.as3.utils.LocalStorage;

[Bindable]
public class Model extends EventDispatcher {
    private static var _model:Model;

    public static function get instance():Model {
        if (_model) return _model;
        _model = new Model(checkFunction);
        return _model;
    }

    private static function checkFunction():void {
        //check singleton;
    }

    public function Model(check:Function) {
        if (checkFunction === check) {
            init();
        }
        else {
            throw new Error("it is f*ckng singleton!!!1111");
        }
    }
    private var _files:FileModule;
    private var _libraryCollection:ArrayCollection = new ArrayCollection();

    public function get fileModule():FileModule {
        return _files;
    }

    private var _currentPlayList:PlayList;
    public function get currentPlayList():PlayList {
        return _currentPlayList;
    }

    public function set currentPlayList(value:PlayList):void {
        _currentPlayList = value;
    }

    private var _currentItem:MusicLibraryItem;
    public function get currentItem():MusicLibraryItem {
        return _currentItem;
    }

    public function set currentItem(value:MusicLibraryItem):void {
        _currentItem = value;
        customStorage.currentItem = _currentItem.exportData();
    }

    private var _savedPlayLists:ArrayCollection = new ArrayCollection();
    public function get savedPlayLists():ArrayCollection {
        return _savedPlayLists;
    }

    public function set savedPlayLists(value:ArrayCollection):void {
        _savedPlayLists = value;
    }

    public function get allCollection():ArrayCollection {
        return _libraryCollection;
    }

    public function set allCollection(value:ArrayCollection):void {
        _libraryCollection = value;
    }

    private function get customStorage():Object {
        return LocalStorage.getStorageObject("customStorage");
    }

    public function loadLibrary():void {
        _libraryCollection.source = new GetStoredLibraryCommand().processCommand() as Array;
        _libraryCollection.refresh();
    }

    public function scanLibrary():void {
        _libraryCollection.source = new ScanForMusicCommand().processCommand() as Array;
        _libraryCollection.refresh();
    }

    public function loadPlayList():void {
        var result:Object = new GetStoredPlayLists().processCommand();
        currentItem = result.currentItem;
        currentPlayList = result.currentPlayList;
        savedPlayLists.source = result.savedPlayLists;
    }

    private function init() {
        _files = new FileModule(new Core().init(CoreConst.ADOBE_SERVER, CoreConst.ADOBE_KEY));
    }
}
}
