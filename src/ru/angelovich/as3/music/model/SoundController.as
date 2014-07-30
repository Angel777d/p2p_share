/**
 * Created by angel777d on 13.06.2014.
 */
package ru.angelovich.as3.music.model {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.filesystem.File;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

public class SoundController {
    private static var _sound:Sound;
    private static var _channel:SoundChannel;

    private static var _currentPosition:int = 0;

    public static function get currentPosition():int {
        if (!_channel) return _currentPosition;
        return _channel.position;
    }

    private static var _dispatcher:IEventDispatcher = new EventDispatcher();

    public static function get dispatcher():IEventDispatcher {
        return _dispatcher;
    }

    public static function get length():int {
        if (!_sound) return 0;
        return _sound.length / (_sound.bytesLoaded / _sound.bytesTotal);
    }

    public static function get isPlaying():Boolean {
        return _channel != null;
    }

    public static function setSource(source:MusicLibraryItem):void {
        clear();
        var file:File = new File().resolvePath(source.filepath);
        if (!file.exists) return;
        _sound = new Sound(new URLRequest(file.url));
    }

    public static function play():void {
        playFrom(_currentPosition);
    }

    public static function pause():void {
        if (!_channel) return;
        _currentPosition = _channel.position;
        clearChannel();
    }

    public static function goToPosition(value:int):void {
        if (!_sound) return;
        _currentPosition = value;
        clearChannel();
        play();
    }

    private static function clear():void {
        _currentPosition = 0;
        clearChannel();
        if (_sound) {
            try {
                _sound.close();
            } catch (err:Error) {
                trace(err);
            }
            _sound = null;
        }
    }

    private static function playFrom(position:int = 0) : void {
        if (!_sound) return;
        if (_channel) return;
        _channel = _sound.play(position)
        _channel.addEventListener(Event.SOUND_COMPLETE, onComplete);
    }

    private static function clearChannel():void {
        if (!_channel) return;
        _channel.stop();
        _channel.removeEventListener(Event.SOUND_COMPLETE, onComplete);
        _channel = null;
    }

    public function SoundController() {
    }

    private static function onComplete(event:Event):void {
        clearChannel();
        _currentPosition = 0;
        _dispatcher.dispatchEvent(event);
    }
}
}
