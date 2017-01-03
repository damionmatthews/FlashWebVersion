// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.LookOfTheDayController

package com.viroxoty.fashionista.ui{
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Item;
    import flash.geom.Point;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.UserData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import flash.text.*;
    import flash.display.*;
    import flash.geom.*;
    import com.adobe.serialization.json.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class LookOfTheDayController {

        private static var _instance:LookOfTheDayController;
        public static var items:Vector.<Item>;
        static var look_id:int;
        static var item_ids:String;
        static var fcash:int;
        static var credits_cost:int;
        static var fcash_cost:int;

        var pending_open:Boolean;
        var pos:Point;
        var scale:Number = 1;
        var boutique_model_mc:MovieClip;
        private var popup:MovieClip;

        public function LookOfTheDayController(){
            this.pos = new Point(100, 150);
        }
        public static function getInstance():LookOfTheDayController{
            if (_instance == null)
            {
                _instance = new (LookOfTheDayController)();
            };
            return (_instance);
        }

        public function process_data(_arg1:String):void{
            var _local2:Item;
            var _local6:int;
            if (_arg1 == "false")
            {
                return;
            };
            var _local3:Object = Json.decode(_arg1);
            look_id = _local3.id;
            fcash = _local3.fashion_cash;
            credits_cost = _local3.credits_cost;
            fcash_cost = _local3.fcash_cost;
            items = new Vector.<Item>();
            item_ids = "";
            var _local4:Array = _local3.items;
            var _local5:int = _local4.length;
            while (_local6 < _local5)
            {
                if (_local6 > 0)
                {
                    item_ids = (item_ids + "-");
                };
                _local2 = new Item();
                _local2.parseServerJSON(_local4[_local6]);
                items.push(_local2);
                item_ids = (item_ids + _local2.id);
                _local6++;
            };
            Tracer.out((("LookOfTheDayController > process_data : " + _local5) + " items"));
        }
        public function add_items_to_closet():void{
            var _local3:int;
            var _local1:int = items.length;
            var _local2:UserData = UserData.getInstance();
            while (_local3 < _local1)
            {
                _local2.add_to_closet(items[_local3]);
                _local3++;
            };
        }
        public function open_popup():void{
            Tracer.out("LookOfTheDayController > open popup");
            this.popup = (Pop_Up.getInstance().get_popup(Pop_Up.LOOK_OF_THE_DAY) as MovieClip);
            this.popup.bonus_txt.text = "";
            this.popup.cost_txt.text = String(fcash_cost);
            this.popup.buy_btn.buttonMode = true;
            this.popup.buy_btn.addEventListener(MouseEvent.CLICK, this.buy_look, false, 0, true);
            this.popup.close_mc.buttonMode = true;
            this.popup.close_mc.addEventListener(MouseEvent.CLICK, this.close, false, 0, true);
            var _local1:Sprite = new Sprite();
            _local1.x = this.pos.x;
            _local1.y = this.pos.y;
            _local1.scaleX = this.scale;
            _local1.scaleY = this.scale;
            this.popup.addChild(_local1);
            var _local2:ModelWrapper = new ModelWrapper(items, DressingRoom.user_default_styles, _local1);
            MainViewController.getInstance().addPopup(this.popup);
        }
        function close(_arg1:MouseEvent):void{
            MainViewController.getInstance().removePopups();
            this.popup = null;
        }
        function buy_look(_arg1:MouseEvent):void{
            this.close(_arg1);
            DataManager.getInstance().buy_look_of_the_day(look_id, fcash_cost, items);
        }

    }
}//package com.viroxoty.fashionista.ui

