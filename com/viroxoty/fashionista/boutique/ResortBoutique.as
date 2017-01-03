// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.ResortBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class ResortBoutique extends ItemBoutique {

        var bathing_suits_data:XML;
        var glasses_data:XML;
        var scarves_data:XML;
        var shoes_data:XML;
        var bracelets_data:XML;
        var earrings_data:XML;
        var necklaces_data:XML;
        var coats_data:XML;
        var hats_data:XML;
        var rings_data:XML;
        var category_btn:MovieClip;

        public function ResortBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
        }
        override public function set_items_xml(_arg1:XML):void{
            Tracer.out(("ResortBoutique > set_items_xml : " + _arg1.toString()));
            this.sort_items_xml(_arg1);
            boutique_data = this.bathing_suits_data;
            total_data = boutique_data.children().length();
            check_show_shop_btn();
        }
        function sort_items_xml(_arg1:XML):void{
            var _local2:XML;
            var _local3:String;
            var _local4:XML;
            Tracer.out("sort_items_xml");
            this.bathing_suits_data = <ITEMS/>
            ;
            this.glasses_data = <ITEMS/>
            ;
            this.scarves_data = <ITEMS/>
            ;
            this.shoes_data = <ITEMS/>
            ;
            this.bracelets_data = <ITEMS/>
            ;
            this.earrings_data = <ITEMS/>
            ;
            this.necklaces_data = <ITEMS/>
            ;
            this.coats_data = <ITEMS/>
            ;
            this.hats_data = <ITEMS/>
            ;
            this.rings_data = <ITEMS/>
            ;
            var _local5:int = _arg1.children().length();
            var _local6:int = (_local5 - 1);
            while (_local6 >= 0)
            {
                _local2 = _arg1.ITEM[_local6];
                _local3 = _local2.NAME.toLowerCase();
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
                            if (_local3 == "hat")
                            {
                                _local3 = "hats";
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
            var _local1:MovieClip = catalog_mc.resort_menu;
            _local1.visible = true;
            _local1["first_btn"] = _local1.bathing_suits;
            _local1.bathing_suits.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.glasses.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.scarves.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.shoes.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.bracelets.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.earrings.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.necklaces.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.coats.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.hats.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            _local1.rings.addEventListener(MouseEvent.CLICK, this.show_category, false, 0, true);
            Util.setupButton(_local1.bathing_suits);
            Util.setupButton(_local1.glasses);
            Util.setupButton(_local1.scarves);
            Util.setupButton(_local1.shoes);
            Util.setupButton(_local1.bracelets);
            Util.setupButton(_local1.earrings);
            Util.setupButton(_local1.necklaces);
            Util.setupButton(_local1.coats);
            Util.setupButton(_local1.hats);
            Util.setupButton(_local1.rings);
            Tracer.out("resort_menu setup");
            this.category_btn = _local1.bathing_suits;
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

