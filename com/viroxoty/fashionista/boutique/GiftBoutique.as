// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.GiftBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.data.Decor;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class GiftBoutique extends DecorBoutique {

        private static var gift_type:String = Constants.REQUEST_PERFUME_GIFT;//"perfume_gift"

        public function GiftBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
            Tracer.out(("new GiftBoutique: " + boutique_name));
            rows = 2;
            items_per_page = 10;
        }
        override public function init():void{
            var _local1:BoutiqueModel;
            var _local3:int;
            loc = MainViewController.getInstance().screen;
            city_btn = loc.city_btn;
            city_btn.buttonMode = true;
            city_btn.addEventListener(MouseEvent.CLICK, goto_city, false, 0, true);
            city_btn.tip.visible = false;
            city_btn.tip.city_txt.text = ("To " + CityManager.getInstance().get_city_name(CityManager.getInstance().current_city));
            city_btn.addEventListener(MouseEvent.ROLL_OVER, show_city_btn_tip, false, 0, true);
            city_btn.addEventListener(MouseEvent.ROLL_OUT, hide_city_btn_tip, false, 0, true);
            dressing_room_btn = loc.dressing_room_btn;
            dressing_room_btn.buttonMode = true;
            dressing_room_btn.addEventListener(MouseEvent.CLICK, goto_dressing, false, 0, true);
            dressing_room_btn.tip.visible = false;
            dressing_room_btn.addEventListener(MouseEvent.ROLL_OVER, show_dr_btn_tip, false, 0, true);
            dressing_room_btn.addEventListener(MouseEvent.ROLL_OUT, hide_dr_btn_tip, false, 0, true);
            BackGroundMusic.getInstance().set_music(boutique.music);
            MainViewController.getInstance().show_preloader();
            catalog_mc = loc.gift_ui;
            Tracer.out("GiftBoutique > init: assigned catalog_mc");
            this.setup_catalog();
            loc.gift_tip1.x = boutique.avatar_position.x;
            loc.gift_tip1.y = boutique.avatar_position.y;
            loc.gift_tip1.ok_btn.buttonMode = true;
            loc.gift_tip1.ok_btn.addEventListener(MouseEvent.CLICK, this.display_catalog, false, 0, true);
            loc.gift_tip2.x = loc.gift_tip1.x;
            loc.gift_tip2.y = loc.gift_tip1.y;
            loc.gift_tip3.x = loc.gift_tip1.x;
            loc.gift_tip3.y = loc.gift_tip1.y;
            Tracer.out("GiftBoutique > init: positioned tips");
            var _local2:int = boutique.models.length;
            Tracer.out((_local2 + " boutique models"));
            while (_local3 < _local2)
            {
                if (boutique.avatar_scale > 0)
                {
                    Tracer.out("creating boutique model");
                    _local1 = new BoutiqueModel();
                    _local1.init();
                    _local1.get_boutique_model_for(this, boutique.models[_local3]);
                };
                _local3++;
            };
            directory_controller = new ScrollingDirectoryController();
            directory_controller.mode = ScrollingDirectoryController.MODE_BOUTIQUE;
            directory_controller.set_current_boutique(boutique);
            directory_controller.init_with_view(loc.directory);
            if (Constants.DEV_BOUTIQUE_IMAGE_MODE)
            {
                city_btn.visible = false;
                dressing_room_btn.visible = false;
                loc.directory.visible = false;
            };
        }
        override function check_show_shop_btn(){
            if (total_data > 0)
            {
                if (boutique_model_mc != null)
                {
                    if (Constants.DEV_BOUTIQUE_IMAGE_MODE != true)
                    {
                        loc.gift_tip1.visible = true;
                    };
                    MainViewController.getInstance().hide_preloader();
                };
            };
        }
        override protected function setup_catalog():void{
            var _local1:MovieClip = catalog_mc.close_mc;
            _local1.buttonMode = true;
            _local1.addEventListener(MouseEvent.CLICK, this.hide_catalog);
            catalog_items = new Sprite();
            catalog_mc.addChild(catalog_items);
            catalog_items.mask = catalog_mc.mask_mc;
        }
        override protected function display_catalog(e:MouseEvent):void{
            var fade_in:Function;
            fade_in = function (_arg1:Event):void{
                Tracer.out("GiftBoutique > catalog fade_in");
                if (catalog_mc.alpha < 1)
                {
                    catalog_mc.alpha = (catalog_mc.alpha + 0.4);
                } else
                {
                    catalog_mc.removeEventListener(Event.ENTER_FRAME, fade_in);
                    if (catalog_items.numChildren == 0)
                    {
                        load_items();
                    };
                };
            };
            if (loc.gift_tip1.visible)
            {
                loc.gift_tip1.visible = false;
                loc.gift_tip2.visible = true;
            };
            Tracer.out("display_catalog");
            current_item = 0;
            catalog_items.x = 0;
            catalog_mc.alpha = 0;
            catalog_mc.visible = true;
            catalog_mc.addEventListener(Event.ENTER_FRAME, fade_in);
        }
        override protected function load_items():void{
            var _local1:int;
            var _local2:Decor;
            var _local3:String;
            var _local4:Class;
            var _local5:MovieClip;
            var _local6:MovieClip;
            var _local7:Number;
            var _local8:Number;
            var _local10:int;
            var _local9:int = 30;
            _local1 = 1;
            while (_local1 <= total_data)
            {
                _local2 = decors[(_local1 - 1)];
                _local3 = _local2.swf;
                _local4 = BoutiqueManager.getInstance().class_by_name("gift_outline");
                _local5 = new (_local4)();
                _local6 = _local5.outline;
                _local5.x = _local9;
                _local5.y = _local10;
                _local7 = (_local6.width - 10);
                _local8 = (_local6.height - 10);
                _local6.addChild(new DecorSprite(_local2, _local7, _local8));
                _local5.buttonMode = true;
                _local5.addEventListener(MouseEvent.CLICK, this.selected_item, false, 0, true);
                _local5.addEventListener(MouseEvent.ROLL_OVER, this.item_over, false, 0, true);
                _local5.addEventListener(MouseEvent.ROLL_OUT, this.item_out, false, 0, true);
                _local5.gift = _local2;
                _local5.gift_txt.text = _local2.name.split(" Perfume").join("");
                catalog_items.addChild(_local5);
                _local10 = (_local10 + (_local5.height + 5));
                if ((_local1 % rows) == 0)
                {
                    _local9 = (_local9 + (_local6.width + 15));
                    _local10 = 0;
                };
                _local1++;
            };
        }
        override protected function item_over(_arg1:MouseEvent):void{
            Tracer.out("item_over");
            var _local2:DisplayObject = Sprite(_arg1.currentTarget);
            _local2.filters = [glow_effect];
        }
        override protected function item_out(_arg1:MouseEvent):void{
            Tracer.out("item_out");
            var _local2:DisplayObject = Sprite(_arg1.currentTarget);
            _local2.filters = [];
        }
        override protected function selected_item(_arg1:MouseEvent):void{
            Tracer.out("selected_item");
            FacebookConnector.openGiftFriendSelector((_arg1.currentTarget.gift as Decor), gift_type);
            if (loc.gift_tip2.visible)
            {
                loc.gift_tip3.visible = true;
            };
        }
        override protected function hide_catalog(_arg1:MouseEvent):void{
            _arg1.currentTarget.addEventListener(MouseEvent.CLICK, this.hide_catalog);
            catalog_mc.visible = false;
            loc.gift_tip1.visible = true;
            loc.gift_tip2.visible = false;
            loc.gift_tip3.visible = false;
        }

    }
}//package com.viroxoty.fashionista.boutique

