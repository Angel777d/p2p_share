/**
 * Created by angel777d on 27.07.2014.
 */
package ru.angelovich.as3.music.model {
import ru.angelovich.as3.p2p.core.Core;
import ru.angelovich.as3.p2p.modules.search.SearchMessage;
import ru.angelovich.as3.p2p.modules.search.ASearchModule;

public class SearchMusicModule extends ASearchModule {

    public static const NAME : String = "SearchMusicModule";
    public function SearchMusicModule(core:Core) {
        super(core, NAME);
    }

    override protected function processRequest(message : SearchMessage) : * {
        //for overrides
        return null;
    }

    override protected function processResponse(message : SearchMessage) : void {
        //for overrides
    }

}
}
