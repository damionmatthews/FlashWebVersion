// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.AvatarController

package com.viroxoty.fashionista{
    import flash.events.EventDispatcher;
    import flash.display.MovieClip;
    import flash.filters.GlowFilter;
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.data.Styles;
    import flash.display.Loader;
    import flash.display.DisplayObject;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.URLRequest;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.net.*;
    import __AS3__.vec.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.filters.*;

    public class AvatarController extends EventDispatcher {

        public static const ITEMS_LOADED:String = "items_loaded";
        public static const FADE_IN_COMPLETE:String = "fade_in_complete";
        public static const ITEM_REMOVED:String = "ITEM_REMOVED";
        public static const CLICK_ITEM:String = "click_item";
        public static const MODE_DRESSING_ROOM:int = 0;
        public static const MODE_RUNWAY:int = 1;
        public static const MODE_SHOP:int = 2;
        public static const MODE_MY_BOUTIQUE:int = 3;

        private static var _instance:AvatarController;
        public static var container_dict:Object = AvatarConstants.container_dict;
        public static var container_list:Array = AvatarConstants.container_list;

        private var pop_obj:Pop_Up;
        private var avatar_mc:MovieClip;
        private var item_list:XML;
        private var glow_effect:GlowFilter;
        private var item_counter:int;
        private var total_items:int;
        private var default_items:Boolean;
        var avatar_items:Vector.<Item>;
        public var pet_model:Item;
        var pet_accessories:Array;
        public var styles:Styles;
        private var container_names:Array;
        private var remove_list:Array;
        public var mode:int;
        var item_loader:Loader;
        var item_container:MovieClip;
        var requester:Object;
        public var zoomed_in:Boolean;
        private var zoom_count:int = 0;
        private var xy_scale:Number;
        private var xpos:Number;
        private var ypos:Number;
        private var zoom_btn:MovieClip;
        private var level_too_low_clips:Array;
        private var current_preview_item_id:int;
        private var unpreview_item_mc:DisplayObject;
        private var preview_item_container:MovieClip;

        public function AvatarController(){
            Tracer.out("new AvatarController");
            this.glow_effect = new GlowFilter();
            this.glow_effect.inner = true;
            this.glow_effect.color = 0xFFFFFF;
            this.glow_effect.blurX = 5;
            this.glow_effect.blurY = 5;
            this.pop_obj = Pop_Up.getInstance();
        }
        public static function getInstance():AvatarController{
            if (_instance == null)
            {
                _instance = new (AvatarController)();
            };
            return (_instance);
        }

        public function init():void{
            this.zoomed_in = false;
            this.item_counter = 0;
            this.avatar_items = new Vector.<Item>();
            this.pet_accessories = [];
            this.pet_model = null;
            this.container_names = new Array();
            this.default_items = false;
            this.level_too_low_clips = [];
        }
        public function preload_avatar_mc():void{
            var ado:AssetDataObject = new AssetDataObject();
            ado.parseURL((Constants.SERVER_SWF + Constants.AVATAR_SWF));
            AssetManager.getInstance().getAssetFor(ado, {"assetLoaded":function (){
                    Tracer.out("Avatar preloaded");
                }});
        }
        public function get_avatar_mc_for(_arg1:Object):void{
            Tracer.out(("get_avatar_mc_for " + _arg1));
            this.requester = _arg1;
            var _local2:AssetDataObject = new AssetDataObject();
            _local2.parseURL((Constants.SERVER_SWF + Constants.AVATAR_SWF));
            AssetManager.getInstance().getAssetFor(_local2, this);
        }
        public function assetLoaded(_arg1:MovieClip, _arg2:String):void{
            Tracer.out("AvatarController > loaded avatar");
            this.avatar_mc = _arg1;
            this.requester.set_avatar_mc(this.avatar_mc);
        }
        public function set_avatar_mc(_arg1:MovieClip):void{
            this.avatar_mc = _arg1;
        }
        public function get_avatar_mc():MovieClip{
            return (this.avatar_mc);
        }
        public function get_avatar_items():Vector.<Item>{
            return (this.avatar_items);
        }
        public function get_avatar_item_ids():String{
            var _local3:int;
            var _local1:int = this.avatar_items.length;
            var _local2:* = "";
            while (_local3 < _local1)
            {
                _local2 = (_local2 + this.avatar_items[_local3].id);
                if (_local3 < (_local1 - 1))
                {
                    _local2 = (_local2 + ",");
                };
                _local3++;
            };
            Tracer.out(("get_avatar_item_ids > " + _local2));
            return (_local2);
        }
        public function get_pet_items():String{
            var _local1:int;
            Tracer.out("get_pet_items");
            if (this.pet_model == null)
            {
                return ("");
            };
            var _local2:String = String(this.pet_model.id);
            var _local3:int = this.pet_accessories.length;
            while (_local1 < _local3)
            {
                _local2 = (_local2 + ",");
                _local2 = (_local2 + this.pet_accessories[_local1].id);
                _local1++;
            };
            Tracer.out(("get_pet_items > " + _local2));
            return (_local2);
        }
        public function get_pet_swfs():Array{
            var _local1:int;
            if (this.pet_model == null)
            {
                return (null);
            };
            var _local2:Array = [];
            _local2.push(this.pet_model.swf);
            var _local3:int = this.pet_accessories.length;
            while (_local1 < _local3)
            {
                _local2.push(this.pet_accessories[_local1].swf);
                _local1++;
            };
            Tracer.out(("get_pet_swfs > " + _local2));
            return (_local2);
        }
        public function get_pet_categories():Array{
            var _local1:int;
            if (this.pet_model == null)
            {
                return (null);
            };
            var _local2:Array = [];
            _local2.push(this.pet_model.category);
            var _local3:int = this.pet_accessories.length;
            while (_local1 < _local3)
            {
                _local2.push(this.pet_accessories[_local1].category);
                _local1++;
            };
            Tracer.out(("get_pet_categories > " + _local2));
            return (_local2);
        }
        public function remove_all():void{
            var _local1:int;
            while (_local1 < container_list.length)
            {
                if (MovieClip(this.avatar_mc.getChildByName(container_list[_local1])).numChildren > 0)
                {
                    this.remove_avatar_item(container_list[_local1], 0);
                };
                _local1++;
            };
            this.level_too_low_clips = [];
            this.pet_model = null;
        }
        public function remove_avatar_item(_arg1:String, _arg2:int):void{
            Tracer.out("AvatarController > remove_avatar_item");
            var _local3:* = MovieClip(this.avatar_mc.getChildByName(_arg1));
            Util.removeChildren(_local3);
            this.update_avatar_dress_up_list(_arg2, _arg1, "remove");
            if (this.mode == AvatarController.MODE_DRESSING_ROOM)
            {
                DressingRoom.remove_user_item(_arg2);
            };
        }
        public function set_styles(_arg1:Object){
            var _local2:MovieClip;
            if (!(_arg1 is Styles))
            {
                this.styles = Styles.from_style_object(_arg1);
            } else
            {
                this.styles = (_arg1 as Styles);
            };
            Tracer.out(("AvatarController > set_styles: " + this.styles.toString()));
            this.set_avatar_haircolor(this.styles.hair_color);
            this.set_hair(this.styles.hair);
            this.set_avatar_eyecolor(this.styles.eye_color);
            this.set_eyes(this.styles.eyes);
            this.set_avatar_lipcolor(this.styles.lip_color);
            this.set_lips(this.styles.lips);
            this.set_avatar_skintone(this.styles.skin);
            this.set_avatar_eyeshade(this.styles.eye_shade);
            this.set_eyebrows(this.styles.eyebrows);
            this.set_avatar_blushcolor(this.styles.blush);
            if (this.mode == AvatarController.MODE_DRESSING_ROOM || this.mode == AvatarController.MODE_MY_BOUTIQUE)
            {
                _local2 = MovieClip(this.avatar_mc.getChildByName("hair_mc"));
                _local2.addEventListener(MouseEvent.CLICK, this.onRemoveHair, false, 0, true);
            };
        }
        public function reset_item_counter():void{
            this.item_counter = 0;
        }
        public function check_item_levels():void{
            var _local1:MovieClip;
            var _local2:int = this.level_too_low_clips.length;
            Tracer.out(("AvatarController > check_item_levels on num items: " + _local2));
            var _local3:int = (_local2 - 1);
            while (_local3 >= 0)
            {
                _local1 = this.level_too_low_clips[_local3];
                Tracer.out(("checking item with level " + _local1.item.level));
                if (_local1.item.level <= UserData.getInstance().level)
                {
                    Tracer.out("found an item the user can now purchase at their new level");
                    Util.create_tooltip("CLICK TO BUY THIS ITEM!", MainViewController.getInstance().tip_container, "left", "bottom", _local1);
                    this.level_too_low_clips.splice(_local3, 1);
                };
                _local3--;
            };
        }
        function item_loaded(_arg1:Event){
            var _local2:String;
            Tracer.out("AvatarController > item_loaded");
            this.item_container = ((_arg1.currentTarget as LoaderInfo).loader.parent as MovieClip);
            if (Main.getInstance().current_section != Constants.SECTION_BOUTIQUE_VISIT)
            {
                _local2 = _arg1.currentTarget.loader.contentLoaderInfo.url;
                Tracer.out(("AvatarController > actualUrl : " + _local2));
                if (_local2.indexOf("dogleash_") > -1)
                {
                    Util.stopClip(this.item_container);
                };
            };
            if (this.item_container.listening != true)
            {
                this.item_container.listening = true;
                this.item_container.addEventListener(MouseEvent.MOUSE_OVER, this.item_over);
                this.item_container.addEventListener(MouseEvent.MOUSE_OUT, this.item_out);
            };
            this.item_container.removeEventListener(MouseEvent.CLICK, this.show_item_ui);
            this.item_container.removeEventListener(MouseEvent.CLICK, this.show_birthday_dress_popup);
            this.item_container.buttonMode = true;
            var _local3:Item = this.item_container.item;
            if (_local3.hasRestriction(Constants.RESTRICTION_UNBUYABLE))
            {
                Util.create_tooltip("SPECIAL ITEM NOT AVAILABLE FOR PURCHASE!", MainViewController.getInstance().tip_container, "left", "bottom", this.item_container);
                this.item_container.addEventListener(MouseEvent.CLICK, this.show_birthday_dress_popup);
            } else
            {
                if ((((_local3.level == -1)) || ((_local3.id == 0))))
                {
                    this.item_container.listening = false;
                    this.item_container.removeEventListener(MouseEvent.MOUSE_OVER, this.item_over);
                    this.item_container.removeEventListener(MouseEvent.MOUSE_OUT, this.item_out);
                    Util.remove_tooltip(this.item_container);
                    this.item_container.buttonMode = false;
                } else
                {
                    if (_local3.level > UserData.getInstance().level)
                    {
                        Util.create_tooltip((("LEVEL " + this.item_container.item.level) + " ITEM"), MainViewController.getInstance().tip_container, "left", "bottom", this.item_container);
                        this.item_container.addEventListener(MouseEvent.CLICK, this.show_item_ui);
                        this.level_too_low_clips.push(this.item_container);
                    } else
                    {
                        Util.create_tooltip("CLICK TO BUY THIS ITEM!", MainViewController.getInstance().tip_container, "left", "bottom", this.item_container);
                        this.item_container.addEventListener(MouseEvent.CLICK, this.show_item_ui);
                    };
                };
            };
            this.item_counter++;
            if (this.item_counter == this.total_items)
            {
                MainViewController.getInstance().hide_preloader();
                dispatchEvent(new Event(AvatarController.ITEMS_LOADED));
                if ((((this.mode == AvatarController.MODE_RUNWAY)) && ((Runway.getInstance().mode == Runway.FACEOFF))))
                {
                    return;
                };
                this.avatar_mc.alpha = 0;
                this.avatar_mc.visible = true;
                this.avatar_mc.addEventListener(Event.ENTER_FRAME, this.fade_in_avatar);
            };
        }
        private function show_item_ui(_arg1:MouseEvent):void{
            Tracer.out("AvatarController > show_item_ui");
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            UserData.getInstance().buy_item(_local2.item);
            dispatchEvent(new Event(CLICK_ITEM));
        }
        private function show_birthday_dress_popup(_arg1:MouseEvent):void{
            Tracer.out("AvatarController > show_birthday_dress_popup");
            this.pop_obj.display_popup(Pop_Up.BIRTHDAY_DRESS);
        }
        public function set_avatar_zoom(_arg1:Boolean, _arg2:MovieClip=null):void{
            this.zoom_btn = _arg2;
            if (this.zoom_btn)
            {
                this.zoom_btn.buttonMode = false;
                this.zoom_btn.mouseEnabled = false;
                this.zoom_btn.mouseChildren = false;
            };
            this.zoom_count = (10 - this.zoom_count);
            if (_arg1)
            {
                this.avatar_mc.startX = this.avatar_mc.x;
                this.avatar_mc.startY = this.avatar_mc.y;
                this.avatar_mc.startScaleX = this.avatar_mc.scaleX;
                this.zoomed_in = true;
                if (this.zoom_btn)
                {
                    this.zoom_btn.gotoAndStop(2);
                };
                this.xy_scale = 0.3;
                this.xpos = -26;
                this.ypos = -5;
            } else
            {
                this.zoomed_in = false;
                if (this.zoom_btn)
                {
                    this.zoom_btn.gotoAndStop(1);
                };
                this.xy_scale = -0.3;
                this.xpos = 26;
                this.ypos = 5;
            };
            this.avatar_mc.removeEventListener(Event.ENTER_FRAME, this.zoom_avatar);
            this.avatar_mc.addEventListener(Event.ENTER_FRAME, this.zoom_avatar);
        }
        public function reset_zoom():void{
            this.avatar_mc.removeEventListener(Event.ENTER_FRAME, this.zoom_avatar);
            if (this.zoom_btn)
            {
                this.zoom_btn.buttonMode = true;
                this.zoom_btn.mouseEnabled = true;
                this.zoom_btn.mouseChildren = true;
                this.zoom_btn.gotoAndStop(1);
            };
            if (this.zoomed_in)
            {
                this.zoomed_in = false;
                this.avatar_mc.scaleX = this.avatar_mc.startScaleX;
                this.avatar_mc.scaleY = 1;
                this.avatar_mc.x = this.avatar_mc.startX;
                this.avatar_mc.y = this.avatar_mc.startY;
            };
        }
        private function zoom_avatar(_arg1:Event):void{
            Tracer.out(("zoom_avatar: avatar_mc.scaleX is " + this.avatar_mc.scaleX));
            if (this.zoom_count > 0)
            {
                this.avatar_mc.scaleX = (this.avatar_mc.scaleX + (this.avatar_mc.startScaleX * this.xy_scale));
                this.avatar_mc.scaleY = (this.avatar_mc.scaleY + this.xy_scale);
                this.avatar_mc.x = (this.avatar_mc.x + (this.avatar_mc.startScaleX * this.xpos));
                this.avatar_mc.y = (this.avatar_mc.y + this.ypos);
                this.zoom_count--;
            } else
            {
                this.avatar_mc.removeEventListener(Event.ENTER_FRAME, this.zoom_avatar);
                dispatchEvent(new Event("zoom_complete"));
                if (this.zoom_btn)
                {
                    this.zoom_btn.buttonMode = true;
                    this.zoom_btn.mouseEnabled = true;
                    this.zoom_btn.mouseChildren = true;
                };
            };
        }
        public function display_selected_look(_arg1:String):void{
            DataManager.getInstance().get_boutique_look_xml(_arg1, this);
        }
        public function set_boutique_look_items_xml(xml:XML):void{
            var node:XML;
            var item:Item;
            var container:String;
            var i:int;
            var load_item:Function = function (mc:MovieClip):void{
                var boutique_item_loader:Loader;
                var boutique_item_loaded:Function;
                boutique_item_loaded = function (_arg1:Event){
                    while (mc.numChildren > 0)
                    {
                        Tracer.out(("Avatar > boutique_item_loaded: removing extra item in " + mc.name));
                        mc.removeChildAt(0);
                    };
                    mc.addChild(boutique_item_loader);
                    mc.buttonMode = true;
                    mc.addEventListener(MouseEvent.MOUSE_OVER, item_over);
                    mc.addEventListener(MouseEvent.MOUSE_OUT, item_out);
                    mc.addEventListener(MouseEvent.CLICK, show_item_ui);
                    Util.create_tooltip("CLICK TO BUY THIS ITEM!", MainViewController.getInstance().tip_container, "left", "bottom", mc);
                    item_counter++;
                    Tracer.out(((("Avatar > boutique_item_loaded: item_counter is " + item_counter) + " and total_items is ") + total_items));
                    if (item_counter == total_items)
                    {
                        remove_remainder();
                    };
                };
                boutique_item_loader = new Loader();
                var url_request:URLRequest = new URLRequest(mc.item.swf);
                boutique_item_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, boutique_item_loaded);
                Tracer.out(("AvatarController > load_item " + mc.item.swf));
                boutique_item_loader.load(url_request);
            };
            var remove_remainder:Function = function (){
                var remove_children:Function;
                remove_children = function (_arg1:String, ... _args){
                    Util.removeChildren((avatar_mc[_arg1] as DisplayObjectContainer));
                };
                Tracer.out("Avatar > remove_remainder");
                remove_list.forEach(remove_children);
            };
            Tracer.out(("AvatarController > set_boutique_look_items_xml : " + xml.toString()));
            this.item_list = new XML(xml);
            this.item_counter = 0;
            this.total_items = this.item_list.children().length();
            this.remove_list = container_list.concat();
            while (i < this.total_items)
            {
                node = this.item_list.ITEM[i];
                item = new Item();
                item.parseServerXML(node);
                container = container_dict[item.category];
                Util.remove(this.remove_list, container);
                this.item_container = (this.avatar_mc[container] as MovieClip);
                this.item_container.item = item;
                (load_item(this.item_container));
                i = (i + 1);
            };
        }
        private function item_over(_arg1:MouseEvent):void{
            _arg1.currentTarget.filters = [this.glow_effect];
        }
        private function item_out(_arg1:MouseEvent):void{
            _arg1.currentTarget.filters = [];
        }
        public function display_with_items(_arg1:Vector.<Item>):void{
            var _local3:int;
            this.reset_item_counter();
            var _local2:int = _arg1.length;
            while (_local3 < _local2)
            {
                this.display_contestant_item(_arg1[_local3], _local2);
                _local3++;
            };
        }
        public function display_contestant_item(_arg1:Item, _arg2:int):void{
            this.total_items = _arg2;
            _arg1.swf = _arg1.swf.split("dog_").join("dogleash_");
            Tracer.out("display_contestant_item ");
            this.item_container = (this.avatar_mc[container_dict[_arg1.category]] as MovieClip);
            this.item_container.buttonMode = true;
            this.item_container.item = _arg1;
            this.item_loader = new Loader();
            this.item_container.addChild(this.item_loader);
            var _local3:* = new URLRequest(_arg1.swf);
            this.item_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.item_loaded);
            this.item_loader.load(_local3);
        }
        function fade_in_avatar(_arg1:Event):void{
            _arg1.currentTarget.alpha = (_arg1.currentTarget.alpha + 0.6);
            if (_arg1.currentTarget.alpha >= 1)
            {
                _arg1.currentTarget.alpha = 1;
                _arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, this.fade_in_avatar);
                dispatchEvent(new Event(FADE_IN_COMPLETE));
            };
        }
        public function dressup_default():void{
            this.default_items = true;
            this.dress_with_items(DressingRoom.user_default_clothing);
        }
        public function dress_with_items(_arg1:Vector.<Item>, _arg2:Boolean=true):void{
            var _local3:Item;
            var _local5:int;
            this.reset_item_counter();
            var _local4:int = _arg1.length;
            this.total_items = _local4;
            while (_local5 < _local4)
            {
                _local3 = _arg1[_local5];
                if (_local3.category == "pet_models")
                {
                    this.add_pet_model(_local3.category, _local3.swf, _local3.id);
                } else
                {
                    this.add_item(_local3.category, _local3.swf, _local3.id, this.total_items, _arg2);
                };
                _local5++;
            };
        }
        public function add_item(category:String, swf:String, id:int, max:int=0, allow_remove:Boolean=true):void{
            var item_container:MovieClip;
            var item_loaded:Function;
            item_loaded = function (_arg1:Event){
                Tracer.out("AvatarController > add_item : item_loaded");
                while (item_container.numChildren > 0)
                {
                    item_container.removeChildAt(0);
                };
                Util.remove_tooltip(item_container);
                item_container.removeEventListener(MouseEvent.CLICK, remove_item);
                item_container.addChild((_arg1.currentTarget as LoaderInfo).loader);
                Tracer.out("AvatarController > add_item : item_loaded : loader added to item container");
                item_container.id = id;
                if (allow_remove)
                {
                    item_container.buttonMode = true;
                    item_container.addEventListener(MouseEvent.CLICK, remove_item);
                    Util.create_tooltip("CLICK TO REMOVE THIS ITEM", MainViewController.getInstance().tip_container, "left", "bottom", item_container);
                };
                item_counter++;
                if (item_counter == total_items)
                {
                    avatar_mc.alpha = 0;
                    avatar_mc.visible = true;
                    avatar_mc.addEventListener(Event.ENTER_FRAME, fade_in_avatar);
                    dispatchEvent(new Event(ITEMS_LOADED));
                };
            };
            Tracer.out(("add_item: default_items is " + this.default_items));
            if ((((max == 0)) && (this.default_items)))
            {
                this.default_items = false;
                this.remove_all_defaults();
            };
            if (id == 0)
            {
                this.default_items = true;
                this.avatar_items = new Vector.<Item>();
                this.container_names = new Array();
            };
            swf = swf.split("dog_").join("dogleash_");
            item_container = (this.avatar_mc[container_dict[category]] as MovieClip);
            Tracer.out(("AvatarController > add_item : swf is " + swf));
            if (this.preview_item_container == item_container)
            {
                this.preview_item_container = null;
                this.unpreview_item_mc = null;
            };
            this.update_avatar_dress_up_list(id, item_container.name, "add", swf, category);
            this.item_loader = new Loader();
            var url_request:URLRequest = new URLRequest(swf);
            this.item_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, item_loaded);
            this.item_loader.load(url_request);
        }
        function remove_item(_arg1:MouseEvent):void{
            _arg1.currentTarget.removeEventListener(MouseEvent.CLICK, this.remove_item);
            _arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, this.item_over);
            _arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, this.item_out);
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            this.remove_avatar_item(_local2.name, _local2.id);
            dispatchEvent(new Event(ITEM_REMOVED));
        }
        function remove_all_defaults():void{
            var _local1:int;
            Tracer.out("remove_all_defaults");
            while (_local1 < this.avatar_items.length)
            {
                Tracer.out(("avatar_items[i].id is " + this.avatar_items[_local1].id));
                if ((((this.avatar_items[_local1].id == 0)) && ((MovieClip(this.avatar_mc.getChildByName(this.container_names[_local1])).numChildren > 0))))
                {
                    this.remove_avatar_item(this.container_names[_local1], 0);
                };
                _local1++;
            };
        }
        public function add_pet_model(category:String, swf:String, id:int):void{
            var item_container:MovieClip;
            var item_loaded:Function;
            var remove_pet:Function;
            item_loaded = function (_arg1:Event){
                item_container.addChild((_arg1.currentTarget as LoaderInfo).loader);
                if (item_container.numChildren > 1)
                {
                    item_container.removeChildAt(0);
                };
                item_container.buttonMode = true;
                item_container.addEventListener(MouseEvent.CLICK, remove_pet);
                Util.create_tooltip("CLICK TO REMOVE THIS ITEM", MainViewController.getInstance().tip_container, "left", "bottom", item_container);
                item_counter++;
                if (item_counter == total_items)
                {
                    avatar_mc.alpha = 0;
                    avatar_mc.visible = true;
                    avatar_mc.addEventListener(Event.ENTER_FRAME, fade_in_avatar);
                    dispatchEvent(new Event(ITEMS_LOADED));
                };
            };
            remove_pet = function (_arg1:MouseEvent):void{
                _arg1.currentTarget.removeEventListener(MouseEvent.CLICK, remove_pet);
                _arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, item_over);
                _arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, item_out);
                pet_model = null;
                while (item_container.numChildren > 0)
                {
                    item_container.removeChildAt(0);
                };
                if (mode == AvatarController.MODE_DRESSING_ROOM)
                {
                    DressingRoom.remove_user_pet_model();
                };
                dispatchEvent(new Event(ITEM_REMOVED));
            };
            Tracer.out("add_pet_model");
            swf = swf.split("dog_").join("dogleash_");
            this.pet_model = new Item();
            this.pet_model.id = id;
            this.pet_model.swf = swf;
            this.pet_model.category = category;
            item_container = (this.avatar_mc[container_dict[category]] as MovieClip);
            if (this.preview_item_container == item_container)
            {
                this.preview_item_container = null;
                this.unpreview_item_mc = null;
            };
            this.item_loader = new Loader();
            var url_request:URLRequest = new URLRequest(swf);
            this.item_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, item_loaded);
            this.item_loader.load(url_request);
        }
        public function remove_model_interactivity():void{
            var _local1:MovieClip;
            var _local3:int;
            var _local2:int = this.avatar_items.length;
            while (_local3 < _local2)
            {
                _local1 = (this.avatar_mc[container_dict[this.avatar_items[_local3].category]] as MovieClip);
                _local1.buttonMode = false;
                _local1.removeEventListener(MouseEvent.CLICK, this.remove_item);
                Util.remove_tooltip(_local1);
                _local3++;
            };
        }
        public function restore_model_interactivity():void{
            var _local1:MovieClip;
            var _local3:int;
            var _local2:int = this.avatar_items.length;
            while (_local3 < _local2)
            {
                _local1 = (this.avatar_mc[container_dict[this.avatar_items[_local3].category]] as MovieClip);
                _local1.buttonMode = true;
                _local1.addEventListener(MouseEvent.CLICK, this.remove_item);
                Util.create_tooltip("CLICK TO REMOVE THIS ITEM", MainViewController.getInstance().tip_container, "left", "bottom", _local1);
                _local3++;
            };
        }
        private function update_avatar_dress_up_list(_arg1:int, _arg2:String, _arg3:String, _arg4:String=null, _arg5:String=null):void{
            var _local6:int;
            var _local7:*;
            Tracer.out(((("update_avatar_dress_up_list: container_name is " + _arg2) + ", process is ") + _arg3));
            var _local8:Item = new Item();
            _local8.id = _arg1;
            _local8.category = _arg5;
            _local8.swf = _arg4;
            if (_arg3 == "add")
            {
                _local7 = true;
                _local6 = 0;
                while (_local6 < this.avatar_items.length)
                {
                    if (this.container_names[_local6] == _arg2)
                    {
                        _local7 = false;
                        this.avatar_items[_local6] = _local8;
                        break;
                    };
                    _local6++;
                };
                if (_local7)
                {
                    Tracer.out((("adding item : " + _local8) + " to avatar_items"));
                    this.avatar_items.push(_local8);
                    this.container_names.push(_arg2);
                };
            } else
            {
                if (_arg3 == "remove")
                {
                    _local6 = 0;
                    while (_local6 < this.container_names.length)
                    {
                        if (this.container_names[_local6] == _arg2)
                        {
                            this.avatar_items.splice(_local6, 1);
                            this.container_names.splice(_local6, 1);
                            break;
                        };
                        _local6++;
                    };
                };
            };
            Tracer.out(("AvatarController > update_avatar_dress_up_list: avatar_items = " + this.avatar_items));
        }
        public function preview_item(item:Item):void{
            var item_container:MovieClip;
            var item_loaded:Function;
            item_loaded = function (_arg1:Event){
                if (current_preview_item_id != item.id)
                {
                    return;
                };
                while (item_container.numChildren > 0)
                {
                    item_container.removeChildAt(0);
                };
                item_container.addChild((_arg1.currentTarget as LoaderInfo).loader);
            };
            this.current_preview_item_id = item.id;
            item_container = (this.avatar_mc[container_dict[item.category]] as MovieClip);
            this.preview_item_container = item_container;
            Tracer.out(((("preview_item > container name  is " + item_container.name) + ", numChildren is ") + item_container.numChildren));
            if (item_container.numChildren > 0)
            {
                this.unpreview_item_mc = item_container.getChildAt(0);
                Tracer.out(("preview_item > unpreview_item_mc  is " + this.unpreview_item_mc));
            };
            var swf:String = item.swf.split("dog_").join("dogleash_");
            this.item_loader = new Loader();
            var url_request:URLRequest = new URLRequest(swf);
            this.item_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, item_loaded);
            this.item_loader.load(url_request);
        }
        public function unpreview_item(_arg1:Item):void{
            this.current_preview_item_id = -1;
            if (this.preview_item_container)
            {
                while (this.preview_item_container.numChildren > 0)
                {
                    this.preview_item_container.removeChildAt(0);
                };
            };
            Tracer.out(("unpreview_item > unpreview_item_mc is " + this.unpreview_item_mc));
            if (this.unpreview_item_mc)
            {
                this.preview_item_container.addChild(this.unpreview_item_mc);
                this.unpreview_item_mc = null;
            };
            this.preview_item_container = null;
        }
        public function preview_hair(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("hair_mc");
            _local2.gotoAndStop(_arg1);
            this.set_avatar_haircolor(this.styles.hair_color);
        }
        public function unpreview_hair(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("hair_mc");
            _local2.gotoAndStop(this.styles.hair);
            this.set_avatar_haircolor(this.styles.hair_color);
        }
        public function set_hair(_arg1:int):void{
            this.styles.hair = _arg1;
            var _local2:* = this.avatar_mc.getChildByName("hair_mc");
            _local2.gotoAndStop(_arg1);
            this.set_avatar_haircolor(this.styles.hair_color);
        }
        public function onRemoveHair(_arg1:MouseEvent):void{
            this.set_hair(59);
        }
        public function preview_eyes(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyes_mc");
            _local2.gotoAndStop(_arg1);
            this.set_avatar_eyecolor(this.styles.eye_color);
        }
        public function unpreview_eyes(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyes_mc");
            _local2.gotoAndStop(this.styles.eyes);
            this.set_avatar_eyecolor(this.styles.eye_color);
        }
        public function set_eyes(_arg1:int):void{
            this.styles.eyes = _arg1;
            var _local2:* = this.avatar_mc.getChildByName("eyes_mc");
            _local2.gotoAndStop(_arg1);
            this.set_avatar_eyecolor(this.styles.eye_color);
        }
        public function preview_lips(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("lips_mc");
            _local2.gotoAndStop(_arg1);
            this.set_avatar_lipcolor(this.styles.lip_color);
        }
        public function unpreview_lips(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("lips_mc");
            _local2.gotoAndStop(this.styles.lips);
            this.set_avatar_lipcolor(this.styles.lip_color);
        }
        public function set_lips(_arg1:int):void{
            this.styles.lips = _arg1;
            var _local2:* = this.avatar_mc.getChildByName("lips_mc");
            _local2.gotoAndStop(_arg1);
            this.set_avatar_lipcolor(this.styles.lip_color);
        }
        public function preview_eyebrows(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyebrow_mc");
            _local2.gotoAndStop(_arg1);
        }
        public function unpreview_eyebrows(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyebrow_mc");
            _local2.gotoAndStop(this.styles.eyebrows);
        }
        public function set_eyebrows(_arg1:int):void{
            this.styles.eyebrows = _arg1;
            var _local2:* = this.avatar_mc.getChildByName("eyebrow_mc");
            _local2.gotoAndStop(_arg1);
        }
        public function show_avatar_skintone(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("skin_mc");
            _local2.gotoAndStop(_arg1);
        }
        public function remove_avatar_skintone(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("skin_mc");
            _local2.gotoAndStop(this.styles.skin);
        }
        public function set_avatar_skintone(_arg1:int):void{
            this.styles.skin = _arg1;
            var _local2:* = this.avatar_mc.getChildByName("skin_mc");
            _local2.gotoAndStop(_arg1);
        }
        public function show_avatar_haircolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("hair_mc");
            MovieClip(_local2.getChildAt(0)).gotoAndStop(_arg1);
        }
        public function remove_avatar_haircolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("hair_mc");
            MovieClip(_local2.getChildAt(0)).gotoAndStop(this.styles.hair_color);
        }
        public function set_avatar_haircolor(num:int):void{
            var hair_style:* = undefined;
            var hair_color:Function;
            hair_style = undefined;
            this.styles.hair_color = num;
            Tracer.out(("AvatarController > set_avatar_haircolor: " + num));
            hair_style = this.avatar_mc.getChildByName("hair_mc");
            if (hair_style.getChildAt(0))
            {
                MovieClip(hair_style.getChildAt(0)).gotoAndStop(num);
            } else
            {
                hair_color = function (_arg1:Event):void{
                    if (hair_style.getChildAt(0) != null)
                    {
                        hair_style.removeEventListener(Event.ENTER_FRAME, hair_color);
                        MovieClip(hair_style.getChildAt(0)).gotoAndStop(styles.hair_color);
                    };
                };
                hair_style.addEventListener(Event.ENTER_FRAME, hair_color);
                Tracer.out("AvatarController > adding enter frame");
            };
        }
        public function show_avatar_eyecolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyes_mc");
            MovieClip(_local2.getChildAt(0)).gotoAndStop(_arg1);
        }
        public function remove_avatar_eyecolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyes_mc");
            MovieClip(_local2.getChildAt(0)).gotoAndStop(this.styles.eye_color);
        }
        public function set_avatar_eyecolor(num:int):void{
            var eye_style:* = undefined;
            var eye_color:Function;
            eye_style = undefined;
            this.styles.eye_color = num;
            eye_style = this.avatar_mc.getChildByName("eyes_mc");
            if (eye_style.getChildAt(0))
            {
                MovieClip(eye_style.getChildAt(0)).gotoAndStop(this.styles.eye_color);
            } else
            {
                eye_color = function (_arg1:Event):void{
                    if (eye_style.getChildAt(0) != null)
                    {
                        eye_style.removeEventListener(Event.ENTER_FRAME, eye_color);
                        MovieClip(eye_style.getChildAt(0)).gotoAndStop(styles.eye_color);
                    };
                };
                eye_style.addEventListener(Event.ENTER_FRAME, eye_color);
            };
        }
        public function show_avatar_lipcolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("lips_mc");
            MovieClip(_local2.getChildAt(0)).gotoAndStop(_arg1);
        }
        public function remove_avatar_lipcolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("lips_mc");
            MovieClip(_local2.getChildAt(0)).gotoAndStop(this.styles.lip_color);
        }
        public function set_avatar_lipcolor(num:int):void{
            var lip_style:MovieClip;
            var lip_color:Function;
            this.styles.lip_color = num;
            lip_style = (this.avatar_mc.getChildByName("lips_mc") as MovieClip);
            if (lip_style.getChildAt(0))
            {
                MovieClip(lip_style.getChildAt(0)).gotoAndStop(this.styles.lip_color);
            } else
            {
                lip_color = function (_arg1:Event):void{
                    if (lip_style.getChildAt(0) != null)
                    {
                        lip_style.removeEventListener(Event.ENTER_FRAME, lip_color);
                        MovieClip(lip_style.getChildAt(0)).gotoAndStop(styles.lip_color);
                    };
                };
                lip_style.addEventListener(Event.ENTER_FRAME, lip_color);
            };
        }
        public function show_avatar_eyeshade(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyeshades_mc");
            _local2.gotoAndStop(_arg1);
        }
        public function remove_avatar_eyeshade(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyeshades_mc");
            _local2.gotoAndStop(this.styles.eye_shade);
        }
        public function set_avatar_eyeshade(_arg1:int):void{
            this.styles.eye_shade = _arg1;
            var _local2:* = this.avatar_mc.getChildByName("eyeshades_mc");
            _local2.gotoAndStop(_arg1);
        }
        public function show_avatar_blushcolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("blush_mc");
            _local2.gotoAndStop(_arg1);
        }
        public function remove_avatar_blushcolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("blush_mc");
            _local2.gotoAndStop(this.styles.blush);
        }
        public function set_avatar_blushcolor(_arg1:int):void{
            this.styles.blush = _arg1;
            var _local2:* = this.avatar_mc.getChildByName("blush_mc");
            _local2.gotoAndStop(_arg1);
        }

    }
}//package com.viroxoty.fashionista

