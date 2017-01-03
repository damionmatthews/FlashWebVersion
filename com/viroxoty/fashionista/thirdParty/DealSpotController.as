// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.thirdParty.DealSpotController

package com.viroxoty.fashionista.thirdParty{
    import flash.display.Loader;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class DealSpotController {

        public static function add_deal_spot(container:MovieClip, x:Number, y:Number, depth:int=-1){
            var l:Loader;
            var ioErrorHandler:Function;
            var dealspot_loaded:Function;
            ioErrorHandler = function (_arg1:IOErrorEvent):void{
                Tracer.out(("ioErrorHandler: " + _arg1));
            };
            dealspot_loaded = function (_arg1:Event):void{
                Tracer.out("dealspot_loaded");
                l.x = x;
                l.y = y;
                if (depth == -1)
                {
                    container.addChild(l);
                } else
                {
                    container.addChildAt(l, depth);
                };
            };
            var request:URLRequest = new URLRequest((((((((Constants.DEALSPOT_URL + "?app_id=") + Constants.APP_ID) + "&mode=fbpayments&sid=") + UserData.getInstance().third_party_id) + "&onTransact=fashionista.external.dealspotTransactionComplete") + "&onOpen=fashionista.external.dealspotOverlayOpened") + "&onClose=fashionista.external.dealspotOverlayClosed"));
            Tracer.out(("dealspot request = " + request));
            l = new Loader();
            l.contentLoaderInfo.addEventListener(Event.INIT, dealspot_loaded);
            l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            l.load(request);
        }

    }
}//package com.viroxoty.fashionista.thirdParty

