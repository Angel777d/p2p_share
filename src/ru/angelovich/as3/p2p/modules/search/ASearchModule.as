/**
 * Created by angel777d on 27.07.2014.
 */
package ru.angelovich.as3.p2p.modules.search {
import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.core.CoreMessage;
import ru.angelovich.as3.p2p.modules.AModule;

public class ASearchModule extends AModule {

    public function ASearchModule(core:Core, name : String = "ASearchModule") {
        super(core, name);
    }

    override protected function processMessage(message:CoreMessage):void {
       if (message.module == moduleName) {
           var searchMessage : SearchMessage = message as SearchMessage;
           if (message.type == SearchMessage.REQUEST)
                sendResponse(searchMessage);
           if (message.type == SearchMessage.RESPONSE)
                processResponse(message as SearchMessage);
       }
    }

    protected function processRequest(message : SearchMessage) : * {
        //for overrides
        return null;
    }

    protected function processResponse(message : SearchMessage) : void {
        //for overrides
    }

    public function search(description : Object) : void {
        var message : SearchMessage = createMessage(SearchMessage.REQUEST);
        message.description = description;
        message.to = CoreMessage.DESTINATION_ALL;
        core.postMessage(message);
    }

    private function sendResponse(request : SearchMessage) {
        var message : SearchMessage = new SearchMessage();
        message.result = processRequest(request);
        message.to = request.from;
        message.description = request.description;
        core.postMessage(message);
    }

    protected function createMessage(type : String) : SearchMessage {
        var message : SearchMessage = new SearchMessage();
        message.module = moduleName;
        message.type = type;
        return message;
    }

}
}
