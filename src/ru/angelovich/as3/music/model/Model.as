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
import ru.angelovich.as3.p2p.modules.search.ASearchModule;
import ru.angelovich.as3.utils.LocalStorage;

[Bindable]
public class Model extends EventDispatcher {
    private static var _model:Model = new Model();

    public static function get instance():Model {
        return _model;
    }

    public function Model() {
        if (_model) {
            throw new Error("it is f*ckng singleton!!!1111");
        }
        init();
    }

    private var files:FileModule;
    private var search:ASearchModule;
    private var libraryCollection:ArrayCollection = new ArrayCollection();

    public function get fileModule():FileModule {
        return files;
    }

    public function get searchModule():ASearchModule {
        return search;
    }

    public function get musicLibrary() : ArrayCollection {
        return libraryCollection;
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

    private function get customStorage():Object {
        return LocalStorage.getStorageObject("customStorage");
    }

    public function loadLibrary():void {
        libraryCollection.source = new GetStoredLibraryCommand().processCommand() as Array;
        libraryCollection.refresh();
    }

    public function scanLibrary(sources:Array):void {
        libraryCollection.source = new ScanForMusicCommand().setParameters(sources).processCommand() as Array;
        libraryCollection.refresh();
    }

    public function loadPlayList():void {
        var result:Object = new GetStoredPlayLists().processCommand();
        currentItem = result.currentItem;
        currentPlayList = result.currentPlayList;
        savedPlayLists.source = result.savedPlayLists;
    }

    private function init():void {
        var core:Core = new Core().init(CoreConst.ADOBE_SERVER, CoreConst.ADOBE_KEY);
        files = new FileModule(core);
        search = new SearchMusicModule(core);
    }
}
}
