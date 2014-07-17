/**
 * Created by angel777d on 08.06.2014.
 */
package ru.angelovich.as3.p2p.modules.file {
public class FileDescription {

    public function FileDescription(data:*) {
        if (data is String)
            _data = JSON.parse(data as String);
        else
            _data = data;
    }
    public var _data:Object = {};

    public function get fileName():String {
        return _data.fileName;
    }

    public function get fileType():String {
        return _data.fileType;
    }

    public function get tags():String {
        return _data.tags;
    }

    public function get hash():String {
        return _data.hash;
    }

    public function get info():String {
        return _data.info;
    }

    public function get source():FileSource {
        return null;
    }


}
}
