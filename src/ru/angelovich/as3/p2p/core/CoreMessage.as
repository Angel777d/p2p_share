package ru.angelovich.as3.p2p.core {

[RemoteClass]
public class CoreMessage {
    public static const DESTINATION_ALL:String = "all";
    public static const DESTINATION_LOCAL:String = "local";


    public function CoreMessage() {
    }

    public var module:String = "";
    public var from:String = DESTINATION_LOCAL;
    public var type:String = "";

    public var to:String = DESTINATION_LOCAL;
    public var body:Object = {};
    public var user:Object;
    public var postId:uint = 0; //for message uniq
}
}