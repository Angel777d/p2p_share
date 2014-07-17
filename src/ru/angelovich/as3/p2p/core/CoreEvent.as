package ru.angelovich.as3.p2p.core {
import flash.events.Event;

public class CoreEvent extends Event {
    public static const READY:String = "ready";
    public static const MESSAGE:String = "message";
    public static const USER:String = "user";

    public function CoreEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
    }
    public var message:CoreMessage;
    public var user:CoreUser;
    public var action:String;
}
}