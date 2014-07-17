/**
 * Created by angel777d on 08.06.2014.
 */
package ru.angelovich.as3.music.commands {

import flash.events.IEventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import ru.angelovich.as3.utils.LocalStorage;
import ru.angelovich.as3.music.model.MusicLibraryItem;

import ru.angelovich.as3.utils.air.ScanFileSystem;

public class ScanForMusicCommand extends ACommand {
    public function ScanForMusicCommand(target:IEventDispatcher = null) {
        super(target);
    }

    private function get storage():Object {
        return LocalStorage.getStorageObject("musicLibrary");
    }

    override public function processCommand():Object {
        var scanner:ScanFileSystem = new ScanFileSystem();
        return setResult(processFiles(scanner.scanFor(".mp3")));
    }

    private function processFiles(files:Array):Array {
        var result:Array = [];
        for each (var file:File in files) {
            result.push(fileToLibraryItem(file));
        }
        removeOldItems();
        save();
        return result;
    }

    private function fileToLibraryItem(file:File):MusicLibraryItem {
        var libItem:MusicLibraryItem = new MusicLibraryItem();

        if (storage[file.nativePath])
            return new MusicLibraryItem(storage[file.nativePath]);

        var fileStr:FileStream = new FileStream();

        fileStr.open(file, FileMode.READ);
        fileStr.position = file.size - 128;

        if (fileStr.readMultiByte(3, "iso-8859-1").match(/tag/i)) {
            libItem.id3Title = fileStr.readMultiByte(30, "iso-8859-1");
            libItem.id3Artist = fileStr.readMultiByte(30, "iso-8859-1");
            libItem.id3Album = fileStr.readMultiByte(30, "iso-8859-1");
            libItem.id3Year = fileStr.readMultiByte(4, "iso-8859-1");
            libItem.id3Comment = fileStr.readMultiByte(30, "iso-8859-1");
            libItem.id3GenreCode = fileStr.readByte().toString(10);
        }
        libItem.filename = file.name;
        libItem.filepath = file.nativePath;
        libItem.filetype = file.type;

        storage[file.nativePath] = libItem.exportData();
        return libItem;
    }

    private function removeOldItems():void {
        //TODO clear records if there are no file
    }

    private function save():void {
        LocalStorage.save("musicLibrary");
    }


}
}
