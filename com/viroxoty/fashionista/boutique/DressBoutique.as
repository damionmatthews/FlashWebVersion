// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.DressBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;

    public class DressBoutique extends LookBoutique {

        var long_data:XML;
        var short_data:XML;
        var dresses_menu:MovieClip;

        public function DressBoutique(_arg1:BoutiqueDataObject){
            super(_arg1);
        }
        override public function set_looks_xml(_arg1:XML):void{
            Tracer.out(("DressBoutique > set_looks_xml : " + _arg1.toString()));
            this.sort_dresses_xml(_arg1);
            boutique_data = this.short_data;
            total_data = boutique_data.children().length();
            if (total_data > 0)
            {
                check_show_shop_btn();
            };
        }
        function sort_dresses_xml(_arg1:XML):void{
            var _local2:XML;
            Tracer.out("sort_dresses_xml");
            this.long_data = <LONG/>
            ;
            this.short_data = <SHORT/>
            ;
            var _local3:int = _arg1.children().length();
            var _local4:int = (_local3 - 1);
            while (_local4 >= 0)
            {
                _local2 = _arg1.DATA[_local4];
                if (_local2.DRESS_TYPE == 1)
                {
                    if (this.long_data.children().length() == 0)
                    {
                        this.long_data.appendChild(_local2);
                    } else
                    {
                        this.long_data.insertChildBefore(this.long_data.DATA[0], _local2);
                    };
                } else
                {
                    if (_local2.DRESS_TYPE == 2)
                    {
                        if (this.short_data.children().length() == 0)
                        {
                            this.short_data.appendChild(_local2);
                        } else
                        {
                            this.short_data.insertChildBefore(this.short_data.DATA[0], _local2);
                        };
                    } else
                    {
                        Tracer.out(("unexpected DRESS_TYPE : " + _local2.DRESS_TYPE));
                    };
                };
                _local4--;
            };
        }
        override public function init():void{
            super.init();
            this.dresses_menu = catalog_mc.dresses_menu;
            this.dresses_menu.visible = true;
            this.dresses_menu.long.addEventListener(MouseEvent.CLICK, this.click_long, false, 0, true);
            this.dresses_menu.short.addEventListener(MouseEvent.CLICK, this.click_short, false, 0, true);
            Util.setupButton(this.dresses_menu.long);
            Util.setupButton(this.dresses_menu.short);
            show_btn_selected(this.dresses_menu.short);
        }
        function click_long(_arg1:MouseEvent):void{
            show_btn_selected(this.dresses_menu.long);
            reset_btn(this.dresses_menu.short);
            boutique_data = this.long_data;
            total_data = boutique_data.children().length();
            while (catalog_items.numChildren > 0)
            {
                catalog_items.removeChildAt(0);
            };
            display_catalog(_arg1);
        }
        function click_short(_arg1:MouseEvent):void{
            show_btn_selected(this.dresses_menu.short);
            reset_btn(this.dresses_menu.long);
            boutique_data = this.short_data;
            total_data = boutique_data.children().length();
            while (catalog_items.numChildren > 0)
            {
                catalog_items.removeChildAt(0);
            };
            display_catalog(_arg1);
        }

    }
}//package com.viroxoty.fashionista.boutique

