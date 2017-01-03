// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.LookBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.AvatarController;
    import com.viroxoty.fashionista.data.Item;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class LookBoutique extends AbstractBoutique {

        protected var avatar_mc:MovieClip;
        protected var avatar_controller:AvatarController;
        protected var boutique_model_mc:MovieClip;
        protected var boutique_model_controller:BoutiqueModel;

        public function LookBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
            Tracer.out(("new LookBoutique: " + boutique_name));
            items_per_page = 4;
        }
        override public function get_catalog_data():void{
            DataManager.getInstance().get_looks_xml(String(boutique.id), this, this.set_looks_xml);
        }
        public function set_looks_xml(_arg1:XML):void{
            Tracer.out(("LookBoutique > set_looks_xml : " + _arg1.toString()));
            boutique_data = new XML(_arg1);
            total_data = boutique_data.children().length();
            if (total_data > 0)
            {
                this.check_show_shop_btn();
            };
        }
        override public function init():void{
            var _local1:int;
            var _local2:int;
            super.init();
            catalog_mc = loc.look_ui;
            catalog_mc.dresses_menu.visible = false;
            setup_catalog();
            this.avatar_controller = AvatarController.getInstance();
            this.avatar_controller.mode = AvatarController.MODE_SHOP;
            this.avatar_controller.init();
            this.avatar_controller.get_avatar_mc_for(this);
            if (boutique.models.length > 1)
            {
                _local1 = boutique.models.length;
                _local2 = 1;
                while (_local2 < _local1)
                {
                    this.boutique_model_controller = new BoutiqueModel();
                    this.boutique_model_controller.init();
                    this.boutique_model_controller.get_boutique_model_for(this, boutique.models[_local2]);
                    _local2++;
                };
            };
            loc.tip1.name_txt.gotoAndStop(boutique.id);
        }
        override public function destroy():void{
            super.destroy();
            this.avatar_controller.removeEventListener(AvatarController.CLICK_ITEM, this.hide_model_tip);
        }
        public function set_avatar_mc(_arg1:MovieClip):void{
            var _local2:Item;
            var _local5:int;
            this.avatar_mc = _arg1;
            this.avatar_mc.x = boutique.avatar_position.x;
            this.avatar_mc.y = boutique.avatar_position.y;
            loc.tip1.x = this.avatar_mc.x;
            loc.tip1.y = this.avatar_mc.y;
            loc.tip2.x = this.avatar_mc.x;
            loc.tip2.y = this.avatar_mc.y;
            loc.tip3.x = this.avatar_mc.x;
            loc.tip3.y = this.avatar_mc.y;
            loc.tip4.x = this.avatar_mc.x;
            loc.tip4.y = this.avatar_mc.y;
            var _local3:Vector.<Item> = BoutiqueModelDataObject(boutique.models[0]).items;
            this.avatar_mc.visible = false;
            this.avatar_mc.alpha = 0;
            loc.addChildAt(_arg1, 1);
            this.avatar_controller.set_styles(boutique.models[0].style);
            var _local4:int = _local3.length;
            while (_local5 < _local4)
            {
                _local2 = _local3[_local5];
                this.avatar_controller.display_contestant_item(_local2, _local4);
                _local5++;
            };
            this.avatar_controller.addEventListener("fade_in_complete", this.avatar_ready);
        }
        public function set_boutique_model(_arg1:MovieClip, _arg2:BoutiqueModelDataObject, _arg3:BoutiqueModel):void{
            var _local4:Item;
            var _local5:String;
            var _local6:String;
            var _local9:int;
            this.boutique_model_mc = _arg1;
            this.boutique_model_mc.x = _arg2.position.x;
            this.boutique_model_mc.y = _arg2.position.y;
            this.boutique_model_mc.scaleX = _arg2.scale;
            this.boutique_model_mc.scaleY = Math.abs(_arg2.scale);
            this.boutique_model_mc.visible = false;
            this.boutique_model_mc.alpha = 0;
            loc.addChildAt(this.boutique_model_mc, 1);
            _arg3.set_styles(_arg2.style);
            var _local7:Vector.<Item> = _arg2.items;
            var _local8:int = _local7.length;
            while (_local9 < _local8)
            {
                _local4 = _local7[_local9];
                _local5 = _local4.category;
                _local6 = _local4.swf;
                _arg3.display_item(_local5, _local6, _local8);
                _local9++;
            };
        }
        public function showDressingRoomTip():void{
            if (loc.tip3.visible)
            {
                loc.tip3.visible = false;
                loc.tip4.visible = true;
                loc.nav_tip.visible = true;
            };
        }
        function avatar_ready(_arg1:Event):void{
            this.avatar_controller.removeEventListener("fade_in_complete", this.avatar_ready);
            this.check_show_shop_btn();
        }
        function check_show_shop_btn(){
            Tracer.out("check_show_shop_btn");
            if (((loc.shop_arrow.visible) || (loc.tip2.visible)))
            {
                return;
            };
            if ((((total_data > 0)) && (this.avatar_mc)))
            {
                if (this.avatar_mc.visible)
                {
                    this.avatar_mc.alpha = 1;
                    if (((UserData.getInstance().first_time_visit()) && ((Tracker.first_time_catalog == false))))
                    {
                        Tracker.first_time_catalog = true;
                        loc.tip1.visible = true;
                        this.display_catalog(null);
                        loc.catalog_tip.visible = true;
                        return;
                    };
                    show_shop_btn();
                    if (Constants.DEV_BOUTIQUE_IMAGE_MODE != true)
                    {
                        loc.shop_arrow.visible = true;
                        if (boutique.level < 2)
                        {
                            loc.tip1.visible = true;
                        };
                    };
                };
            };
        }
        override protected function display_catalog(e:MouseEvent):void{
            var show_looks:Function;
            show_looks = function (_arg1:Event):void{
                if (catalog_mc.alpha < 1)
                {
                    catalog_mc.alpha = (catalog_mc.alpha + 0.4);
                } else
                {
                    catalog_mc.removeEventListener(Event.ENTER_FRAME, show_looks);
                    load_looks_swf();
                };
            };
            loc.shop_arrow.visible = false;
            if (loc.tip1.visible)
            {
                loc.tip1.visible = false;
                loc.tip2.visible = true;
            };
            current_item = 0;
            next_mc.visible = false;
            prev_mc.visible = false;
            next_mc.gotoAndStop(2);
            prev_mc.gotoAndStop(2);
            if (total_data > (current_item + items_per_page))
            {
                next_mc.gotoAndStop(1);
                next_mc.visible = true;
                next_mc.buttonMode = true;
                next_mc.mouseEnabled = true;
                next_mc.mouseChildren = true;
                prev_mc.visible = true;
                prev_mc.buttonMode = false;
                prev_mc.mouseEnabled = false;
                prev_mc.mouseChildren = false;
            };
            catalog_items.x = 0;
            if (shop_btn.visible == true)
            {
                shop_btn.visible = false;
                catalog_mc.alpha = 0;
                catalog_mc.visible = true;
                catalog_mc.addEventListener(Event.ENTER_FRAME, show_looks);
            } else
            {
                this.load_looks_swf();
            };
        }
        override protected function show_next(_arg1:MouseEvent):void{
            clear_catalog();
            current_item = (current_item + items_per_page);
            this.load_looks_swf();
            Util.enable_button(prev_mc);
            if ((current_item + items_per_page) >= (total_data + 1))
            {
                Util.disable_button(next_mc);
                next_mc.gotoAndStop(2);
            };
        }
        override protected function show_previous(_arg1:MouseEvent):void{
            clear_catalog();
            current_item = (current_item - items_per_page);
            this.load_looks_swf();
            Util.enable_button(next_mc);
            if (current_item == 0)
            {
                Util.disable_button(prev_mc);
                prev_mc.gotoAndStop(2);
            };
        }
        private function load_looks_swf():void{
            var _local1:int;
            var _local2:Sprite;
            var _local3:URLRequest;
            var _local4:Loader;
            var _local5:Class;
            var _local6:MovieClip;
            var _local7:Class;
            var _local8:MovieClip;
            var _local9:int = 10;
            var _local10:int = 10;
            var _local11:int = Math.min((current_item + items_per_page), total_data);
            _local1 = current_item;
            while (_local1 < _local11)
            {
                _local2 = new Sprite();
                _local3 = new URLRequest((Constants.SERVER_LOOKS + boutique_data.DATA[_local1].PNG));
                _local4 = new Loader();
                _local4.load(_local3);
                _local2.addChild(_local4);
                _local2.x = _local9;
                _local2.y = _local10;
                _local2.name = String(_local1);
                _local2.scaleX = 0.4;
                _local2.scaleY = 0.4;
                _local5 = BoutiqueManager.getInstance().class_by_name("look_outline");
                _local6 = new (_local5)();
                _local6.x = _local9;
                _local6.y = _local10;
                catalog_items.addChild(_local6);
                catalog_items.addChild(_local2);
                _local2.buttonMode = true;
                _local2.addEventListener(MouseEvent.CLICK, this.selected_look);
                _local2.addEventListener(MouseEvent.MOUSE_OVER, this.item_over);
                _local2.addEventListener(MouseEvent.MOUSE_OUT, this.item_out);
                _local10 = (_local10 + 165);
                if (((_local1 + 1) % 2) == 0)
                {
                    _local9 = (_local9 + 100);
                    _local10 = 10;
                };
                _local1++;
            };
            if (_local1 == total_data)
            {
                _local7 = BoutiqueManager.getInstance().class_by_name("dressing_room_bubble");
                _local8 = new (_local7)();
                _local8.buttonMode = true;
                _local8.addEventListener(MouseEvent.CLICK, goto_dressing);
                _local8.x = _local9;
                _local8.y = _local10;
                catalog_items.addChild(_local8);
            };
        }
        override protected function item_over(_arg1:MouseEvent):void{
            _arg1.currentTarget.filters = [glow_effect];
            _arg1.currentTarget.scaleX = 0.42;
            _arg1.currentTarget.scaleY = 0.42;
        }
        override protected function item_out(_arg1:MouseEvent):void{
            _arg1.currentTarget.filters = [];
            _arg1.currentTarget.scaleX = 0.4;
            _arg1.currentTarget.scaleY = 0.4;
        }
        private function selected_look(_arg1:MouseEvent):void{
            var _local2:XML;
            var _local3:int;
            if (loc.tip2.visible)
            {
                loc.tip2.visible = false;
                loc.tip4.visible = false;
                loc.nav_tip.visible = false;
                if (boutique.level < 2)
                {
                    loc.tip3.visible = true;
                };
            };
            if (loc.catalog_tip.visible)
            {
                loc.catalog_tip.visible = false;
                loc.model_tip.visible = true;
                this.avatar_controller.addEventListener(AvatarController.CLICK_ITEM, this.hide_model_tip, false, 0, true);
            };
            while (_local3 < total_data)
            {
                if (_arg1.currentTarget.name == String(_local3))
                {
                    _local2 = boutique_data.DATA[_local3];
                    this.avatar_controller.display_selected_look(boutique_data.DATA[_local3].ID);
                    return;
                };
                _local3++;
            };
        }
        function hide_model_tip(_arg1=null):void{
            this.avatar_controller.removeEventListener(AvatarController.CLICK_ITEM, this.hide_model_tip);
            loc.model_tip.visible = false;
        }

    }
}//package com.viroxoty.fashionista.boutique

