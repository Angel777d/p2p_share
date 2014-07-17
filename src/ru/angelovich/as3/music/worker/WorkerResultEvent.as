/**
 * Created by angel777d on 13.06.2014.
 */
package ru.angelovich.as3.music.worker {
import flash.events.Event;

public class WorkerResultEvent extends Event {

    public static const WORKER_RESULT_EVENT:String = "workerResultEvent"

    public function WorkerResultEvent(complete:Boolean, data:Object) {
        super(WORKER_RESULT_EVENT, false, false);
        this.complete = complete;
        this.data = data;
    }
    public var complete:Boolean = false;
    public var data:Object;
}
}
