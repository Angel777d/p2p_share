/**
 * Created by angel777d on 13.06.2014.
 */
package ru.angelovich.as3.music.worker {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.system.WorkerDomain;

import ru.angelovich.as3.music.model.MusicLibraryItem;

public class HashWorkerController extends EventDispatcher {

    private static var _instance:HashWorkerController = new HashWorkerController();

    public static function get dispatcher():IEventDispatcher {
        return _instance;
    }

    public static function createHash(item:MusicLibraryItem):void {
        _instance.createHash(item);
    }

    public function HashWorkerController() {
        if (_instance) throw new Error("Singleton");
        _instance = this;
        init();
    }
    [Embed(source="HashWorker.swf", mimeType="application/octet-stream")]
    private var WorkerClass:Class;
    private var _worker:Worker;
    private var _commandChannel:MessageChannel;
    private var _resultChannel:MessageChannel;

    private function init():void {
        _worker = WorkerDomain.current.createWorker(new WorkerClass());


        _commandChannel = Worker.current.createMessageChannel(_worker);
        _worker.setSharedProperty(HashWorkerConstants.COMMAND_CHANNEL_NAME, _commandChannel);

        _resultChannel = _worker.createMessageChannel(Worker.current);
        _resultChannel.addEventListener(Event.CHANNEL_MESSAGE, handleResultMessage);
        _worker.setSharedProperty(HashWorkerConstants.RESULT_CHANNEL_NAME, _resultChannel);

        // Start the worker
        _worker.addEventListener(Event.WORKER_STATE, handleWorkerState);
        _worker.start();

    }

    private function createHash(item:MusicLibraryItem):void {
        _commandChannel.send([HashWorkerConstants.CREATE_HASH_COMMAND, item])
    }

    private function handleHashResult(item:MusicLibraryItem):void {
        dispatchEvent(new WorkerResultEvent(item != null, item));
    }

    private function handleResultMessage(event:Event):void {
        if (!_resultChannel.messageAvailable) return;
        var message:Array = _resultChannel.receive() as Array;
        if (!message) return;
        switch (message[0]) {
            case HashWorkerConstants.CREATE_HASH_RESULT :
                handleHashResult(message[1] as MusicLibraryItem);
                break;
        }
    }

    private function handleWorkerState(event:Event):void {
        trace(event);
    }


}
}
