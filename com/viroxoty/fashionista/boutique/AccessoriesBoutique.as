// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.AccessoriesBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class AccessoriesBoutique extends ItemBoutique {

        var purses_data:XML;
        var hats_data:XML;
        var scarves_data:XML;
        var belts_data:XML;
        var gloves_data:XML;
        var glasses_data:XML;
        var masks_data:XML;
        var category_btn:MovieClip;

        public function AccessoriesBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
        }
        override public function set_items_xml(_arg1:XML):void{
            Tracer.out(("AccessoriesBoutique > set_items_xml : " + _arg1.toString()));
            this.sort_items_xml(_arg1);
            boutique_data = this.purses_data;
            total_data = boutique_data.children().length();
            check_show_shop_btn();
        }
        function sort_items_xml(_arg1:XML):void{
            var _local2:XML;
            var _local3:String;
            var _local4:XML;
            Tracer.out("sort_items_xml");
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
            var _local5:int = _arg1.children().length();
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
                            if (_local3 == "mask")
                            {
                                _local3 = "masks";
                            };
                        };
                    };
                };
                if (this[(_local3 + "_data")] != null)
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
            var _local1:MovieClip = catalog_mc.accessories_menu;
            _local1["first_btn"] = _local1.purses;
            _local1.visible = true;
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
            this.category_btn = _local1.purses;
            show_btn_selected(this.category_btn);
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

