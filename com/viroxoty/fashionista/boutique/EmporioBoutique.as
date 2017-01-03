// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.EmporioBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class EmporioBoutique extends ItemBoutique {

        public var blouses_data:XML;
        public var coats_data:XML;
        public var jackets_data:XML;
        public var bathing_suits_data:XML;
        public var pants_data:XML;
        public var skirts_data:XML;
        public var tights_data:XML;
        public var shorts_data:XML;
        public var shoes_data:XML;
        public var purses_data:XML;
        public var hats_data:XML;
        public var scarves_data:XML;
        public var belts_data:XML;
        public var gloves_data:XML;
        public var glasses_data:XML;
        public var masks_data:XML;
        public var bracelets_data:XML;
        public var rings_data:XML;
        public var necklaces_data:XML;
        public var earrings_data:XML;
        public var tiaras_data:XML;
        var emporio_menu:MovieClip;
        var sub_menu:MovieClip;
        var menu_btn:MovieClip;
        var category_btn:MovieClip;

        public function EmporioBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
        }
        override public function set_items_xml(_arg1:XML):void{
            Tracer.out(("EmporioBoutique > set_items_xml : " + _arg1.toString()));
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
            this.shoes_data = <ITEMS/>
            ;
            this.purses_data = <ITEMS/>
            ;
            this.hats_data = <ITEMS/>
            ;
            this.scarves_data = <ITEMS/>
            ;
            this.belts_data = <ITEMS/>
            ;
            this.gloves_data = <ITEMS/>
            ;
            this.glasses_data = <ITEMS/>
            ;
            this.masks_data = <ITEMS/>
            ;
            this.bracelets_data = <ITEMS/>
            ;
            this.rings_data = <ITEMS/>
            ;
            this.necklaces_data = <ITEMS/>
            ;
            this.earrings_data = <ITEMS/>
            ;
            this.tiaras_data = <ITEMS/>
            ;
            var _local5:int = _arg1.children().length();
            Tracer.out((("sorting " + _local5) + " items"));
            var _local6:int = (_local5 - 1);
            while (_local6 >= 0)
            {
                _local2 = _arg1.ITEM[_local6];
                _local3 = _local2.NAME.toLowerCase();
                if (_local3 == "hat")
                {
                    _local3 = "hats";
                } else
                {
                    if (_local3 == "jacket")
                    {
                        _local3 = "jackets";
                    } else
                    {
                        if (_local3 == "purse")
                        {
                            _local3 = "purses";
                        } else
                        {
                            if (_local3 == "scarf")
                            {
                                _local3 = "scarves";
                            } else
                            {
                                if (_local3 == "bracelet")
                                {
                                    _local3 = "bracelets";
                                } else
                                {
                                    if (_local3 == "ring")
                                    {
                                        _local3 = "rings";
                                    } else
                                    {
                                        if (_local3 == "mask")
                                        {
                                            _local3 = "masks";
                                        } else
                                        {
                                            if (_local3 == "wing_coats")
                                            {
                                                _local3 = "coats";
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
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
                    Tracer.out((("error - item id " + _local2.ID) + " lacks a category"));
                };
                _local6--;
            };
        }
        override public function init():void{
            super.init();
            this.emporio_menu = catalog_mc.emporio_menu;
            this.emporio_menu.visible = true;
            this.emporio_menu.tops.addEventListener(MouseEvent.CLICK, this.open_sub_menu, false, 0, true);
            this.emporio_menu.bottoms.addEventListener(MouseEvent.CLICK, this.open_sub_menu, false, 0, true);
            this.emporio_menu.accessories.addEventListener(MouseEvent.CLICK, this.open_sub_menu, false, 0, true);
            this.emporio_menu.shoes.addEventListener(MouseEvent.CLICK, this.show_shoes, false, 0, true);
            this.emporio_menu.jewelry.addEventListener(MouseEvent.CLICK, this.open_sub_menu, false, 0, true);
            Util.setupButton(this.emporio_menu.tops);
            Util.setupButton(this.emporio_menu.bottoms);
            Util.setupButton(this.emporio_menu.accessories);
            Util.setupButton(this.emporio_menu.shoes);
            Util.setupButton(this.emporio_menu.jewelry);
            this.menu_btn = this.emporio_menu.tops;
            show_btn_selected(this.menu_btn);
            Tracer.out("emporio menu setup");
            var _local1:MovieClip = catalog_mc.tops_menu;
            _local1.visible = true;
            this.sub_menu = _local1;
            _local1["first_btn"] = _local1.blouses;
            Tracer.out("tops submenu start setup");
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
            _local1 = catalog_mc.accessories_menu;
            _local1["first_btn"] = _local1.purses;
            _local1.purses.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.hats.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.scarves.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.belts.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.gloves.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.glasses.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.masks.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            Util.setupButton(_local1.purses);
            Util.setupButton(_local1.hats);
            Util.setupButton(_local1.scarves);
            Util.setupButton(_local1.belts);
            Util.setupButton(_local1.gloves);
            Util.setupButton(_local1.glasses);
            Util.setupButton(_local1.masks);
            Tracer.out("accessories_menu setup");
            _local1 = catalog_mc.jewelry_menu;
            _local1["first_btn"] = _local1.earrings;
            _local1.earrings.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.bracelets.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.rings.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.necklaces.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.tiaras.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            Util.setupButton(_local1.earrings);
            Util.setupButton(_local1.bracelets);
            Util.setupButton(_local1.rings);
            Util.setupButton(_local1.necklaces);
            Util.setupButton(_local1.tiaras);
            Tracer.out("jewelry_menu setup");
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

