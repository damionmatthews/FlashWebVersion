// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.AbstractBoutique

package com.viroxoty.fashionista.boutique{
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.ui.ScrollingDirectoryController;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.filters.*;

    public class AbstractBoutique {

        public var boutique:BoutiqueDataObject;
        protected var boutique_name:String;
        protected var boutique_id:int;
        protected var boutique_data:XML;
        protected var total_data:int;
        protected var current_item:int;
        protected var items_per_page:int;
        protected var loc:MovieClip;
        protected var directory_controller:ScrollingDirectoryController;
        protected var city_btn:MovieClip;
        protected var shop_btn:MovieClip;
        protected var dressing_room_btn:MovieClip;
        protected var catalog_mc:MovieClip;
        protected var catalog_items:Sprite;
        protected var next_mc:MovieClip;
        protected var prev_mc:MovieClip;
        protected var glow_effect:GlowFilter;
        protected var item_scale:Number;
        protected var categories:Object;

        public function AbstractBoutique(_arg1:BoutiqueDataObject):void{
            this.boutique = _arg1;
            this.boutique_name = this.boutique.name;
            this.boutique_id = this.boutique.id;
            Tracer.out("new abstract boutique");
            this.glow_effect = new GlowFilter();
            this.glow_effect.inner = false;
            this.glow_effect.color = 0xFFFFFF;
            this.glow_effect.blurX = 5;
            this.glow_effect.blurY = 5;
            this.categories = {
                "1":"pants",
                "2":"skirts",
                "3":"purse",
                "4":"hat",
                "5":"blouses",
                "22":"coats",
                "23":"shoes",
                "8":"shoes",
                "9":"jacket",
                "10":"tights",
                "11":"scarf",
                "12":"belts",
                "13":"dress",
                "14":"gloves",
                "16":"bracelet",
                "17":"ring",
                "18":"necklaces",
                "19":"earrings",
                "20":"glasses",
                "21":"mask",
                "15":"tiaras",
                "25":"shorts",
                "26":"bathing_suits"
            };
        }
        public function destroy():void{
            this.directory_controller.destroy();
        }
        public function init():void{
            this.loc = MainViewController.getInstance().screen;
            this.shop_btn = this.loc.shop_btn;
            this.shop_btn.alpha = 0;
            this.shop_btn.visible = true;
            this.shop_btn.buttonMode = true;
            this.shop_btn.addEventListener(MouseEvent.CLICK, this.display_catalog);
            this.loc.shop_arrow.visible = false;
            this.city_btn = this.loc.city_btn;
            this.city_btn.buttonMode = true;
            this.city_btn.addEventListener(MouseEvent.CLICK, this.goto_city, false, 0, true);
            this.city_btn.tip.visible = false;
            this.city_btn.tip.city_txt.text = ("To " + CityManager.getInstance().get_city_name(CityManager.getInstance().current_city));
            this.city_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_city_btn_tip, false, 0, true);
            this.city_btn.addEventListener(MouseEvent.ROLL_OUT, this.hide_city_btn_tip, false, 0, true);
            this.dressing_room_btn = this.loc.dressing_room_btn;
            this.dressing_room_btn.buttonMode = true;
            this.dressing_room_btn.addEventListener(MouseEvent.CLICK, this.goto_dressing, false, 0, true);
            this.dressing_room_btn.tip.visible = false;
            this.dressing_room_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_dr_btn_tip, false, 0, true);
            this.dressing_room_btn.addEventListener(MouseEvent.ROLL_OUT, this.hide_dr_btn_tip, false, 0, true);
            BackGroundMusic.getInstance().set_music(this.boutique.music);
            MainViewController.getInstance().show_preloader();
            this.directory_controller = new ScrollingDirectoryController();
            this.directory_controller.mode = ScrollingDirectoryController.MODE_BOUTIQUE;
            this.directory_controller.set_current_boutique(this.boutique);
            this.directory_controller.init_with_view(this.loc.directory);
            if (this.boutique.level != 0)
            {
                this.directory_controller.hide_directory();
            };
            if (Constants.DEV_BOUTIQUE_IMAGE_MODE)
            {
                this.shop_btn.visible = false;
                this.city_btn.visible = false;
                this.dressing_room_btn.visible = false;
                this.loc.directory.visible = false;
            };
        }
        protected function setup_catalog():void{
            this.current_item = 0;
            var _local1:MovieClip = this.catalog_mc.close_mc;
            _local1.buttonMode = true;
            _local1.addEventListener(MouseEvent.CLICK, this.hide_catalog);
            this.prev_mc = this.catalog_mc.prev_mc;
            this.next_mc = this.catalog_mc.next_mc;
            this.next_mc.addEventListener(MouseEvent.CLICK, this.show_next);
            this.prev_mc.addEventListener(MouseEvent.CLICK, this.show_previous);
            this.catalog_items = new Sprite();
            this.catalog_mc.addChild(this.catalog_items);
            this.catalog_items.mask = this.catalog_mc.mask_mc;
        }
        protected function hide_catalog(_arg1:MouseEvent):void{
            this.clear_catalog();
            this.catalog_mc.visible = false;
            this.show_shop_btn();
        }
        protected function clear_catalog():void{
            while (this.catalog_items.numChildren > 0)
            {
                this.catalog_items.removeChildAt(0);
            };
        }
        public function get_catalog_data():void{
        }
        protected function display_catalog(_arg1:MouseEvent):void{
        }
        protected function show_next(_arg1:MouseEvent):void{
        }
        protected function show_previous(_arg1:MouseEvent):void{
        }
        protected function show_shop_btn():void{
            Tracer.out("show_shop_btn");
            MainViewController.getInstance().hide_preloader();
            if (Constants.DEV_BOUTIQUE_IMAGE_MODE != true)
            {
                Tweener.removeTweens(this.shop_btn);
                this.shop_btn.gotoAndStop(this.boutique.id);
                this.shop_btn.alpha = 0;
                this.shop_btn.visible = true;
                Tweener.addTween(this.shop_btn, {
                    "alpha":1,
                    "time":0.5,
                    "transition":"easeinoutsine",
                    "onComplete":function (){
                    }
                });
            };
        }
        protected function item_over(_arg1:MouseEvent):void{
        }
        protected function item_out(_arg1:MouseEvent):void{
        }
        protected function show_btn_selected(_arg1:MovieClip):void{
            _arg1.gotoAndStop(3);
            _arg1.mouseEnabled = false;
            _arg1.mouseChildren = false;
            _arg1.buttonMode = false;
        }
        protected function reset_btn(_arg1:MovieClip):void{
            _arg1.buttonMode = true;
            _arg1.mouseEnabled = true;
            _arg1.mouseChildren = true;
            _arg1.gotoAndStop(1);
        }
        protected function goto_city(_arg1:MouseEvent):void{
            CityManager.getInstance().goto_city(CityManager.getInstance().current_city);
        }
        function show_city_btn_tip(_arg1:MouseEvent):void{
            this.city_btn.tip.visible = true;
        }
        function hide_city_btn_tip(_arg1:MouseEvent):void{
            this.city_btn.tip.visible = false;
        }
        protected function goto_dressing(_arg1:MouseEvent):void{
            DressingRoom.getNewInstance().load();
        }
        function show_dr_btn_tip(_arg1:MouseEvent):void{
            this.dressing_room_btn.tip.visible = true;
        }
        function hide_dr_btn_tip(_arg1:MouseEvent):void{
            this.dressing_room_btn.tip.visible = false;
        }

    }
}//package com.viroxoty.fashionista.boutique

