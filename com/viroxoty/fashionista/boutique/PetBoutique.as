// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.PetBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class PetBoutique extends ItemBoutique {

        public var dogs_data:XML;
        public var cats_data:XML;
        public var exotics_data:XML;
        public var pet_accessories_data:XML;
        var category_btn:MovieClip;

        public function PetBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
        }
        override public function set_items_xml(_arg1:XML):void{
            Tracer.out(("PetBoutique > set_items_xml : " + _arg1.toString()));
            this.sort_items_xml(_arg1);
            boutique_data = this.dogs_data;
            total_data = boutique_data.children().length();
            this.check_show_shop_btn();
        }
        function sort_items_xml(_arg1:XML):void{
            var _local2:XML;
            var _local3:String;
            var _local4:XML;
            Tracer.out("sort_items_xml");
            this.dogs_data = <ITEMS/>
            ;
            this.cats_data = <ITEMS/>
            ;
            this.exotics_data = <ITEMS/>
            ;
            var _local5:int = _arg1.children().length();
            var _local6:int = (_local5 - 1);
            while (_local6 >= 0)
            {
                _local2 = _arg1.ITEM[_local6];
                _local3 = _local2.NAME.toLowerCase();
                if (this.hasOwnProperty((_local3 + "_data")))
                {
                    _local4 = this[(_local3 + "_data")];
                    if (_local4.children().length() == 0)
                    {
                        _local4.appendChild(_local2);
                    } else
                    {
                        _local4.insertChildBefore(_local4.ITEM[0], _local2);
                    };
                } else
                {
                    Tracer.out((("type " + _local3) + " not expected in this boutique!"));
                };
                _local6--;
            };
        }
        override public function init():void{
            super.init();
            catalog_mc = loc.pets_ui;
            Tracer.out("PetBoutique > init: assigned catalog_mc");
            this.setup_catalog();
            loc.tip1_alt.visible = false;
            var _local1:MovieClip = catalog_mc;
            _local1["first_btn"] = _local1.dogs;
            _local1.dogs.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.cats.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.exotics.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            Util.setupButton(_local1.dogs);
            Util.setupButton(_local1.cats);
            Util.setupButton(_local1.exotics);
            Tracer.out("pets menu buttons setup");
            this.category_btn = _local1.dogs;
            show_btn_selected(this.category_btn);
            Tracer.out("PetBoutique > init: loading pets_model.swf");
            var _local2:* = (Constants.SERVER_SWF + "boutiques/pets_model.swf");
            var _local3:URLRequest = new URLRequest(_local2);
            var _local4:Loader = new Loader();
            _local4.contentLoaderInfo.addEventListener(Event.COMPLETE, this.model_loaded);
            _local4.load(_local3);
        }
        function show_category(_arg1:MouseEvent):void{
            reset_btn(this.category_btn);
            this.category_btn = (_arg1.currentTarget as MovieClip);
            show_btn_selected(this.category_btn);
            boutique_data = this[(this.category_btn.name + "_data")];
            total_data = boutique_data.children().length();
            while (catalog_items.numChildren > 0)
            {
                catalog_items.removeChildAt(0);
            };
            this.display_catalog(_arg1);
        }
        public function model_loaded(_arg1:Event):void{
            var _local2:MovieClip;
            Tracer.out("PetBoutique > model_loaded");
            _local2 = (_arg1.currentTarget.content as MovieClip);
            _local2.x = 420;
            _local2.y = 125;
            _local2.scaleX = 0.85;
            _local2.scaleY = 0.85;
            if (shop_btn.visible)
            {
                if (Constants.DEV_BOUTIQUE_IMAGE_MODE != true)
                {
                    loc.tip1_alt.visible = true;
                };
            };
            loc.addChildAt(_local2, 1);
        }
        override function check_show_shop_btn(){
            Tracer.out(("  check_show_shop_btn: total data is " + total_data));
            if (total_data >= 0)
            {
                show_shop_btn();
                if (Constants.DEV_BOUTIQUE_IMAGE_MODE != true)
                {
                    loc.shop_arrow.visible = true;
                    loc.tip1_alt.visible = true;
                };
            };
        }
        override protected function setup_catalog():void{
            var _local1:MovieClip = catalog_mc.close_mc;
            _local1.buttonMode = true;
            _local1.addEventListener(MouseEvent.CLICK, hide_catalog);
            catalog_items = new Sprite();
            catalog_mc.addChild(catalog_items);
            catalog_items.mask = catalog_mc.mask_mc;
        }
        override protected function display_catalog(e:MouseEvent):void{
            var show_items:Function;
            show_items = function (_arg1:Event):void{
                if (catalog_mc.alpha < 1)
                {
                    catalog_mc.alpha = (catalog_mc.alpha + 0.4);
                } else
                {
                    catalog_mc.removeEventListener(Event.ENTER_FRAME, show_items);
                    load_items();
                };
            };
            if (loc.tip1_alt.visible)
            {
                loc.tip1_alt.visible = false;
                loc.shop_arrow.visible = false;
            };
            Tracer.out("display_catalog");
            current_item = 0;
            catalog_items.x = 0;
            if (shop_btn.visible == true)
            {
                shop_btn.visible = false;
                catalog_mc.alpha = 0;
                catalog_mc.visible = true;
                catalog_mc.addEventListener(Event.ENTER_FRAME, show_items);
            } else
            {
                load_items();
            };
        }

    }
}//package com.viroxoty.fashionista.boutique

