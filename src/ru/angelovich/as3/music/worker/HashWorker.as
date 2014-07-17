/**
 * Created by angel777d on 13.06.2014.
 */
package ru.angelovich.as3.music.worker {
import com.adobe.crypto.MD5;

import flash.display.Sprite;
import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.registerClassAlias;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.utils.ByteArray;

public class HashWorker extends Sprite {
    public function HashWorker() {
        initialize();
    }
    private var commandChannel:MessageChannel;
    private var resultChannel:MessageChannel;

    private function initialize():void {
        registerClassAlias("model.MusicLibraryItem", MusicLibraryItem);

        commandChannel = Worker.current.getSharedProperty(HashWorkerConstants.COMMAND_CHANNEL_NAME) as MessageChannel;
        commandChannel.addEventListener(Event.CHANNEL_MESSAGE, handleCommandMessage);
        // These are for sending messages to the parent worker
        resultChannel = Worker.current.getSharedProperty(HashWorkerConstants.RESULT_CHANNEL_NAME) as MessageChannel;
    }

    private function createHashHandler(item:MusicLibraryItem):void {
        var file:File = new File().resolvePath(item.filepath);
        var fs:FileStream = new FileStream();
        fs.open(file, FileMode.READ);
        var ba:ByteArray = new ByteArray();
        var len:uint = file.size;
        const customLen:uint = 1024 * 1024;
        fs.readBytes(ba, 0, len > customLen ? customLen : len);
        fs.close();
        item.hash = MD5.hashBytes(ba);
        resultChannel.send([HashWorkerConstants.CREATE_HASH_RESULT, item]);
    }

    private function handleCommandMessage(event:Event):void {
        if (!commandChannel.messageAvailable) return;
        var message:Array = commandChannel.receive() as Array;
        if (!message) return;
        switch (message[0]) {
            case HashWorkerConstants.CREATE_HASH_COMMAND :
                createHashHandler(message[1] as MusicLibraryItem);
        }
    }

}
}
