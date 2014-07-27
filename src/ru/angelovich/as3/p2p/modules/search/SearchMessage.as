/**
 * Created by angel777d on 27.07.2014.
 */
package ru.angelovich.as3.p2p.modules.search {
import ru.angelovich.as3.p2p.core.CoreMessage;

public class SearchMessage extends CoreMessage {

    public static const REQUEST : String = "type||request";
    public static const RESPONSE : String = "type||response";

    public function SearchMessage() {
        super();
    }

    public var description : Object;
    public var result : *;
}
}
