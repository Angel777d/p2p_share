/**
 * Created by angel777d on 31.05.2014.
 */
package ru.angelovich.as3.music.model {

[Bindable]
public class MusicLibraryItem extends StorableItem {

    public function MusicLibraryItem(data:* = null) {
        super(data);
    }

    public function get id():String {
        return _data.id;
    }

    public function set id(value:String):void {
        _data.id = value;
    }

    public function get id3Title():String {
        return _data.id3Title;
    }

    public function set id3Title(value:String):void {
        _data.id3Title = value;
    }

    public function get id3Artist():String {
        return _data.id3Artist;
    }

    public function set id3Artist(value:String):void {
        _data.id3Artist = value;
    }

    public function get id3Album():String {
        return _data.id3Album;
    }

    public function set id3Album(value:String):void {
        _data.id3Album = value;
    }

    public function get id3Year():String {
        return _data.id3Year;
    }

    public function set id3Year(value:String):void {
        _data.id3Year = value;
    }

    public function get id3Comment():String {
        return _data.id3Comment;
    }

    public function set id3Comment(value:String):void {
        _data.id3Comment = value;
    }

    public function get id3GenreCode():String {
        return _data.id3GenreCode;
    }

    public function set id3GenreCode(value:String):void {
        _data.id3GenreCode = value;
    }

    public function get filename():String {
        return _data.filename;
    }

    public function set filename(value:String):void {
        _data.filename = value;
    }

    public function get filetype():String {
        return _data.filetype;
    }

    public function set filetype(value:String):void {
        _data.filetype = value;
    }

    public function get filepath():String {
        return _data.filepath;
    }

    public function set filepath(value:String):void {
        _data.filepath = value;
    }

    public function get hash():String {
        return _data.hash;
    }

    public function set hash(value:String):void {
        _data.hash = value;
    }

    public function get shared():Boolean {
        return _data.shared;
    }

    public function set shared(value:Boolean):void {
        if (value) _data.shared = true;
        else delete _data["shared"];
    }
}
}
