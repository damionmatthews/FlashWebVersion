// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.GiftingController

package com.viroxoty.fashionista.ui{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.PurchasableObject;
    import flash.system.ApplicationDomain;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.data.Item;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import com.viroxoty.fashionista.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class GiftingController extends EventDispatcher {

        static const BOXES:int = 8;
        static const WIDTH:int = 133;
        static const HEIGHT:int = 141;

        private static var _instance:GiftingController;
        public static var gifts:Vector.<PurchasableObject>;

        private var appDomain:ApplicationDomain;
        private var view:MovieClip;

        public function GiftingController(){
            Tracer.out("new GiftingController");
        }
        public static function getInstance():GiftingController{
            if (_instance == null)
            {
                _instance = new (GiftingController)();
            };
            return (_instance);
        }

        public function open_popup():void{
            Tracer.out("GiftingController > open popup");
            this.load_data();
            this.load_view();
        }
        public function isOpen():Boolean{
            return (((this.view) && (this.view.parent)));
        }
        function load_data():void{
            DataManager.getInstance().get_daily_gifts(this.process_data);
        }
        public function process_data(data:Object):void{
            gifts = new Vector.<PurchasableObject>();
            var items:Array = data.items;
            items.forEach(function (_arg1:Object, _arg2:int, _arg3:Array){
                var _local4:Item = new Item();
                _local4.parseServerJSON(_arg1);
                gifts.push(_local4);
            });
            var decors:Array = data.decors;
            decors.forEach(function (_arg1:Object, _arg2:int, _arg3:Array){
                gifts.push(Decor.parseServerData(_arg1));
            });
            Tracer.out((("GiftingController > process_data : " + gifts.length) + " gifts"));
            if (gifts.length == 0)
            {
                dispatchEvent(new Event(EventHandler.CLOSED_GIFT_CENTER));
                return;
            };
            this.check_init();
        }
        function load_view():void{
            MainViewController.getInstance().show_preloader();
            var _local1:* = ((Constants.SERVER_SWF + Constants.GIFTING_FILENAME) + ".swf");
            var _local2:URLRequest = new URLRequest(_local1);
            var _local3:Loader = new Loader();
            _local3.contentLoaderInfo.addEventListener(Event.COMPLETE, this.swf_loaded);
            _local3.load(_local2);
        }
        public function swf_loaded(_arg1:Event):void{
            Tracer.out("GiftingController > swf_loaded ");
            this.appDomain = (_arg1.target as LoaderInfo).applicationDomain;
            this.view = this.get_asset("asset");
            this.check_init();
        }
        function check_init():void{
            if (((((this.view) && (gifts))) && ((gifts.length > 0))))
            {
                this.init();
            };
        }
        public function init(_arg1:Boolean=false):void{
            var _local2:int;
            var _local3:MovieClip;
            var _local4:PurchasableObject;
            while (_local2 < BOXES)
            {
                _local3 = this.view[("box" + _local2)];
                _local4 = gifts[_local2];
                if ((_local4 is Item))
                {
                    _local3.bg.addChild(new ItemSprite(Item(_local4), WIDTH, HEIGHT));
                } else
                {
                    _local3.bg.addChild(new DecorSprite(Decor(_local4), WIDTH, HEIGHT));
                };
                _local3.gift = _local4;
                Util.simpleButton(_local3, this.send_gift);
                _local2++;
            };
            Util.simpleButton(this.view.skip_btn, this.close);
            if (_arg1)
            {
                this.view.frame.visible = false;
            };
            MainViewController.getInstance().addGiftCenter(this.view);
            TopMenu.getInstance().addEventListener(TopMenu.CLICKED_TOP_MENU, this.close);
        }
        function send_gift(_arg1:MouseEvent):void{
            var _local2:PurchasableObject = _arg1.currentTarget.gift;
            FacebookConnector.openGiftFriendSelector(_local2, (((_local2 is Item)) ? Constants.REQUEST_ITEM_GIFT : Constants.REQUEST_DECOR_GIFT));
            this.close();
        }
        function close(_arg1=null):void{
            this.view.parent.removeChild(this.view);
            TopMenu.getInstance().removeEventListener(TopMenu.CLICKED_TOP_MENU, this.close);
            dispatchEvent(new Event(EventHandler.CLOSED_GIFT_CENTER));
            Tracer.out((("GiftingController > close. dispatched " + EventHandler.CLOSED_GIFT_CENTER) + " event"));
        }
        function get_asset(_arg1:String):MovieClip{
            var _local2:Class = Class(this.appDomain.getDefinition(_arg1));
            var _local3:MovieClip = new (_local2)();
            return (_local3);
        }

    }
}//package com.viroxoty.fashionista.ui

