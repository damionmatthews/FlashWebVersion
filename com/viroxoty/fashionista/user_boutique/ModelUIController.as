// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.user_boutique.ModelUIController

package com.viroxoty.fashionista.user_boutique{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Item;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.AvatarController;
    import flash.events.MouseEvent;
    import flash.display.Sprite;
    import flash.net.URLRequest;
    import flash.display.Loader;
    import flash.geom.Rectangle;
    import flash.events.ProgressEvent;
    import flash.events.Event;
    import com.viroxoty.fashionista.ui.SnapshotController;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import com.viroxoty.fashionista.events.*;
    import com.viroxoty.fashionista.ui.*;
    import flash.display.*;
    import flash.geom.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class ModelUIController extends EventDispatcher {

        public static const MODEL_UI_CLOSED:String = "MODEL_UI_CLOSED";
        public static const MODEL_UI_OPENED:String = "MODEL_UI_OPENED";
        static const BOUTIQUE_ID:String = "100";
        static const HAIRS_COUNT:int = 58;
        static const EYES_COUNT:int = 21;
        static const LIPS_COUNT:int = 29;
        static const EYEBROWS_COUNT:int = 24;
        static const HAIR_PREMIUM_START:int = 34;
        static const EYES_PREMIUM_START:int = 17;
        static const LIPS_PREMIUM_START:int = 27;
        static const EYESHADOW_PREMIUM_START:int = 36;
        public static const SECTION_BOUTIQUE:int = 0;
        public static const SECTION_DRESSING_ROOM:int = 1;
        static const STYLE_BOUTIQUE_ID:String = "100";
        static const MODE_CLOSET:int = 0;
        static const MODE_MAKEUP:int = 1;
        static const MODE_SHOP:int = 2;
        private static const ITEMS_PER_PAGE:int = 9;
        private static const BORDER:int = 5;
        static const CLOSET_Y_ADJ:int = 10;

        private static var _current_instance:ModelUIController;
        private static var boutique_xml:XML;
        private static var boutique_hairs:Array;
        private static var boutique_eyes:Array;
        private static var boutique_lips:Array;
        private static var boutique_colors:Array;
        private static var total_items:int;

        public var section:int;
        private var user_style_purchases:Array;
        private var purchasable_item_clips:Array;
        private var purchasable_color_clips:Array;
        private var current_category:String;
        private var category_data:Vector.<Item>;
        private var total_data:int;
        public var ui:MovieClip;
        private var avatar_controller:AvatarController;
        public var model_vc:UserBoutiqueModelViewController;
        var mode:int = -1;
        private var closet_btn:MovieClip;
        private var makeup_btn:MovieClip;
        private var shop_btn:MovieClip;
        var menu_btn:MovieClip;
        var sub_menu:MovieClip;
        var sub_menu_btn:MovieClip;
        var makeup_menu_btn:MovieClip;
        private var closet_menu:MovieClip;
        private var closet_categories:Array;
        private var makeup_menu:MovieClip;
        private var makeup_categories:Array;
        private var current_count:int;
        private var item_container:MovieClip;
        private var item_container_mask:MovieClip;
        private var item_container_start_x:Number;
        private var catalog_bg:MovieClip;
        private var close_btn:MovieClip;
        private var close_btn_visible:Boolean = true;
        private var next_page:Boolean;
        private var prev_page:Boolean;
        private var next_btn:MovieClip;
        private var prev_btn:MovieClip;
        private var colors_mc:MovieClip;
        var container_y:Number;
        var nav_btn_y:Number;
        private var more_btn:MovieClip;
        private var last_page:Boolean;
        private var zoomed_in:Boolean;
        public var first_time_open:Boolean = true;

        public function ModelUIController(_arg1:MovieClip, _arg2:int=0){
            this.closet_categories = [{
                "menu":"dresses",
                "submenus":["dress_short", "dress_long"]
            }, {
                "menu":"tops",
                "submenus":["blouses", "coats", "jackets", "bathing_suits", "wing_coats"]
            }, {
                "menu":"bottoms",
                "submenus":["pants", "skirts", "tights", "shorts"]
            }, {
                "menu":"accessories",
                "submenus":["purses", "hats", "scarves", "belts", "gloves", "glasses", "masks", "wigs"]
            }, {"menu":"shoes"}, {
                "menu":"jewelry",
                "submenus":["earrings", "necklaces", "rings", "bracelets", "tiaras"]
            }, {
                "menu":"pets",
                "submenus":["dogs", "cats", "exotics"]
            }];
            this.makeup_categories = ["hair", "eyes", "lips", "eyebrows", "colors"];
            super();
            _current_instance = this;
            this.ui = _arg1;
            this.section = _arg2;
            this.init();
        }
        public static function current_instance():ModelUIController{
            return (_current_instance);
        }

        function init(){
            var _local2:* = this.ui;
            var _local2 = _local2;
            with (_local2)
            {
                closet_bg.visible = false;
                closet_bg.stop();
                close_btn.visible = false;
                prev_btn.visible = false;
                next_btn.visible = false;
                colors_mc.visible = false;
                closet_menu.visible = false;
                makeup_menu.visible = false;
                more_btn.visible = false;
                reset_btn.visible = false;
                info_bubble.visible = false;
            };
            this.current_count = 0;
            this.user_style_purchases = new Array();
            this.purchasable_color_clips = new Array();
            this.ui.enter_look_btn.buttonMode = true;
            this.ui.enter_look_btn.addEventListener(MouseEvent.CLICK, this.submit_look, false, 0, true);
            this.zoomed_in = false;
            Util.setupButton(this.ui.zoom_btn, null, false);
            this.ui.zoom_btn.addEventListener(MouseEvent.CLICK, this.click_zoom, false, 0, true);
            Util.setupButton(this.ui.camera_btn, null, false);
            this.ui.camera_btn.addEventListener(MouseEvent.CLICK, this.open_photo_ui, false, 0, true);
            Util.setupButton(this.ui.fcity_btn, null, false);
            this.ui.fcity_btn.addEventListener(MouseEvent.CLICK, this.click_fcity, false, 0, true);
            this.ui.fcity_btn.visible = false;
            Util.setupButton(this.ui.paris_btn, null, false);
            this.ui.paris_btn.addEventListener(MouseEvent.CLICK, this.click_paris, false, 0, true);
            this.ui.paris_btn.visible = false;
            this.setup_top_menu();
            this.setup_catalog_ui();
            if (this.section == SECTION_DRESSING_ROOM)
            {
                this.ui.reset_btn.visible = true;
                this.ui.reset_btn.buttonMode = true;
                this.ui.reset_btn.addEventListener(MouseEvent.CLICK, DressingRoom.getCurrentInstance().reset_model, false, 0, true);
            };
            if (((UserData.getInstance().first_time_visit()) && ((UserData.getInstance().fcash == 0))))
            {
                this.ui.shop_btn.visible = false;
            };
        }
        public function set_model(_arg1:UserBoutiqueModelViewController){
            if (this.avatar_controller)
            {
                this.avatar_controller.removeEventListener(AvatarController.ITEM_REMOVED, this.item_removed);
            };
            this.avatar_controller = _arg1.avatar_controller;
            this.avatar_controller.addEventListener(AvatarController.ITEM_REMOVED, this.item_removed, false, 0, true);
            this.model_vc = _arg1;
            this.set_highlights();
        }
        public function destroy(){
            _current_instance = null;
            if (this.avatar_controller)
            {
                this.avatar_controller.removeEventListener(AvatarController.ITEM_REMOVED, this.item_removed);
            };
            if (this.ui)
            {
                this.ui.zoom_btn.removeEventListener(MouseEvent.CLICK, this.click_zoom);
            };
        }
        public function load_item_data(){
            DataManager.getInstance().get_items_xml(STYLE_BOUTIQUE_ID, this, this.boutique_data_loaded);
        }
        public function style_item_purchased(_arg1:int):void{
            var _local2:MovieClip;
            var _local4:int;
            Tracer.out(("style_item_purchased : " + _arg1));
            this.user_style_purchases.push(_arg1);
            var _local3:int = this.purchasable_item_clips.length;
            while (_local4 < _local3)
            {
                _local2 = this.purchasable_item_clips[_local4];
                if (_local2.item.id == _arg1)
                {
                    Tracer.out("found movieclip in purchasable_item_clips");
                    _local2.removeChild(_local2.star);
                    _local2.removeEventListener(MouseEvent.CLICK, this.buy_item);
                    _local2.addEventListener(MouseEvent.CLICK, _local2.method);
                    this.purchasable_item_clips.splice(_local4, 1);
                    break;
                };
                _local4++;
            };
            _local3 = this.purchasable_color_clips.length;
            _local4 = 0;
            while (_local4 < _local3)
            {
                _local2 = this.purchasable_color_clips[_local4];
                if (_local2.item.id == _arg1)
                {
                    Tracer.out("found movieclip in purchasable_color_clips");
                    _local2.removeChild(_local2.star);
                    _local2.removeEventListener(MouseEvent.CLICK, this.buy_item);
                    _local2.addEventListener(MouseEvent.CLICK, _local2.method);
                    this.purchasable_color_clips.splice(_local4, 1);
                    return;
                };
                _local4++;
            };
        }
        public function closet_item_purchased(_arg1:Item):void{
            this.add_item(_arg1);
        }
        public function check_reload_category(_arg1:String):void{
            if (this.mode != MODE_CLOSET)
            {
                return;
            };
            if (this.closet_menu.visible)
            {
                if (this.menu_btn.name == _arg1)
                {
                    this.select_closet_category(_arg1);
                };
                if (this.sub_menu_btn)
                {
                    if (this.sub_menu_btn.name == _arg1)
                    {
                        this.select_closet_category(_arg1);
                    };
                };
            };
        }
        public function show_dressing_room_default():void{
            this.show_user_default();
            this.update_model_items();
        }
        public function update_highlights():void{
            this.set_highlights();
        }
        public function hide_enter_contest():void{
            this.ui.enter_look_btn.visible = false;
        }
        public function show_enter_contest():void{
            this.ui.enter_look_btn.visible = true;
        }
        public function hide_close_btn():void{
            this.close_btn_visible = false;
        }
        private function boutique_data_loaded(_arg1:XML){
            var _local2:XML;
            var _local3:Item;
            var _local5:int;
            boutique_xml = _arg1;
            boutique_hairs = [];
            boutique_colors = [];
            boutique_eyes = [];
            boutique_lips = [];
            var _local4:int = boutique_xml.children().length();
            Tracer.out((("boutique_data_loaded " + _local4) + " items"));
            Tracer.out(boutique_xml.toString());
            while (_local5 < _local4)
            {
                _local2 = boutique_xml.ITEM[_local5];
                _local3 = new Item();
                _local3.parseServerXML(_local2, true);
                switch (_local3.closet_category)
                {
                    case 6:
                        boutique_hairs.push(_local3);
                        break;
                    case 7:
                        boutique_eyes.push(_local3);
                        break;
                    case 8:
                        boutique_lips.push(_local3);
                        break;
                    case 10:
                        boutique_colors.push(_local3);
                        break;
                };
                _local5++;
            };
            Tracer.out((((((((("Purchasable styles counts: " + boutique_hairs.length) + " hair styles, ") + boutique_eyes.length) + " eye styles, ") + boutique_lips.length) + " lip styles, ") + boutique_colors.length) + " colors"));
            this.setup_colors_clip();
        }
        private function load_shop_data(_arg1:String):void{
            var _local2:int = DressingRoom.category_id_dict[_arg1];
            DataManager.getInstance().load_item_category(_local2, this.category_items_loaded, this.category_items_load_failed);
        }
        private function category_items_loaded(_arg1:Object):void{
            var _local2:Array;
            var _local3:int;
            var _local4:int;
            var _local5:Item;
            this.category_data = new Vector.<Item>();
            if (_arg1.items)
            {
                _local2 = _arg1.items;
                _local3 = _local2.length;
                _local4 = 0;
                for (;_local4 < _local3;_local4++)
                {
                    _local5 = new Item();
                    _local5.parseServerJSON(_local2[_local4]);
                    if (!UserData.getInstance().owns(_local5))
                    {
                        if (!_local5.hasRestriction(Constants.RESTRICTION_HIDDEN))
                        {
                            if (UserData.getInstance().first_time_visit())
                            {
                                if (_local5.level > 0) continue;
                                this.category_data.unshift(_local5);
                            } else
                            {
                                this.category_data.unshift(_local5);
                            };
                        };
                    };
                };
            };
            Tracer.out((("category_items_loaded: done processing; category data has  " + this.category_data.length) + " items"));
            MainViewController.getInstance().hide_preloader();
            this.load_shop_assets();
        }
        private function category_items_load_failed():void{
            MainViewController.getInstance().hide_preloader();
        }
        private function setup_top_menu():void{
            var co:Object;
            var cb:MovieClip;
            var submenu:MovieClip;
            var i:int;
            var setup_submenus:Function = function (_arg1:Array, _arg2:MovieClip){
                var _local3:String;
                var _local4:MovieClip;
                var _local5:int;
                var _local6:int = _arg1.length;
                while (_local5 < _local6)
                {
                    _local3 = _arg1[_local5];
                    _local4 = (_arg2[_local3] as MovieClip);
                    if (_local5 == 0)
                    {
                        _arg2["first_btn"] = _local4;
                    };
                    setup_closet_subcategory_btn(_local4);
                    _local5++;
                };
            };
            this.closet_btn = this.ui.closet_btn;
            Util.setupButton(this.closet_btn);
            this.closet_btn.addEventListener(MouseEvent.CLICK, this.display_closet, false, 0, true);
            this.makeup_btn = this.ui.makeup_btn;
            Util.setupButton(this.makeup_btn);
            this.makeup_btn.addEventListener(MouseEvent.CLICK, this.click_makeup, false, 0, true);
            this.shop_btn = this.ui.shop_btn;
            Util.setupButton(this.shop_btn);
            Util.create_tooltip("SEE ALL ITEMS YOU DON'T OWN!", this.ui, "right", "top", this.shop_btn);
            this.shop_btn.addEventListener(MouseEvent.CLICK, this.display_shop, false, 0, true);
            this.closet_menu = this.ui.closet_menu;
            var l:int = this.closet_categories.length;
            while (i < l)
            {
                co = this.closet_categories[i];
                cb = (this.closet_menu[co.menu] as MovieClip);
                this.setup_closet_btn(cb);
                Tracer.out(("ModelUIController > setting up " + co.menu));
                if (co.submenus != null)
                {
                    submenu = (this.ui[(co.menu + "_menu")] as MovieClip);
                    if (i > 0)
                    {
                        submenu.visible = false;
                    };
                    (setup_submenus(co.submenus, submenu));
                    cb.addEventListener(MouseEvent.CLICK, this.click_closet_menu_btn, false, 0, true);
                } else
                {
                    cb.addEventListener(MouseEvent.CLICK, this.click_closet_category, false, 0, true);
                };
                i = (i + 1);
            };
            this.makeup_menu = this.ui.makeup_menu;
            this.setup_makeup_btn(this.makeup_menu.hair);
            this.setup_makeup_btn(this.makeup_menu.eyes);
            this.setup_makeup_btn(this.makeup_menu.lips);
            this.setup_makeup_btn(this.makeup_menu.eyebrows);
            this.setup_makeup_btn(this.makeup_menu.colors);
        }
        private function setup_closet_subcategory_btn(_arg1:MovieClip){
            _arg1.addEventListener(MouseEvent.CLICK, this.click_closet_subcategory, false, 0, true);
            this.setup_closet_btn(_arg1);
        }
        private function setup_closet_btn(_arg1:MovieClip){
            _arg1.parent[("tip_" + _arg1.name)].visible = false;
            _arg1.addEventListener(MouseEvent.ROLL_OVER, this.rollover_top_btn, false, 0, true);
            _arg1.addEventListener(MouseEvent.ROLL_OUT, this.rollout_top_btn, false, 0, true);
            this.setup_btn(_arg1);
        }
        private function setup_makeup_btn(_arg1:MovieClip){
            _arg1.addEventListener(MouseEvent.CLICK, this.click_makeup_category, false, 0, true);
            this.setup_btn(_arg1);
        }
        private function setup_btn(_arg1:MovieClip){
            Util.setupButton(_arg1, _arg1.bg);
        }
        private function rollover_top_btn(_arg1:MouseEvent){
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.parent[("tip_" + _local2.name)].visible = true;
        }
        private function rollout_top_btn(_arg1:MouseEvent){
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.parent[("tip_" + _local2.name)].visible = false;
        }
        private function setup_catalog_ui():void{
            this.item_container = this.ui.item_container;
            this.item_container_mask = this.ui.closet_mask;
            this.item_container_start_x = this.item_container.x;
            this.container_y = this.item_container.y;
            this.catalog_bg = this.ui.closet_bg;
            this.close_btn = this.ui.close_btn;
            this.close_btn.buttonMode = true;
            this.close_btn.addEventListener(MouseEvent.CLICK, (((this.section == SECTION_BOUTIQUE)) ? this.close_catalog : this.nav_to_decorate), false, 0, true);
            this.prev_btn = this.ui.prev_btn;
            this.prev_btn.buttonMode = true;
            this.prev_btn.addEventListener(MouseEvent.CLICK, this.click_prev, false, 0, true);
            this.prev_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_glow, false, 0, true);
            this.prev_btn.addEventListener(MouseEvent.ROLL_OUT, this.hide_glow, false, 0, true);
            this.prev_btn.glow.visible = false;
            this.nav_btn_y = this.prev_btn.y;
            this.next_btn = this.ui.next_btn;
            this.next_btn.buttonMode = true;
            this.next_btn.addEventListener(MouseEvent.CLICK, this.click_next, false, 0, true);
            this.next_btn.addEventListener(MouseEvent.ROLL_OVER, this.show_glow, false, 0, true);
            this.next_btn.addEventListener(MouseEvent.ROLL_OUT, this.hide_glow, false, 0, true);
            this.next_btn.glow.visible = false;
            this.colors_mc = this.ui.colors_mc;
            this.more_btn = this.ui.more_btn;
            this.more_btn.buttonMode = true;
            this.more_btn.addEventListener(MouseEvent.CLICK, this.click_more, false, 0, true);
            this.hide_catalog();
        }
        public function display_closet(_arg1=null):void{
            var _local2:String;
            if (this.section == SECTION_DRESSING_ROOM)
            {
                dispatchEvent(new GameEvent(Events.DRESSING_ROOM_DISPLAY_CLOSET));
            };
            this.mode = MODE_CLOSET;
            this.hide_catalog();
            this.show_catalog();
            this.closet_btn.gotoAndStop(3);
            Util.disable_button(this.closet_btn);
            Util.enable_button(this.makeup_btn);
            Util.enable_button(this.shop_btn);
            this.closet_menu.visible = true;
            if (this.menu_btn == null)
            {
                this.open_sub_menu(this.closet_menu.dresses);
                this.show_closet_subcategory(this.sub_menu.first_btn);
            } else
            {
                if (this.sub_menu_btn)
                {
                    _local2 = this.menu_btn.name;
                    this.sub_menu = this.ui[(_local2 + "_menu")];
                    this.sub_menu.visible = true;
                    this.current_category = this.sub_menu_btn.name;
                } else
                {
                    this.current_category = this.menu_btn.name;
                };
            };
            this.category_data = DressingRoom.get_category_data(this.current_category);
            this.total_data = this.category_data.length;
            this.next_btn.visible = true;
            this.prev_btn.visible = true;
            this.load_closet_assets();
            this.model_vc.zoom_out();
        }
        function click_makeup(_arg1=null):void{
            if (this.mode != MODE_MAKEUP)
            {
                this.display_hair_makeup();
            } else
            {
                if (this.mode == MODE_MAKEUP)
                {
                    if (this.model_vc.zoomed_in)
                    {
                        this.model_vc.zoom_out();
                        this.zoomed_in = false;
                    } else
                    {
                        this.model_vc.zoom_in();
                        this.zoomed_in = true;
                    };
                };
            };
        }
        function display_hair_makeup():void{
            var _local1:String;
            if (this.section == SECTION_DRESSING_ROOM)
            {
                dispatchEvent(new GameEvent(Events.DRESSING_ROOM_DISPLAY_MAKEUP));
            };
            this.mode = MODE_MAKEUP;
            this.hide_catalog();
            this.show_catalog();
            this.makeup_btn.gotoAndStop(3);
            Util.enable_button(this.closet_btn);
            Util.enable_button(this.shop_btn);
            this.makeup_menu.visible = true;
            if (this.makeup_menu_btn == null)
            {
                this.makeup_menu_btn = this.makeup_menu.hair;
                this.show_btn_selected(this.makeup_menu_btn);
                _local1 = "hair";
            } else
            {
                _local1 = this.makeup_menu_btn.name;
            };
            this.next_btn.visible = true;
            this.prev_btn.visible = true;
            this.category_data = null;
            this.total_data = 0;
            this.load_makeup_assets(_local1);
            if (UserData.getInstance().first_time_visit() == false)
            {
                this.model_vc.zoom_in();
            };
        }
        private function display_shop(_arg1=null):void{
            var _local2:String;
            this.mode = MODE_SHOP;
            this.hide_catalog();
            this.show_catalog();
            this.ui.fcity_btn.visible = true;
            this.ui.paris_btn.visible = true;
            MainViewController.getInstance().show_preloader();
            this.closet_menu.visible = true;
            this.shop_btn.gotoAndStop(3);
            Util.disable_button(this.shop_btn);
            Util.enable_button(this.makeup_btn);
            Util.enable_button(this.closet_btn);
            this.next_btn.visible = true;
            this.prev_btn.visible = true;
            if (this.sub_menu_btn)
            {
                _local2 = this.menu_btn.name;
                this.sub_menu = this.ui[(_local2 + "_menu")];
                this.sub_menu.visible = true;
                this.current_category = this.sub_menu_btn.name;
            } else
            {
                this.current_category = this.menu_btn.name;
            };
            this.category_data = null;
            this.total_data = 0;
            this.load_shop_data(this.current_category);
            this.model_vc.zoom_out();
        }
        private function click_closet_menu_btn(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            if (_local2.buttonMode == false)
            {
                return;
            };
            this.open_sub_menu(_local2);
            this.show_closet_subcategory(this.sub_menu.first_btn);
        }
        private function open_sub_menu(_arg1:MovieClip):void{
            if (this.sub_menu)
            {
                this.sub_menu.visible = false;
            };
            this.reset_btn(this.menu_btn);
            this.reset_btn(this.sub_menu_btn);
            this.menu_btn = _arg1;
            this.show_btn_selected(this.menu_btn);
            var _local2:String = this.menu_btn.name;
            this.sub_menu = this.ui[(_local2 + "_menu")];
            this.sub_menu.visible = true;
        }
        private function click_closet_category(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            if (_local2.buttonMode == false)
            {
                return;
            };
            this.open_closet_category(_local2);
        }
        private function open_closet_category(_arg1:MovieClip):void{
            if (this.sub_menu)
            {
                this.sub_menu.visible = false;
                this.reset_btn(this.sub_menu_btn);
                this.sub_menu_btn = null;
            };
            this.reset_btn(this.menu_btn);
            this.menu_btn = _arg1;
            this.show_btn_selected(this.menu_btn);
            this.select_closet_category(this.menu_btn.name);
        }
        private function click_closet_subcategory(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            if (_local2.buttonMode == false)
            {
                return;
            };
            this.show_closet_subcategory(_local2);
        }
        private function show_closet_subcategory(_arg1:MovieClip):void{
            Tracer.out(("show_closet_subcategory : " + _arg1.name));
            this.reset_btn(this.sub_menu_btn);
            this.sub_menu_btn = _arg1;
            this.show_btn_selected(this.sub_menu_btn);
            this.select_closet_category(this.sub_menu_btn.name);
        }
        private function select_closet_category(_arg1:String):void{
            this.current_category = _arg1;
            this.current_count = 0;
            this.clear_item_container();
            this.disable_scroll();
            if (this.mode == MODE_SHOP)
            {
                this.category_data = null;
                this.total_data = 0;
                this.load_shop_data(this.current_category);
                return;
            };
            if (this.mode == MODE_CLOSET)
            {
                this.category_data = DressingRoom.get_category_data(_arg1);
                this.total_data = this.category_data.length;
                this.load_closet_assets();
            };
        }
        private function click_makeup_category(_arg1:MouseEvent):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            if (_local2.buttonMode == false)
            {
                return;
            };
            this.select_makeup_category(_local2);
        }
        private function select_makeup_category(_arg1:MovieClip):void{
            this.reset_btn(this.makeup_menu_btn);
            this.makeup_menu_btn = _arg1;
            this.show_btn_selected(this.makeup_menu_btn);
            this.total_data = 0;
            this.current_count = 0;
            this.colors_mc.visible = false;
            this.clear_item_container();
            this.disable_scroll();
            this.load_makeup_assets(this.makeup_menu_btn.name);
        }
        function show_btn_selected(_arg1:MovieClip):void{
            if (_arg1 == null)
            {
                return;
            };
            _arg1.bg.gotoAndStop(3);
            _arg1.mouseChildren = false;
            _arg1.buttonMode = false;
        }
        function reset_btn(_arg1:MovieClip):void{
            if (_arg1 == null)
            {
                return;
            };
            _arg1.buttonMode = true;
            _arg1.mouseChildren = true;
            _arg1.bg.gotoAndStop(1);
        }
        private function show_catalog():void{
            this.ui.visible = true;
            this.catalog_bg.visible = true;
            this.close_btn.visible = this.close_btn_visible;
            var _local1:* = (this.mode == MODE_MAKEUP);
            var _local2:int = ((_local1) ? 1 : 2);
            this.catalog_bg.gotoAndStop(_local2);
            var _local3:int = ((_local1) ? 0 : CLOSET_Y_ADJ);
            this.item_container.y = (this.container_y + (2 * _local3));
            this.item_container_mask.y = (this.container_y + (2 * _local3));
        }
        public function hide_catalog():void{
            this.ui.visible = false;
            this.clear_item_container();
            this.catalog_bg.visible = false;
            this.close_btn.visible = false;
            this.prev_page = false;
            this.next_page = false;
            this.prev_btn.visible = false;
            this.next_btn.visible = false;
            this.colors_mc.visible = false;
            this.more_btn.visible = false;
            this.closet_menu.visible = false;
            this.makeup_menu.visible = false;
            if (this.sub_menu)
            {
                this.sub_menu.visible = false;
            };
            this.ui.fcity_btn.visible = false;
            this.ui.paris_btn.visible = false;
        }
        private function disable_scroll():void{
            this.next_page = false;
            this.prev_page = false;
        }
        private function enable_scroll():void{
            if (this.last_page)
            {
                this.prev_page = true;
                this.next_page = false;
            } else
            {
                this.next_page = true;
                this.prev_page = false;
            };
        }
        private function show_next():void{
            this.current_count = (this.current_count + ITEMS_PER_PAGE);
            var _local1:int = ((this.makeup_menu.visible) ? this.total_data : (this.total_data + 1));
            if ((this.current_count + ITEMS_PER_PAGE) >= _local1)
            {
                this.next_page = false;
            };
            this.prev_page = true;
            if ((((this.mode == MODE_CLOSET)) || ((this.mode == MODE_SHOP))))
            {
                this.clear_item_container();
                this.load_page();
            } else
            {
                this.item_container.x = (this.item_container.x - 360);
            };
        }
        private function show_previous():void{
            this.current_count = (this.current_count - ITEMS_PER_PAGE);
            if (this.current_count == 0)
            {
                this.prev_page = false;
            };
            this.next_page = true;
            if ((((this.mode == MODE_CLOSET)) || ((this.mode == MODE_SHOP))))
            {
                this.clear_item_container();
                this.load_page();
            } else
            {
                this.item_container.x = (this.item_container.x + 360);
            };
        }
        private function close_catalog(_arg1:MouseEvent):void{
            this.hide_catalog();
            this.mode = -1;
            dispatchEvent(new Event(MODEL_UI_CLOSED));
        }
        private function nav_to_decorate(_arg1:MouseEvent):void{
            MyBoutique.getInstance().load();
        }
        private function clear_item_container(){
            while (this.item_container.numChildren > 0)
            {
                this.item_container.removeChildAt(0);
            };
            this.item_container.x = this.item_container_start_x;
        }
        private function show_next_category():void{
            var _local1:int;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:String;
            var _local7:String;
            var _local8:int;
            var _local9:Object;
            var _local10:Array;
            if ((((this.mode == MODE_CLOSET)) || ((this.mode == MODE_SHOP))))
            {
                _local6 = this.menu_btn.name;
                _local7 = (((this.sub_menu_btn)==null) ? null : this.sub_menu_btn.name);
                _local8 = 0;
                _local2 = this.closet_categories.length;
                _local1 = 0;
                while (_local1 < _local2)
                {
                    _local9 = this.closet_categories[_local1];
                    if (_local6 == _local9.menu)
                    {
                        if (_local7)
                        {
                            _local10 = _local9.submenus;
                            _local4 = _local10.length;
                            _local3 = 0;
                            while (_local3 < _local4)
                            {
                                if (_local7 == _local10[_local3])
                                {
                                    if (_local3 == (_local4 - 1))
                                    {
                                        _local5 = ((((_local1 + 1))<_local2) ? (_local1 + 1) : 0);
                                        break;
                                    };
                                    _local5 = _local1;
                                    _local8 = (_local3 + 1);
                                    break;
                                };
                                _local3++;
                            };
                        } else
                        {
                            _local5 = ((((_local1 + 1))<_local2) ? (_local1 + 1) : 0);
                            break;
                        };
                    };
                    _local1++;
                };
                if (this.closet_categories[_local5].submenus)
                {
                    this.open_sub_menu(this.closet_menu[this.closet_categories[_local5].menu]);
                    this.show_closet_subcategory(this.sub_menu[this.closet_categories[_local5].submenus[_local8]]);
                } else
                {
                    this.open_closet_category(this.closet_menu[this.closet_categories[_local5].menu]);
                };
            } else
            {
                if (this.mode == MODE_MAKEUP)
                {
                    _local6 = this.makeup_menu_btn.name;
                    _local2 = this.makeup_categories.length;
                    _local1 = 0;
                    while (_local1 < _local2)
                    {
                        if (_local6 == this.makeup_categories[_local1])
                        {
                            _local5 = ((((_local1 + 1))<_local2) ? (_local1 + 1) : 0);
                            break;
                        };
                        _local1++;
                    };
                    this.select_makeup_category(this.makeup_menu[this.makeup_categories[_local5]]);
                };
            };
        }
        private function show_previous_category():void{
            var _local1:int;
            var _local2:int;
            var _local3:int;
            var _local4:int;
            var _local5:int;
            var _local6:String;
            var _local7:String;
            var _local8:int;
            var _local9:Object;
            var _local10:Array;
            this.last_page = true;
            if ((((this.mode == MODE_CLOSET)) || ((this.mode == MODE_SHOP))))
            {
                _local6 = this.menu_btn.name;
                _local7 = (((this.sub_menu_btn)==null) ? null : this.sub_menu_btn.name);
                _local8 = 0;
                _local2 = this.closet_categories.length;
                _local1 = 0;
                while (_local1 < _local2)
                {
                    _local9 = this.closet_categories[_local1];
                    if (_local6 == _local9.menu)
                    {
                        if (_local7)
                        {
                            _local10 = _local9.submenus;
                            _local4 = _local10.length;
                            _local3 = 0;
                            while (_local3 < _local4)
                            {
                                if (_local7 == _local10[_local3])
                                {
                                    if (_local3 == 0)
                                    {
                                        _local5 = (((_local1)>0) ? (_local1 - 1) : (_local2 - 1));
                                        if (this.closet_categories[_local5].submenus)
                                        {
                                            _local8 = (this.closet_categories[_local5].submenus.length - 1);
                                        };
                                        break;
                                    };
                                    _local5 = _local1;
                                    _local8 = (_local3 - 1);
                                    break;
                                };
                                _local3++;
                            };
                        } else
                        {
                            _local5 = (((_local1)>0) ? (_local1 - 1) : (_local2 - 1));
                            if (this.closet_categories[_local5].submenus)
                            {
                                _local8 = (this.closet_categories[_local5].submenus.length - 1);
                            };
                            break;
                        };
                    };
                    _local1++;
                };
                if (this.closet_categories[_local5].submenus)
                {
                    this.open_sub_menu(this.closet_menu[this.closet_categories[_local5].menu]);
                    this.show_closet_subcategory(this.sub_menu[this.closet_categories[_local5].submenus[_local8]]);
                } else
                {
                    this.open_closet_category(this.closet_menu[this.closet_categories[_local5].menu]);
                };
            } else
            {
                if (this.mode == MODE_MAKEUP)
                {
                    _local6 = this.makeup_menu_btn.name;
                    _local2 = this.makeup_categories.length;
                    _local1 = 0;
                    while (_local1 < _local2)
                    {
                        if (_local6 == this.makeup_categories[_local1])
                        {
                            _local5 = (((_local1)>0) ? (_local1 - 1) : (_local2 - 1));
                            break;
                        };
                        _local1++;
                    };
                    this.select_makeup_category(this.makeup_menu[this.makeup_categories[_local5]]);
                };
            };
        }
        function click_next(_arg1:MouseEvent):void{
            if (this.next_page)
            {
                this.show_next();
            } else
            {
                this.show_next_category();
            };
        }
        function click_prev(_arg1:MouseEvent):void{
            if (this.prev_page)
            {
                this.show_previous();
            } else
            {
                this.show_previous_category();
            };
        }
        function show_glow(_arg1:MouseEvent):void{
            Tracer.out("show_glow");
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.glow.visible = true;
        }
        function hide_glow(_arg1:MouseEvent):void{
            Tracer.out("hide_glow");
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            _local2.glow.visible = false;
        }
        function load_page():void{
            if (this.mode == MODE_CLOSET)
            {
                this.load_closet_page();
            } else
            {
                if (this.mode != MODE_MAKEUP)
                {
                    if (this.mode == MODE_SHOP)
                    {
                        this.load_shop_page();
                    };
                };
            };
        }
        function load_closet_assets():void{
            this.total_data = this.category_data.length;
            if ((this.total_data + 1) > ITEMS_PER_PAGE)
            {
                this.enable_scroll();
            } else
            {
                this.disable_scroll();
            };
            if (this.last_page)
            {
                this.last_page = false;
                this.current_count = (Math.floor((this.total_data / ITEMS_PER_PAGE)) * ITEMS_PER_PAGE);
            } else
            {
                this.current_count = 0;
            };
            this.load_closet_page();
        }
        function load_closet_page():void{
            var i:int;
            var image_sprite:Sprite;
            var image_request:URLRequest;
            var image_loader:Loader;
            var closet_index:int;
            var item:Item;
            var swf:String;
            var outline_mc:MovieClip;
            var ow:Number;
            var oh:Number;
            var temp_x:* = undefined;
            var r_1:Rectangle;
            var xscale_1:Number;
            var yscale_1:Number;
            var scale_1:Number;
            var xpos:int;
            var ypos:int;
            var max:int = Math.min((this.current_count + ITEMS_PER_PAGE), this.total_data);
            MainViewController.getInstance().show_preloader();
            trace(((("max    " + max) + "   current_count   ") + this.current_count));
            i = this.current_count;
            while (i < max)
            {
                var image_load_Progress:* = function (_arg1:ProgressEvent):void{
                    MainViewController.getInstance().show_preloader();
                    trace((((" byte loaded    " + _arg1.bytesLoaded) + "   Total   ") + _arg1.bytesTotal));
                    if (_arg1.bytesLoaded == _arg1.bytesTotal)
                    {
                    };
                };
                var image_loaded:* = function (_arg1:Event){
                    var _local2:Loader = LoaderInfo(_arg1.currentTarget).loader;
                    var _local3:Rectangle = Util.getVisibleBoundingRectForAsset(_local2);
                    _local2.x = -(_local3.x);
                    _local2.y = -(_local3.y);
                    var _local4:Number = (ow / _local3.width);
                    var _local5:Number = (oh / _local3.height);
                    var _local6:Number = Math.min(_local4, _local5);
                    var _local7:Sprite = (_local2.parent as Sprite);
                    _local7.scaleX = _local6;
                    _local7.scaleY = _local6;
                    _local7.x = (BORDER + ((ow - (_local3.width * _local6)) / 2));
                    _local7.y = (BORDER + ((oh - (_local3.height * _local6)) / 2));
                    outline_mc.addChild(image_sprite);
                    MainViewController.getInstance().hide_preloader();
                };
                image_sprite = new Sprite();
                closet_index = ((this.total_data - 1) - i);
                item = this.category_data[closet_index];
                swf = item.swf;
                Tracer.out(("load_closet_assets : swf = " + swf));
                outline_mc = (MainViewController.getInstance().get_game_asset("closet_item_outline") as MovieClip);
                outline_mc.x = xpos;
                outline_mc.y = ypos;
                ow = (outline_mc.width - (BORDER * 2));
                oh = (outline_mc.height - (BORDER * 2));
                image_request = new URLRequest(swf);
                image_loader = new Loader();
                image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded);
                image_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, image_load_Progress, false, 0, true);
                image_loader.load(image_request);
                image_sprite.addChild(image_loader);
                outline_mc.name = String(closet_index);
                outline_mc.buttonMode = true;
                outline_mc.mouseChildren = false;
                outline_mc.addEventListener(MouseEvent.CLICK, this.click_closet_item, false, 0, true);
                outline_mc.addEventListener(MouseEvent.ROLL_OVER, this.preview_item, false, 0, true);
                outline_mc.addEventListener(MouseEvent.ROLL_OUT, this.unpreview_item, false, 0, true);
                outline_mc.x = xpos;
                outline_mc.y = ypos;
                this.item_container.addChild(outline_mc);
                xpos = (xpos + 120);
                temp_x = xpos;
                if (((i + 1) % 3) == 0)
                {
                    xpos = (xpos - 360);
                    ypos = (ypos + 123);
                };
                if (((i + 1) % 9) == 0)
                {
                    xpos = temp_x;
                    ypos = 0;
                };
                if (image_sprite != null)
                {
                    r_1 = new Rectangle(0, 0, 96, 120);
                    xscale_1 = (ow / r_1.width);
                    yscale_1 = (oh / r_1.height);
                    scale_1 = Math.min(xscale_1, yscale_1);
                    image_sprite.scaleX = scale_1;
                    image_sprite.scaleY = scale_1;
                    image_sprite.x = (BORDER + ((ow - (r_1.width * scale_1)) / 2));
                    image_sprite.y = (BORDER + ((oh - (r_1.height * scale_1)) / 2));
                };
                outline_mc.addChild(image_sprite);
                i = (i + 1);
            };
            MainViewController.getInstance().hide_preloader();
            if (i == this.total_data)
            {
                this.more_btn.x = xpos;
                this.more_btn.y = ypos;
                this.item_container.addChild(this.more_btn);
                this.more_btn.visible = true;
            };
        }
        private function load_makeup_assets(_arg1:String):void{
            var _local2:int;
            var _local3:String;
            var _local4:int;
            var _local5:String;
            var _local6:MovieClip;
            var _local7:MovieClip;
            var _local8:Array;
            var _local9:int;
            var _local10:*;
            var _local11:int;
            var _local12:int;
            var _local13:Array = [];
            this.purchasable_item_clips = [];
            if (_arg1 == "hair")
            {
                _local2 = 0;
                while (_local2 <= HAIRS_COUNT)
                {
                    _local13.push(("thumb_hair_" + _local2));
                    _local2++;
                };
            } else
            {
                if (_arg1 == "eyes")
                {
                    _local2 = 0;
                    while (_local2 <= EYES_COUNT)
                    {
                        if (!(((_local2 == 9)) || ((_local2 == 16))))
                        {
                            _local13.push(("thumb_eye_" + _local2));
                        };
                        _local2++;
                    };
                    _local3 = _local13.pop();
                    _local13.splice(1, 0, _local3);
                } else
                {
                    if (_arg1 == "lips")
                    {
                        _local2 = 0;
                        while (_local2 <= LIPS_COUNT)
                        {
                            _local13.push(("thumb_lips_" + _local2));
                            _local2++;
                        };
                    } else
                    {
                        if (_arg1 == "eyebrows")
                        {
                            _local2 = 0;
                            while (_local2 <= EYEBROWS_COUNT)
                            {
                                _local13.push(("thumb_eyebrows_" + _local2));
                                _local2++;
                            };
                        } else
                        {
                            if (_arg1 == "colors")
                            {
                                this.prev_page = false;
                                this.next_page = false;
                                this.show_colors_clip();
                            } else
                            {
                                Tracer.out((("load_makeup_assets > ERROR : section " + _arg1) + " does not exist"));
                                return;
                            };
                        };
                    };
                };
            };
            this.total_data = (_local13.length - 1);
            if (this.total_data > 9)
            {
                this.enable_scroll();
            } else
            {
                this.disable_scroll();
            };
            if (this.last_page)
            {
                this.last_page = false;
                _local4 = Math.ceil((this.total_data / ITEMS_PER_PAGE));
                this.current_count = ((_local4 - 1) * ITEMS_PER_PAGE);
                this.item_container.x = (this.item_container.x - ((_local4 - 1) * 360));
                Tracer.out(((("total_data = " + this.total_data) + ", pages = ") + _local4));
            } else
            {
                this.current_count = 0;
            };
            _local2 = 1;
            while (_local2 < (this.total_data + 1))
            {
                _local5 = _local13[_local2];
                _local6 = (MainViewController.getInstance().get_game_asset("closet_item_outline") as MovieClip);
                _local7 = (MainViewController.getInstance().get_game_asset(_local5) as MovieClip);
                _local6.addChild(_local7);
                this.item_container.addChild(_local6);
                _local8 = _local5.split("_");
                _local9 = _local8[(_local8.length - 1)];
                _local6.name = String(_local9);
                _local6.x = _local11;
                _local6.y = _local12;
                _local6.buttonMode = true;
                if (_arg1 == "hair")
                {
                    if (_local9 >= HAIR_PREMIUM_START)
                    {
                        this.check_purchase((("hair" + _local9) + ".swf"), DressingRoom.get_category_data("hair_styles"), "hair", boutique_hairs, _local6);
                    } else
                    {
                        _local6.addEventListener(MouseEvent.ROLL_OVER, this.preview_hair, false, 0, true);
                        _local6.addEventListener(MouseEvent.ROLL_OUT, this.unpreview_hair, false, 0, true);
                        _local6.addEventListener(MouseEvent.CLICK, this.set_hair, false, 0, true);
                    };
                } else
                {
                    if (_arg1 == "eyes")
                    {
                        if (int(_local9) >= EYES_PREMIUM_START)
                        {
                            this.check_purchase((("eyes" + int(_local9)) + ".swf"), DressingRoom.get_category_data("eyes"), "eyes", boutique_eyes, _local6);
                        } else
                        {
                            _local6.addEventListener(MouseEvent.ROLL_OVER, this.preview_eyes, false, 0, true);
                            _local6.addEventListener(MouseEvent.ROLL_OUT, this.unpreview_eyes, false, 0, true);
                            _local6.addEventListener(MouseEvent.CLICK, this.set_eyes, false, 0, true);
                        };
                    } else
                    {
                        if (_arg1 == "lips")
                        {
                            if (_local9 >= LIPS_PREMIUM_START)
                            {
                                this.check_purchase((("lips" + _local9) + ".swf"), DressingRoom.get_category_data("lips"), "lips", boutique_lips, _local6);
                            } else
                            {
                                _local6.addEventListener(MouseEvent.ROLL_OVER, this.preview_lips, false, 0, true);
                                _local6.addEventListener(MouseEvent.ROLL_OUT, this.unpreview_lips, false, 0, true);
                                _local6.addEventListener(MouseEvent.CLICK, this.set_lips, false, 0, true);
                            };
                        } else
                        {
                            if (_arg1 == "eyebrows")
                            {
                                _local6.addEventListener(MouseEvent.ROLL_OVER, this.preview_eyebrows, false, 0, true);
                                _local6.addEventListener(MouseEvent.ROLL_OUT, this.unpreview_eyebrows, false, 0, true);
                                _local6.addEventListener(MouseEvent.CLICK, this.set_eyebrows, false, 0, true);
                            };
                        };
                    };
                };
                _local11 = (_local11 + 120);
                _local10 = _local11;
                if ((_local2 % 3) == 0)
                {
                    _local11 = (_local11 - 360);
                    _local12 = (_local12 + 123);
                };
                if ((_local2 % 9) == 0)
                {
                    _local11 = _local10;
                    _local12 = 0;
                };
                _local2++;
            };
        }
        private function check_purchase(_arg1:String, _arg2:Vector.<Item>, _arg3:String, _arg4:Array, _arg5:MovieClip, _arg6:Boolean=false){
            var _local7:Item;
            var _local8:int;
            var _local9:String;
            var _local10:Array;
            var _local11:String;
            var _local12:String;
            var _local13:int = _arg2.length;
            Tracer.out(("check_purchase > category_data length is " + _local13));
            if (_local13 > 0)
            {
                _local8 = 0;
                while (_local8 < _local13)
                {
                    _local7 = _arg2[_local8];
                    _local9 = _local7.swf;
                    _local10 = _local9.split("/");
                    _local11 = _local10[(_local10.length - 1)];
                    if (_local11 == _arg1)
                    {
                        Tracer.out((("user owns " + _arg1) + "!"));
                        _arg5.addEventListener(MouseEvent.ROLL_OVER, this[("preview_" + _arg3)], false, 0, true);
                        _arg5.addEventListener(MouseEvent.ROLL_OUT, this[("unpreview_" + _arg3)], false, 0, true);
                        _arg5.addEventListener(MouseEvent.CLICK, this[("set_" + _arg3)], false, 0, true);
                        return;
                    };
                    _local8++;
                };
            };
            _local13 = _arg4.length;
            Tracer.out(("looking for item : " + _arg1));
            _local8 = 0;
            while (_local8 < _local13)
            {
                _local7 = _arg4[_local8];
                _local9 = _local7.swf;
                _local10 = _local9.split("/");
                _local12 = _local10[(_local10.length - 1)];
                if (_local12 == _arg1) break;
                _local8++;
            };
            _local13 = this.user_style_purchases.length;
            _local8 = 0;
            while (_local8 < _local13)
            {
                if (_local7.id == this.user_style_purchases[_local8])
                {
                    Tracer.out("found item in user_style_purchases; user owns");
                    _arg5.addEventListener(MouseEvent.ROLL_OVER, this[("preview_" + _arg3)], false, 0, true);
                    _arg5.addEventListener(MouseEvent.ROLL_OUT, this[("unpreview_" + _arg3)], false, 0, true);
                    _arg5.addEventListener(MouseEvent.CLICK, this[("set_" + _arg3)], false, 0, true);
                    return;
                };
                _local8++;
            };
            Tracer.out(((("storing data: mc is " + _arg5) + ", item is ") + _local7.name));
            _arg5.item = _local7;
            Tracer.out("adding star");
            var _local14:MovieClip = (MainViewController.getInstance().get_game_asset("premium_star") as MovieClip);
            _arg5.star = _local14;
            _arg5.addChild(_local14);
            if (_arg5.level > UserData.getInstance().level)
            {
                Util.create_tooltip((("LEVEL " + _arg5.level) + " ITEM"), this.ui, "right", "bottom", _arg5);
            };
            _arg5.addEventListener(MouseEvent.CLICK, this.buy_item, false, 0, true);
            _arg5.addEventListener(MouseEvent.ROLL_OVER, this[("preview_" + _arg3)], false, 0, true);
            _arg5.addEventListener(MouseEvent.ROLL_OUT, this[("unpreview_" + _arg3)], false, 0, true);
            _arg5.method = this[("set_" + _arg3)];
            Tracer.out("adding to clips");
            if (_arg6)
            {
                this.purchasable_color_clips.push(_arg5);
            } else
            {
                this.purchasable_item_clips.push(_arg5);
            };
        }
        private function buy_item(_arg1:MouseEvent):void{
            var _local2:MovieClip = MovieClip(_arg1.currentTarget);
            if (_local2.item.fb_credits)
            {
                _local2.item.swf = _local2.item.png;
            };
            UserData.getInstance().buy_item(_local2.item);
            if (_local2.category == "10")
            {
                this.avatar_controller.set_avatar_haircolor(this.model_vc.data.style_obj.hair_color);
            };
        }
        private function preview_hair(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.preview_hair(_local2);
        }
        private function unpreview_hair(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.unpreview_hair(_local2);
        }
        private function set_hair(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name);
            this.model_vc.data.style_obj.hair = _local2;
            this.avatar_controller.set_hair(_local2);
            this.styles_updated();
        }
        private function preview_eyes(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.preview_eyes(_local2);
        }
        private function unpreview_eyes(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.unpreview_eyes(_local2);
        }
        private function set_eyes(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name);
            this.avatar_controller.set_eyes(_local2);
            this.model_vc.data.style_obj.eyes = _local2;
            this.styles_updated();
        }
        private function preview_lips(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.preview_lips(_local2);
        }
        private function unpreview_lips(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.unpreview_lips(_local2);
        }
        private function set_lips(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name);
            this.avatar_controller.set_lips(_local2);
            this.model_vc.data.style_obj.lips = _local2;
            this.styles_updated();
        }
        private function preview_eyebrows(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.preview_eyebrows(_local2);
        }
        private function unpreview_eyebrows(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.unpreview_eyebrows(_local2);
        }
        private function set_eyebrows(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name);
            this.avatar_controller.set_eyebrows(_local2);
            this.model_vc.data.style_obj.eyebrows = _local2;
            this.styles_updated();
        }
        private function setup_colors_clip():void{
            var _local1:int;
            var _local2:MovieClip;
            Tracer.out("setup_colors_clip");
            _local1 = 1;
            while (_local1 <= Styles.MAX_EYE_SHADE)
            {
                if (_local1 <= Styles.MAX_HAIR_COLOR)
                {
                    _local2 = this.colors_mc.hair_colors[("mc_" + _local1)];
                    _local2.buttonMode = true;
                    if (_local1 >= 7)
                    {
                        this.check_purchase((("hairColor" + _local1) + ".swf"), DressingRoom.get_category_data("colors"), "hair_color", boutique_colors, _local2, true);
                    } else
                    {
                        _local2.addEventListener(MouseEvent.MOUSE_OVER, this.preview_hair_color);
                        _local2.addEventListener(MouseEvent.MOUSE_OUT, this.unpreview_hair_color);
                        _local2.addEventListener(MouseEvent.CLICK, this.set_hair_color, false, 0, true);
                    };
                };
                if (_local1 <= Styles.MAX_SKIN)
                {
                    _local2 = this.colors_mc.skin_tone_colors[("mc_" + _local1)];
                    _local2.buttonMode = true;
                    _local2.addEventListener(MouseEvent.CLICK, this.set_skin_tone, false, 0, true);
                    _local2.addEventListener(MouseEvent.MOUSE_OVER, this.show_current_skin_color);
                    _local2.addEventListener(MouseEvent.MOUSE_OUT, this.remove_current_skin_color);
                };
                if (_local1 <= Styles.MAX_BLUSH)
                {
                    _local2 = this.colors_mc.blush_colors[("mc_" + _local1)];
                    _local2.buttonMode = true;
                    _local2.addEventListener(MouseEvent.CLICK, this.set_blush_colors, false, 0, true);
                    _local2.addEventListener(MouseEvent.MOUSE_OVER, this.show_current_blush_color);
                    _local2.addEventListener(MouseEvent.MOUSE_OUT, this.remove_current_blush_color);
                };
                if (_local1 <= Styles.MAX_EYE_COLOR)
                {
                    _local2 = this.colors_mc.eye_colors[("mc_" + _local1)];
                    _local2.buttonMode = true;
                    _local2.addEventListener(MouseEvent.CLICK, this.set_eye_color, false, 0, true);
                    _local2.addEventListener(MouseEvent.MOUSE_OVER, this.show_current_eye_color);
                    _local2.addEventListener(MouseEvent.MOUSE_OUT, this.remove_current_eye_color);
                };
                if (_local1 <= Styles.MAX_LIP_COLOR)
                {
                    _local2 = this.colors_mc.lip_colors[("mc_" + _local1)];
                    _local2.buttonMode = true;
                    _local2.addEventListener(MouseEvent.CLICK, this.set_lip_color, false, 0, true);
                    _local2.addEventListener(MouseEvent.MOUSE_OVER, this.show_current_lip_color);
                    _local2.addEventListener(MouseEvent.MOUSE_OUT, this.remove_current_lip_color);
                };
                _local2 = this.colors_mc.eye_shades[("mc_" + _local1)];
                _local2.buttonMode = true;
                if (_local1 > EYESHADOW_PREMIUM_START)
                {
                    this.check_purchase((("eyeshadow_" + _local1) + ".swf"), DressingRoom.get_category_data("colors"), "eye_shade", boutique_colors, _local2, true);
                } else
                {
                    _local2.addEventListener(MouseEvent.MOUSE_OVER, this.preview_eye_shade);
                    _local2.addEventListener(MouseEvent.MOUSE_OUT, this.unpreview_eye_shade);
                    _local2.addEventListener(MouseEvent.CLICK, this.set_eye_shade, false, 0, true);
                };
                _local1++;
            };
        }
        private function show_colors_clip():void{
            this.colors_mc.visible = true;
            this.set_highlights();
        }
        private function show_current_skin_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.show_avatar_skintone(_local2);
        }
        private function remove_current_skin_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.remove_avatar_skintone(_local2);
        }
        private function set_skin_tone(_arg1:MouseEvent):void{
            var _local2:* = Object(_arg1.currentTarget.parent.high_lighter_mc);
            _local2.x = _arg1.currentTarget.x;
            _local2.y = _arg1.currentTarget.y;
            _local2.visible = true;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.set_avatar_skintone(_local3);
            this.model_vc.data.style_obj.skin = _local3;
            this.styles_updated();
        }
        private function preview_hair_color(_arg1:MouseEvent):void{
            var _local2:MovieClip;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.show_avatar_haircolor(_local3);
            if (_arg1.currentTarget.item)
            {
                _local2 = this.ui.info_bubble;
                _local2.name_txt.text = _arg1.currentTarget.item.name;
                _local2.cost_txt.text = (_arg1.currentTarget.item.price + " FashionCash");
                _local2.visible = true;
            };
        }
        private function unpreview_hair_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.remove_avatar_haircolor(_local2);
            this.ui.info_bubble.visible = false;
        }
        private function set_hair_color(_arg1:MouseEvent):void{
            var _local2:* = Object(_arg1.currentTarget.parent.high_lighter_mc);
            _local2.x = _arg1.currentTarget.x;
            _local2.y = _arg1.currentTarget.y;
            _local2.visible = true;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            Tracer.out(("DressingRoom > set hair color : " + _local3));
            this.avatar_controller.set_avatar_haircolor(_local3);
            this.model_vc.data.style_obj.hair_color = _local3;
            this.styles_updated();
        }
        private function show_current_eye_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.show_avatar_eyecolor(_local2);
        }
        private function remove_current_eye_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.remove_avatar_eyecolor(_local2);
        }
        private function set_eye_color(_arg1:MouseEvent):void{
            var _local2:* = Object(_arg1.currentTarget.parent.high_lighter_mc);
            _local2.x = _arg1.currentTarget.x;
            _local2.y = _arg1.currentTarget.y;
            _local2.visible = true;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.set_avatar_eyecolor(_local3);
            this.model_vc.data.style_obj.eye_color = _local3;
            this.styles_updated();
        }
        private function show_current_lip_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.show_avatar_lipcolor(_local2);
        }
        private function remove_current_lip_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.remove_avatar_lipcolor(_local2);
        }
        private function set_lip_color(_arg1:MouseEvent):void{
            var _local2:* = Object(_arg1.currentTarget.parent.high_lighter_mc);
            _local2.x = _arg1.currentTarget.x;
            _local2.y = _arg1.currentTarget.y;
            _local2.visible = true;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.set_avatar_lipcolor(_local3);
            this.model_vc.data.style_obj.lip_color = _local3;
            this.styles_updated();
        }
        private function preview_eye_shade(_arg1:MouseEvent):void{
            var _local2:MovieClip;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.show_avatar_eyeshade(_local3);
            if (_arg1.currentTarget.item)
            {
                _local2 = this.ui.info_bubble;
                _local2.name_txt.text = _arg1.currentTarget.item.name;
                _local2.cost_txt.text = (_arg1.currentTarget.item.price + " FashionCash");
                _local2.visible = true;
            };
        }
        private function unpreview_eye_shade(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.remove_avatar_eyeshade(_local2);
            this.ui.info_bubble.visible = false;
        }
        private function set_eye_shade(_arg1:MouseEvent):void{
            var _local2:* = Object(_arg1.currentTarget.parent.high_lighter_mc);
            _local2.x = _arg1.currentTarget.x;
            _local2.y = _arg1.currentTarget.y;
            _local2.visible = true;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.set_avatar_eyeshade(_local3);
            this.model_vc.data.style_obj.eye_shade = _local3;
            this.styles_updated();
        }
        private function show_current_blush_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.set_avatar_blushcolor(_local2);
        }
        private function remove_current_blush_color(_arg1:MouseEvent):void{
            var _local2:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.set_avatar_blushcolor(_local2);
        }
        private function set_blush_colors(_arg1:MouseEvent):void{
            var _local2:* = Object(_arg1.currentTarget.parent.high_lighter_mc);
            _local2.x = _arg1.currentTarget.x;
            _local2.y = _arg1.currentTarget.y;
            _local2.visible = true;
            var _local3:* = int(_arg1.currentTarget.name.split("mc_").join(""));
            this.avatar_controller.set_avatar_blushcolor(_local3);
            this.model_vc.data.style_obj.blush = _local3;
            this.styles_updated();
        }
        private function set_highlights():void{
            var _local1:MovieClip;
            Tracer.out(((("set_highlights: colors_mc is " + this.colors_mc) + ", model_vc.data.style_obj is ") + this.model_vc.data.style_obj));
            _local1 = this.colors_mc.skin_tone_colors[("mc_" + this.model_vc.data.style_obj.skin)];
            this.colors_mc.skin_tone_colors.high_lighter_mc.x = _local1.x;
            this.colors_mc.skin_tone_colors.high_lighter_mc.y = _local1.y;
            _local1 = this.colors_mc.hair_colors[("mc_" + this.model_vc.data.style_obj.hair_color)];
            this.colors_mc.hair_colors.high_lighter_mc.x = _local1.x;
            this.colors_mc.hair_colors.high_lighter_mc.y = _local1.y;
            _local1 = this.colors_mc.eye_colors[("mc_" + this.model_vc.data.style_obj.eye_color)];
            this.colors_mc.eye_colors.high_lighter_mc.x = _local1.x;
            this.colors_mc.eye_colors.high_lighter_mc.y = _local1.y;
            _local1 = this.colors_mc.blush_colors[("mc_" + this.model_vc.data.style_obj.blush)];
            this.colors_mc.blush_colors.high_lighter_mc.x = _local1.x;
            this.colors_mc.blush_colors.high_lighter_mc.y = _local1.y;
            _local1 = this.colors_mc.lip_colors[("mc_" + this.model_vc.data.style_obj.lip_color)];
            this.colors_mc.lip_colors.high_lighter_mc.x = _local1.x;
            this.colors_mc.lip_colors.high_lighter_mc.y = _local1.y;
            _local1 = this.colors_mc.eye_shades[("mc_" + this.model_vc.data.style_obj.eye_shade)];
            this.colors_mc.eye_shades.high_lighter_mc.x = _local1.x;
            this.colors_mc.eye_shades.high_lighter_mc.y = _local1.y;
        }
        function load_shop_assets():void{
            this.total_data = this.category_data.length;
            if (this.total_data > ITEMS_PER_PAGE)
            {
                this.enable_scroll();
            } else
            {
                this.disable_scroll();
            };
            Tracer.out(("last_page is " + this.last_page));
            if (this.last_page)
            {
                this.last_page = false;
                this.current_count = Math.max(0, ((Math.ceil((this.total_data / ITEMS_PER_PAGE)) - 1) * ITEMS_PER_PAGE));
            } else
            {
                this.current_count = 0;
            };
            this.load_shop_page();
        }
        function load_shop_page():void{
            var i:int;
            var image_sprite:Sprite;
            var image_request:URLRequest;
            var image_loader:Loader;
            var item:Item;
            var swf:String;
            var outline_mc:MovieClip;
            var ow:Number;
            var oh:Number;
            var xpos:int;
            var ypos:int;
            var image_loaded:Function;
            var temp_x:* = undefined;
            Tracer.out(("current_count is " + this.current_count));
            var max:int = Math.min((this.current_count + ITEMS_PER_PAGE), this.total_data);
            i = this.current_count;
            while (i < max)
            {
                image_loaded = function (_arg1:Event){
                    var _local2:Loader = LoaderInfo(_arg1.currentTarget).loader;
                    var _local3:Rectangle = Util.getVisibleBoundingRectForAsset(_local2);
                    _local2.x = -(_local3.x);
                    _local2.y = -(_local3.y);
                    var _local4:Number = (ow / _local3.width);
                    var _local5:Number = (oh / _local3.height);
                    var _local6:Number = Math.min(_local4, _local5);
                    var _local7:Sprite = (_local2.parent as Sprite);
                    _local7.scaleX = _local6;
                    _local7.scaleY = _local6;
                    _local7.x = (BORDER + ((ow - (_local3.width * _local6)) / 2));
                    _local7.y = (BORDER + ((oh - (_local3.height * _local6)) / 2));
                    outline_mc.addChild(image_sprite);
                };
                image_sprite = new Sprite();
                item = this.category_data[i];
                swf = item.swf;
                Tracer.out(("load_closet_assets : swf = " + swf));
                outline_mc = (MainViewController.getInstance().get_game_asset("closet_item_outline") as MovieClip);
                outline_mc.x = xpos;
                outline_mc.y = ypos;
                ow = (outline_mc.width - 10);
                oh = (outline_mc.height - 10);
                image_request = new URLRequest(swf);
                image_loader = new Loader();
                image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded, false, 0, true);
                image_loader.load(image_request);
                image_sprite.addChild(image_loader);
                outline_mc.name = String(i);
                outline_mc.x = xpos;
                outline_mc.y = ypos;
                outline_mc.buttonMode = true;
                outline_mc.mouseChildren = false;
                outline_mc.addEventListener(MouseEvent.CLICK, this.show_buy_ui, false, 0, true);
                outline_mc.addEventListener(MouseEvent.ROLL_OVER, this.preview_item, false, 0, true);
                outline_mc.addEventListener(MouseEvent.ROLL_OUT, this.unpreview_item, false, 0, true);
                this.item_container.addChild(outline_mc);
                xpos = (xpos + 120);
                temp_x = xpos;
                if (((i + 1) % 3) == 0)
                {
                    xpos = (xpos - 360);
                    ypos = (ypos + 123);
                };
                if (((i + 1) % 9) == 0)
                {
                    xpos = temp_x;
                    ypos = 0;
                };
                outline_mc.addChild(image_sprite);
                i = (i + 1);
            };
        }
        private function click_closet_item(_arg1:MouseEvent):void{
            var _local2:int = int(_arg1.currentTarget.name);
            var _local3:Item = this.category_data[_local2];
            this.add_item(_local3);
        }
        private function add_item(_arg1:Item){
            if (this.section == SECTION_DRESSING_ROOM)
            {
                dispatchEvent(new GameEvent(Events.DRESSING_ROOM_ADD_ITEM));
            };
            var _local2:String = _arg1.swf;
            var _local3:int = _arg1.id;
            var _local4:String = _arg1.category.toLowerCase();
            Tracer.out(("avatar item_ids before adding = " + this.avatar_controller.get_avatar_item_ids()));
            if (this.menu_btn.name == "pets")
            {
                this.avatar_controller.add_pet_model(_local4, _local2, _local3);
                if (this.section == SECTION_DRESSING_ROOM)
                {
                    DressingRoom.user_default_pet_model = _arg1;
                };
            } else
            {
                this.avatar_controller.add_item(_local4, _local2, _local3);
                if (this.section == SECTION_DRESSING_ROOM)
                {
                    DressingRoom.update_user_default_clothing(_arg1);
                };
            };
            Tracer.out(("avatar item_ids = " + this.avatar_controller.get_avatar_item_ids()));
            this.update_model_items();
        }
        function show_buy_ui(_arg1:MouseEvent):void{
            var _local2:int = int(_arg1.currentTarget.name);
            var _local3:Item = this.category_data[_local2];
            UserData.getInstance().buy_item(_local3);
        }
        function preview_item(_arg1:MouseEvent):void{
            var _local2:MovieClip;
            var _local3:int = int(_arg1.currentTarget.name);
            var _local4:Item = this.category_data[_local3];
            this.avatar_controller.preview_item(_local4);
            if (this.mode == MODE_SHOP)
            {
                _local2 = this.ui.info_bubble;
                _local2.name_txt.text = _local4.name;
                if (_local4.fb_credits)
                {
                    _local2.cost_txt.text = (_local4.cost_fbcredits + " Facebook Credits");
                } else
                {
                    _local2.cost_txt.text = (_local4.price + " FashionCash");
                };
                _local2.visible = true;
            };
        }
        function unpreview_item(_arg1:MouseEvent):void{
            var _local2:int = int(_arg1.currentTarget.name);
            var _local3:Item = this.category_data[_local2];
            this.avatar_controller.unpreview_item(_local3);
            this.ui.info_bubble.visible = false;
        }
        function item_removed(_arg1=null):void{
            Tracer.out("item_removed");
            this.update_model_items();
        }
        public function update_model_items(_arg1:Boolean=true):void{
            var _local4:int;
            this.model_vc.data.items = this.avatar_controller.get_avatar_items();
            this.model_vc.data.pet = this.avatar_controller.pet_model;
            var _local2:int = this.model_vc.data.items.length;
            var _local3:* = (_local2 > 0);
            while (_local4 < _local2)
            {
                Tracer.out(("iterating model items to check for defaults : id is " + this.model_vc.data.items[_local4].id));
                if (this.model_vc.data.items[_local4].id == 0)
                {
                    _local3 = false;
                    break;
                };
                _local4++;
            };
            Tracer.out(("enterable is " + _local3));
            this.ui.enter_look_btn.visible = _local3;
            this.update_model_data();
        }
        function styles_updated(_arg1=null):void{
            this.update_model_data();
        }
        function update_model_data():void{
            Tracer.out(("update_model_data : section is " + this.section));
            if (this.section == SECTION_BOUTIQUE)
            {
                DataManager.getInstance().update_my_boutique_model(this.model_vc.data);
            } else
            {
                if (this.section == SECTION_DRESSING_ROOM)
                {
                    DressingRoom.save_user_defaults();
                };
            };
        }
        function click_zoom(_arg1=null){
            if (this.zoomed_in == false)
            {
                this.zoomed_in = true;
                this.model_vc.zoom_in();
            } else
            {
                this.zoomed_in = false;
                this.model_vc.zoom_out();
            };
        }
        private function click_more(_arg1:MouseEvent):void{
            if ((((((this.section == SECTION_DRESSING_ROOM)) && (UserData.getInstance().first_time_visit()))) && ((Tracker.first_time_add_more_items == false))))
            {
                Tracker.first_time_add_more_items = true;
                Tracker.track_first_time(Tracker.ADD_MORE_ITEMS);
            };
            if (UserData.getInstance().first_time_visit())
            {
                Pop_Up.getInstance().display_popup(Pop_Up.BOUTIQUE_DIRECTORY);
            } else
            {
                this.display_shop();
            };
        }
        private function submit_look(_arg1:MouseEvent=null):void{
            if (this.final_item_check() == false)
            {
                return;
            };
            if (this.section == SECTION_DRESSING_ROOM)
            {
                dispatchEvent(new GameEvent(Events.DRESSING_ROOM_ENTERED_CONTEST));
            };
            if (((UserData.getInstance().first_time_visit()) && ((Tracker.first_time_enter_look == false))))
            {
                Tracker.first_time_enter_look = true;
                Tracker.track_first_time(Tracker.ENTER_CONTEST);
                FaceoffController.getInstance().just_entered_first_look(Look.from_avatar_controller(this.avatar_controller));
                Pop_Up.getInstance().display_popup(Pop_Up.ENTER_LOOK_CONFIRM);
                return;
            };
            MainViewController.getInstance().show_preloader();
            DataManager.getInstance().submit_look(this.avatar_controller);
        }
        private function final_item_check():Boolean{
            if (this.avatar_controller.get_avatar_item_ids() == "")
            {
                Tracer.out("ModelUIController > final check shows no items; canceling submit");
                this.ui.enter_look_btn.visible = false;
                Pop_Up.getInstance().alert("Oops!  Dress up your model first, then enter your look!");
                return (false);
            };
            return (true);
        }
        private function show_user_default():void{
            var _local1:Vector.<Item> = DressingRoom.user_default_clothing;
            var _local2:Item = DressingRoom.user_default_pet_model;
            this.model_vc.data.style_obj = DressingRoom.user_default_styles.get_copy();
            Tracer.out(("ModelUIController > show_user_default: clothing is " + _local1));
            if ((((_local1.length > 0)) && (!((_local1[0].id == 0)))))
            {
                this.avatar_controller.remove_all();
                this.avatar_controller.dress_with_items(_local1, false);
            } else
            {
                this.hide_enter_contest();
            };
            if (_local2)
            {
                this.avatar_controller.add_pet_model(_local2.category, _local2.swf, _local2.id);
            };
            this.avatar_controller.set_styles(this.model_vc.data.style_obj);
            this.set_highlights();
        }
        private function open_photo_ui(_arg1:MouseEvent):void{
            var _local2:SnapshotController = SnapshotController.getInstance();
            _local2.show_with_avatar(this.model_vc.get_avatar_mc(), this.avatar_controller, true);
        }
        function click_fcity(_arg1=null):void{
            CityManager.getInstance().goto_city(1);
        }
        function click_paris(_arg1=null):void{
            CityManager.getInstance().check_paris();
        }
        public function get visible():Boolean{
            return (this.ui.visible);
        }

    }
}//package com.viroxoty.fashionista.user_boutique

