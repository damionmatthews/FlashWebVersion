// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.CookieManager

package com.viroxoty.fashionista{
    import flash.net.SharedObject;
    import flash.events.NetStatusEvent;
    import flash.events.*;
    import flash.net.*;
    import com.viroxoty.fashionista.util.*;

    public class CookieManager {

        private static var shared_object:SharedObject;

        public static function init():void{
            var _local1:String;
            shared_object = SharedObject.getLocal((Constants.APP_NAME + UserData.getInstance().third_party_id), "/");
            Tracer.out("CookieManager > init");
            for (_local1 in shared_object.data)
            {
                Tracer.out(((_local1 + "  is ") + shared_object.data[_local1]));
            };
        }
        public static function getValue(_arg1:String):Object{
            Tracer.out(((("getValue for " + _arg1) + " = ") + shared_object.data[_arg1]));
            return (shared_object.data[_arg1]);
        }
        public static function saveValue(key:String, value):void{
            var flushStatus:String;
            Tracer.out(((("saveValue for " + key) + " = ") + value));
            shared_object.setProperty(key, value);
            try
            {
                flushStatus = shared_object.flush(1000);
            } catch(error:Error)
            {
                Tracer.out("Error...Could not write SharedObject to disk\n");
            };
            if (flushStatus != null)
            {
                switch (flushStatus)
                {
                    case SharedObjectFlushStatus.PENDING:
                        Tracer.out("Requesting permission to save object...");
                        shared_object.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                        return;
                    case SharedObjectFlushStatus.FLUSHED:
                        Tracer.out("Value flushed to disk.");
                        return;
                };
            };
        }
        public static function clearValue(_arg1:String):void{
            delete shared_object.data[_arg1];
            shared_object.flush();
        }
        private static function onFlushStatus(_arg1:NetStatusEvent):void{
            trace("User closed permission dialog...\n");
            switch (_arg1.info.code)
            {
                case "SharedObject.Flush.Success":
                    Tracer.out("User granted permission -- value saved.\n");
                    break;
                case "SharedObject.Flush.Failed":
                    Tracer.out("User denied permission -- value not saved.\n");
                    break;
            };
            shared_object.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }

    }
}//package com.viroxoty.fashionista

