/**
 * Created by angel777d on 08.06.2014.
 */
package ru.angelovich.as3.p2p.modules.file {
import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.core.CoreMessage;
import ru.angelovich.as3.p2p.modules.AModule;

public class FileModule extends AModule {
    public function FileModule(core:Core, name:String = "") {
        super(core, name);
    }

    override protected function initialize():void {
        //for overrides
    }

    override protected function processMessage(message:CoreMessage):void {
        //for overrides
    }

    public function addFile(file:FileDescription):void {

    }

    public function removeFile(file:FileDescription):void {

    }

    public function findFiles(file:FileDescription):void {

    }

    public function downloadFile(file:FileDescription):void {

    }
}
}
