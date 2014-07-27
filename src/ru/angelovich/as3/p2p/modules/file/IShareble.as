/**
 * Created by angel777d on 27.07.2014.
 */
package ru.angelovich.as3.p2p.modules.file {
import flash.events.IEventDispatcher;
import flash.utils.ByteArray;

public interface IShareble extends IEventDispatcher{
    function havePart(partId : int)  : Boolean;
    function getPart(partId : int) : ByteArray;
    function setPart(partId : int, value : ByteArray) : void;
    function get complete() : Boolean;
    function get id() : String;
    function get parts() : int;
    function get partSize() : int;
    function get lastPartSize() : int;
}
}
