/**
 * Created by angel777d on 31.05.2014.
 */
package ru.angelovich.as3.utils.air {
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.filesystem.File;

public class ScanFileSystem extends EventDispatcher {
    public function ScanFileSystem(target:IEventDispatcher = null) {
        super(target);
    }

    public function scanFiles(types:Array, folders : Array):Array {
        var result:Array = [];
        if (!folders) {
            folders = File.getRootDirectories();
            //folders.push(File.userDirectory);
            //folders.push(File.documentsDirectory);
        }
        searchRecursievly(folders, types, result);
        return result;
    }

    private function searchRecursievly(input:Array, types:Array, result:Array):void {
        for each (var file:File in input) {
            if (file.isHidden) continue;
            if (!file.isDirectory) checkFile(file, types, result);
            else searchRecursievly(file.getDirectoryListing(), types, result);
        }
    }

    private function checkFile(file:File, types:Array, result:Array):void {
        if (!file.type) return;
        if (types.indexOf(file.type.toLowerCase()) > -1) result.push(file);
    }
}
}
