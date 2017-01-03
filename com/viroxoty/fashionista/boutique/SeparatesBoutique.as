// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.SeparatesBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class SeparatesBoutique extends ItemBoutique {

        var blouses_data:XML;
        var coats_data:XML;
        var jackets_data:XML;
        var bathing_suits_data:XML;
        var pants_data:XML;
        var skirts_data:XML;
        var tights_data:XML;
        var shorts_data:XML;
        var shoes_data:XML;
        var menu:MovieClip;
        var sub_menu:MovieClip;
        var menu_btn:MovieClip;
        var category_btn:MovieClip;

        public function SeparatesBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
        }
        override public function set_items_xml(_arg1:XML):void{
            Tracer.out(("SeparatesBoutique > set_items_xml : " + _arg1.toString()));
            this.sort_items_xml(_arg1);
            boutique_data = this.blouses_data;
            total_data = boutique_data.children().length();
            check_show_shop_btn();
        }
        function sort_items_xml(_arg1:XML):void{
            var _local2:XML;
            var _local3:String;
            var _local4:XML;
            Tracer.out("sort_items_xml");
            this.blouses_data = <ITEMS/>
            ;
            this.coats_data = <ITEMS/>
            ;
            this.jackets_data = <ITEMS/>
            ;
            this.bathing_suits_data = <ITEMS/>
            ;
            this.pants_data = <ITEMS/>
            ;
            this.skirts_data = <ITEMS/>
            ;
            this.tights_data = <ITEMS/>
            ;
            this.shorts_data = <ITEMS/>
            ;
            var _local5:int = _arg1.children().length();
            var _local6:int = (_local5 - 1);
            while (_local6 >= 0)
            {
                _local2 = _arg1.ITEM[_local6];
                _local3 = _local2.NAME.toLowerCase();
                if (_local3 == "jacket")
                {
                    _local3 = "jackets";
                };
                _local4 = this[(_local3 + "_data")];
                if (_local4.children().length() == 0)
                {
                    _local4.appendChild(_local2);
                } else
                {
                    _local4.insertChildBefore(_local4.ITEM[0], _local2);
                };
                _local6--;
            };
        }
        override public function init():void{
            super.init();
            this.menu = catalog_mc.separates_menu;
            this.menu.visible = true;
            this.menu.tops.addEventListener(MouseEvent.CLICK, this.open_sub_menu, false, 0, true);
            this.menu.bottoms.addEventListener(MouseEvent.CLICK, this.open_sub_menu, false, 0, true);
            Util.setupButton(this.menu.tops);
            Util.setupButton(this.menu.bottoms);
            this.menu_btn = this.menu.tops;
            show_btn_selected(this.menu_btn);
            Tracer.out("menu setup");
            var _local1:MovieClip = catalog_mc.tops_menu;
            _local1.visible = true;
            this.sub_menu = _local1;
            _local1["first_btn"] = _local1.blouses;
            _local1.blouses.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.coats.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.jackets.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.bathing_suits.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            Util.setupButton(_local1.blouses);
            Util.setupButton(_local1.coats);
            Util.setupButton(_local1.jackets);
            Util.setupButton(_local1.bathing_suits);
            this.category_btn = _local1.blouses;
            show_btn_selected(this.category_btn);
            Tracer.out("tops submenu setup");
            _local1 = catalog_mc.bottoms_menu;
            _local1["first_btn"] = _local1.pants;
            _local1.pants.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.skirts.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.tights.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.shorts.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            Util.setupButton(_local1.pants);
            Util.setupButton(_local1.skirts);
            Util.setupButton(_local1.tights);
            Util.setupButton(_local1.shorts);
            Tracer.out("bottoms submenu setup");
        }
        function open_sub_menu(_arg1:MouseEvent):void{
            this.sub_menu.visible = false;
            reset_btn(this.menu_btn);
            reset_btn(this.category_btn);
            this.menu_btn = (_arg1.currentTarget as MovieClip);
            show_btn_selected(this.menu_btn);
            var _local2:String = this.menu_btn.name;
            this.sub_menu = catalog_mc[(_local2 + "_menu")];
            this.category_btn = this.sub_menu.first_btn;
            show_btn_selected(this.category_btn);
            this.sub_menu.visible = true;
            boutique_data = this[(this.category_btn.name + "_data")];
            total_data = boutique_data.children().length();
            while (catalog_items.numChildren > 0)
            {
                catalog_items.removeChildAt(0);
            };
            display_catalog(_arg1);
        }
        function show_shoes(_arg1:MouseEvent):void{
            this.sub_menu.visible = false;
            reset_btn(this.menu_btn);
            reset_btn(this.category_btn);
            this.menu_btn = (_arg1.currentTarget as MovieClip);
            show_btn_selected(this.menu_btn);
            boutique_data = this.shoes_data;
            total_data = boutique_data.children().length();
            while (catalog_items.numChildren > 0)
            {
                catalog_items.removeChildAt(0);
            };
            display_catalog(_arg1);
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
            display_catalog(_arg1);
        }

    }
}//package com.viroxoty.fashionista.boutique

