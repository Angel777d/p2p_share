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

    public function scanFor(type:String):Array {
        var files:Array = File.getRootDirectories();
        files.push(File.userDirectory);
        files.push(File.documentsDirectory);
        var result:Array = [];
        searchRecursievly(files, type, result);
        return result;
    }

    private function searchRecursievly(input:Array, type:String, result:Array):void {
        for each (var file:File in input) {
            if (file.isHidden) continue;
            if (!file.isDirectory) checkFile(file, type, result);
            else searchRecursievly(file.getDirectoryListing(), type, result);
        }
    }

    private function checkFile(file:File, type:String, result:Array):void {
        if (file.type == type) result.push(file);
    }
}
}
