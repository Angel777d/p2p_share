/**
 * Created by Dmitry on 17.02.14.
 */
package ru.angelovich.as3.p2p.core {

import flash.events.EventDispatcher;

import ru.angelovich.as3.utils.LocalStorage;

[Event(name="user", type="ru.angelovich.as3.p2p.core.CoreEvent")]
public class UserManager extends EventDispatcher {

    public static const ADD:String = "add";
    public static const REMOVE:String = "add";
    public static const UPDATE:String = "add";

    private static var _instance:UserManager = new UserManager();
    public static function get instance():UserManager {
        return _instance;
    }

    public function UserManager() {
        super();
        if (_instance) throw new Error("UserManager and can only be accessed through UserManager.instance");
    }
    private var _tmpUID:String = generateUID();

    public function set myName(value:String):void {
        me.name = value;
        dispatchEvent(getUserEvent(me, UPDATE));
    }

    public function get me():CoreUser {
        //delete storage['me'];// = mUser;

        var mUser:CoreUser = storage.me;
        if (!mUser) {
            mUser = new CoreUser();
            mUser.uid = generateUID();
            mUser.name = "Anonymous";
            storage.me = mUser;

        }
        //for tests
        //mUser.uid = _tmpUID;

        return mUser;
    }

    private function get storage():Object {
        return LocalStorage.getStorageObject("users");
    }

    public function getUserEvent(user:CoreUser, action:String):CoreEvent {
        var event:CoreEvent = new CoreEvent(CoreEvent.USER);
        event.user = user;
        event.action = action;
        return event;
    }

    private function generateUID():String {
        var result:String = "user:" + new Date().getTime().toFixed() + ":" + Math.round(1000000000 * Math.random());
        return result;
    }
}
}
