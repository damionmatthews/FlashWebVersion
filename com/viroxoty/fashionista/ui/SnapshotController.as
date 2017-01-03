// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.SnapshotController

package com.viroxoty.fashionista.ui{
    import flash.events.EventDispatcher;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import com.viroxoty.fashionista.AvatarController;
    import flash.utils.ByteArray;
    import com.viroxoty.fashionista.data.Item;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.display.BitmapData;
    import com.viroxoty.fashionista.*;
    import com.viroxoty.fashionista.data.*;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.asset.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class SnapshotController extends EventDispatcher {

        static const ZOOM_SCALE_MIN:Number = 1;
        static const ZOOM_SCALE_MAX:Number = 4;
        static const ZOOM_X_MIN:Number = 0;
        static const ZOOM_X_MAX:Number = -260;
        static const ZOOM_Y_MIN:Number = -50;
        static const ZOOM_Y_MAX:Number = -50;
        static const MORE_MIDDLE_X:int = 245;
        static const MORE_LEFT_X:int = 104;
        public static const CLOSED:String = "closed";
        public static const ENTER_LOOK:String = "enter_look";
        private static const LEFT_SCROLL:int = 320;
        private static const RIGHT_SCROLL:int = 320;
        private static const TOTAL_LEFT_BGS:int = 12;
        private static const TOTAL_BGS:int = 24;

        private static var _instance:SnapshotController;

        const SNAPSHOT_ID:int = 101;
        const DEFAULT_BG:int = 4;

        private var view:MovieClip;
        private var avatar_sprite:Sprite;
        private var avatar_mc:MovieClip;
        private var avatar_controller:AvatarController;
        public var png:ByteArray;
        public var image_url:String;
        public var custom_post:Boolean = false;
        public var fb_post_done:Boolean;
        public var photo_id:String;
        public var is_user_look:Boolean;
        public var is_open:Boolean = false;
        public var pending_best_dressed:Boolean = false;
        private var zoomed_in:Boolean;
        private var left_bgs_start_y:Number;
        private var right_bgs_start_y:Number;
        var bg_items:Array;
        var total_data:int;
        var mod_store_item:Item;

        public function SnapshotController(){
            _instance = this;
            DataManager.getInstance().get_items_xml(String(this.SNAPSHOT_ID), this, this.set_items_xml);
        }
        public static function getInstance():SnapshotController{
            if (_instance == null)
            {
                _instance = new (SnapshotController)();
            };
            return (_instance);
        }

        public function set_items_xml(_arg1:XML):void{
            var _local2:XML;
            var _local3:Item;
            var _local5:int;
            Tracer.out(("SnapshotController > set_items_xml: xml is " + _arg1));
            var _local4:XML = new XML(_arg1);
            this.total_data = _local4.children().length();
            this.bg_items = [];
            while (_local5 < this.total_data)
            {
                _local2 = _local4.ITEM[_local5];
                _local3 = new Item();
                _local3.parseServerXML(_local2, true);
                this.bg_items.push(_local3);
                Tracer.out(("bg_items: add " + _local3.toString()));
                _local5++;
            };
            if (this.view)
            {
                this.setup_purchasable_bgs();
            };
        }
        function setup_purchasable_bgs():void{
            var _local1:Item;
            var _local2:Array;
            var _local3:String;
            var _local4:int;
            var _local5:MovieClip;
            var _local6:int;
            Tracer.out("setup_purchasable_bgs");
            while (_local6 < this.total_data)
            {
                _local1 = this.bg_items[_local6];
                _local2 = _local1.swf.split("/");
                _local3 = _local2[(_local2.length - 1)];
                _local4 = int(_local3.slice(2));
                if (_local4 <= TOTAL_LEFT_BGS)
                {
                    _local5 = this.view.left_bgs[_local3];
                } else
                {
                    _local5 = this.view.right_bgs[_local3];
                };
                _local5.item = _local1;
                _local5.credit_icon.visible = !(UserData.getInstance().owns(_local1));
                _local6++;
            };
        }
        public function purchased_bg(_arg1:Item):void{
            var _local2:MovieClip;
            Tracer.out(("SnapshotController > purchased_bg : " + _arg1));
            var _local3:Array = _arg1.swf.split("/");
            var _local4:String = _local3[(_local3.length - 1)];
            _local4 = _local4.slice(0, -4);
            var _local5:Array = _local4.split("_");
            var _local6:int = int(_local5[2]);
            var _local7:String = ("bg" + String(_local6));
            if (_local6 <= TOTAL_LEFT_BGS)
            {
                _local2 = this.view.left_bgs[_local7];
            } else
            {
                _local2 = this.view.right_bgs[_local7];
            };
            _local2.credit_icon.visible = !(UserData.getInstance().owns(_arg1));
        }
        public function show_with_avatar(_arg1:MovieClip, _arg2:AvatarController, _arg3:Boolean=false):void{
            this.avatar_mc = _arg1;
            this.avatar_controller = _arg2;
            this.is_user_look = _arg3;
            if (this.view == null)
            {
                this.load_view();
                return;
            };
            this.reset_slider();
            MainViewController.getInstance().add_snapshot_ui(this.view);
            this.is_open = true;
            this.view.confirm_mc.visible = false;
            this.zoomed_in = this.avatar_controller.zoomed_in;
            this.avatar_controller.zoomed_in = false;
            this.avatar_mc.index = this.avatar_mc.parent.getChildIndex(this.avatar_mc);
            this.avatar_mc.drx = this.avatar_mc.x;
            this.avatar_mc.dry = this.avatar_mc.y;
            this.avatar_mc.drscaleX = this.avatar_mc.scaleX;
            this.avatar_mc.drscaleY = this.avatar_mc.scaleY;
            this.avatar_mc.drparent = this.avatar_mc.parent;
            this.avatar_mc.drmask = this.avatar_mc.mask;
            this.avatar_mc.mask = null;
            Tracer.out(((("avatar_mc.x = " + this.avatar_mc.x) + ", y = ") + this.avatar_mc.y));
            this.avatar_mc.x = 0;
            this.avatar_mc.y = 0;
            this.avatar_mc.scaleX = 1;
            this.avatar_mc.scaleY = 1;
            this.avatar_sprite = new Sprite();
            this.view.photo_container.avatar_container.addChild(this.avatar_sprite);
            this.avatar_sprite.addChild(this.avatar_mc);
        }
        function load_view():void{
            MainViewController.getInstance().show_preloader();
            var _local1:AssetDataObject = new AssetDataObject();
            _local1.parseURL(((Constants.SERVER_SWF + Constants.SNAPSHOT_FILENAME) + ".swf"));
            AssetManager.getInstance().getAssetFor(_local1, this);
        }
        public function assetLoaded(_arg1:DisplayObject, _arg2:String):void{
            MainViewController.getInstance().hide_preloader();
            this.view = (_arg1 as MovieClip);
            this.init();
        }
        function init():void{
            var _local1:MovieClip;
            this.view.close_btn.buttonMode = true;
            this.view.close_btn.addEventListener(MouseEvent.CLICK, this.close, false, 0, true);
            this.view.full_figure_btn.buttonMode = true;
            this.view.full_figure_btn.addEventListener(MouseEvent.CLICK, this.zoom_out, false, 0, true);
            this.view.close_up_btn.buttonMode = true;
            this.view.close_up_btn.addEventListener(MouseEvent.CLICK, this.zoom_in, false, 0, true);
            this.view.zoom_slider.handle.buttonMode = true;
            this.view.zoom_slider.handle.addEventListener(MouseEvent.MOUSE_DOWN, this.start_drag_zoom, false, 0, true);
            this.view.save_btn.buttonMode = true;
            this.view.save_btn.addEventListener(MouseEvent.CLICK, this.show_caption_popup, false, 0, true);
            this.view.photo_container.avatar_container.scaleX = 0.72;
            this.view.photo_container.avatar_container.scaleY = 0.72;
            this.view.photo_container.bg.gotoAndStop(this.DEFAULT_BG);
            var _local2:int = 1;
            while (_local2 <= TOTAL_BGS)
            {
                if (_local2 <= TOTAL_LEFT_BGS)
                {
                    _local1 = this.view.left_bgs[("bg" + _local2)];
                } else
                {
                    _local1 = this.view.right_bgs[("bg" + _local2)];
                };
                _local1.buttonMode = true;
                _local1.index = _local2;
                _local1.addEventListener(MouseEvent.CLICK, this.set_bg, false, 0, true);
                _local2++;
            };
            if (this.bg_items)
            {
                this.setup_purchasable_bgs();
            };
            this.view.left_bgs.target_y = this.view.left_bgs.y;
            this.view.right_bgs.target_y = this.view.right_bgs.y;
            this.left_bgs_start_y = this.view.left_bgs.y;
            this.view.up_btn.buttonMode = true;
            this.view.up_btn.addEventListener(MouseEvent.CLICK, this.left_bgs_up, false, 0, true);
            this.view.down_btn.buttonMode = true;
            this.view.down_btn.addEventListener(MouseEvent.CLICK, this.left_bgs_down, false, 0, true);
            this.view.up_btn.visible = false;
            this.right_bgs_start_y = this.view.right_bgs.y;
            this.view.up_btn_right.buttonMode = true;
            this.view.up_btn_right.addEventListener(MouseEvent.CLICK, this.right_bgs_up, false, 0, true);
            this.view.down_btn_right.buttonMode = true;
            this.view.down_btn_right.addEventListener(MouseEvent.CLICK, this.right_bgs_down, false, 0, true);
            this.view.up_btn_right.visible = false;
            this.view.photo_container.logo1.visible = false;
            this.view.photo_container.flash.alpha = 0;
            this.view.confirm_mc.more_btn.buttonMode = true;
            this.view.confirm_mc.more_btn.addEventListener(MouseEvent.CLICK, this.close_confirm, false, 0, true);
            this.view.confirm_mc.enter_btn.buttonMode = true;
            this.view.confirm_mc.enter_btn.addEventListener(MouseEvent.CLICK, this.enter_contest, false, 0, true);
            this.show_with_avatar(this.avatar_mc, this.avatar_controller, this.is_user_look);
        }
        function reset_slider():void{
            this.view.zoom_slider.handle.x = 0;
        }
        function reset():void{
            this.view.photo_container.bg.gotoAndStop(1);
        }
        function close(_arg1:MouseEvent):void{
            this.is_open = false;
            this.avatar_mc.x = this.avatar_mc.drx;
            this.avatar_mc.y = this.avatar_mc.dry;
            this.avatar_mc.scaleX = this.avatar_mc.drscaleX;
            this.avatar_mc.scaleY = this.avatar_mc.drscaleY;
            this.avatar_mc.mask = this.avatar_mc.drmask;
            Tracer.out(("avatar_mc.index is " + this.avatar_mc.index));
            this.avatar_mc.drparent.addChildAt(this.avatar_mc, this.avatar_mc.index);
            Tracer.out(((("avatar_mc.x = " + this.avatar_mc.x) + ", y = ") + this.avatar_mc.y));
            this.avatar_controller.zoomed_in = this.zoomed_in;
            this.view.parent.removeChild(this.view);
            dispatchEvent(new Event(CLOSED));
            if (this.pending_best_dressed)
            {
                this.pending_best_dressed = false;
                UserData.getInstance().show_best_dressed();
            };
        }
        function zoom_out(_arg1:MouseEvent):void{
            this.set_zoom(0);
            this.view.zoom_slider.handle.x = 0;
        }
        function zoom_in(_arg1:MouseEvent):void{
            this.set_zoom(1);
            this.view.zoom_slider.handle.x = this.view.zoom_slider.line.width;
        }
        function set_zoom(_arg1:Number):void{
            var _local2:Number = (ZOOM_SCALE_MIN + (_arg1 * (ZOOM_SCALE_MAX - ZOOM_SCALE_MIN)));
            var _local3:Number = (ZOOM_X_MIN + ((_arg1 * ZOOM_X_MAX) - ZOOM_X_MIN));
            var _local4:Number = (ZOOM_Y_MIN + ((_arg1 * ZOOM_Y_MAX) - ZOOM_Y_MIN));
            this.avatar_sprite.scaleX = _local2;
            this.avatar_sprite.scaleY = _local2;
            this.avatar_sprite.x = _local3;
            this.avatar_sprite.y = _local4;
        }
        function start_drag_zoom(_arg1:MouseEvent){
            Tracer.out("start_drag_zoom");
            var _local2:MovieClip = this.view.zoom_slider.handle;
            _local2.x_offset = _local2.mouseX;
            _local2.y_offset = _local2.mouseY;
            this.view.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.update_zoom, false, 0, true);
            this.view.stage.addEventListener(MouseEvent.MOUSE_UP, this.drop, false, 0, true);
        }
        function update_zoom(_arg1:MouseEvent):void{
            Tracer.out("update_zoom");
            var _local2:MovieClip = this.view.zoom_slider.handle;
            var _local3:Number = (this.view.zoom_slider.mouseX - _local2.x_offset);
            _local3 = Math.min(this.view.zoom_slider.line.width, _local3);
            _local3 = Math.max(_local3, 0);
            _local2.x = _local3;
            this.set_zoom((_local3 / this.view.zoom_slider.line.width));
        }
        public function drop(_arg1=null):void{
            this.view.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.update_zoom);
            this.view.stage.removeEventListener(MouseEvent.MOUSE_UP, this.drop);
        }
        function set_bg(_arg1:MouseEvent):void{
            var _local2:Item;
            var _local3:Array;
            var _local4:String;
            var _local5:String;
            var _local6:int = _arg1.currentTarget.index;
            if (((_arg1.currentTarget.credit_icon) && (_arg1.currentTarget.credit_icon.visible)))
            {
                _local2 = (_arg1.currentTarget.item as Item);
                if (_local2.fb_credits)
                {
                    _local3 = _local2.png.split("/");
                    _local4 = _local3[(_local3.length - 1)];
                    _local5 = _local4.slice(2);
                    _local3[(_local3.length - 1)] = (("snapshot_bg_" + _local5) + ".png");
                    _local2.swf = _local3.join("/");
                };
                UserData.getInstance().buy_item(_local2);
                return;
            };
            var _local7:MovieClip = this.view.photo_container;
            _local7.bg.gotoAndStop(_local6);
            if (_local6 == 3)
            {
                _local7.logo1.visible = false;
                _local7.logo2.visible = false;
            } else
            {
                if (_local6 == 4)
                {
                    _local7.logo1.visible = false;
                    _local7.logo2.visible = true;
                } else
                {
                    _local7.logo1.visible = true;
                    _local7.logo2.visible = false;
                };
            };
        }
        function left_bgs_up(e:MouseEvent):void{
            Tweener.removeTweens(this.view.left_bgs);
            this.view.left_bgs.target_y = (this.view.left_bgs.target_y + LEFT_SCROLL);
            Tweener.addTween(this.view.left_bgs, {
                "y":this.view.left_bgs.target_y,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            if (this.view.left_bgs.target_y == this.left_bgs_start_y)
            {
                this.view.up_btn.visible = false;
            };
            this.view.down_btn.visible = true;
        }
        function left_bgs_down(e:MouseEvent):void{
            Tweener.removeTweens(this.view.left_bgs);
            this.view.left_bgs.target_y = (this.view.left_bgs.target_y - LEFT_SCROLL);
            Tweener.addTween(this.view.left_bgs, {
                "y":this.view.left_bgs.target_y,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            this.view.up_btn.visible = true;
            if (this.view.left_bgs.target_y == (this.left_bgs_start_y - (LEFT_SCROLL * 2)))
            {
                this.view.down_btn.visible = false;
            };
        }
        function right_bgs_up(e:MouseEvent):void{
            Tweener.removeTweens(this.view.right_bgs);
            this.view.right_bgs.target_y = (this.view.right_bgs.target_y + RIGHT_SCROLL);
            Tweener.addTween(this.view.right_bgs, {
                "y":this.view.right_bgs.target_y,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            if (this.view.right_bgs.target_y == this.right_bgs_start_y)
            {
                this.view.up_btn_right.visible = false;
            };
            this.view.down_btn_right.visible = true;
        }
        function right_bgs_down(e:MouseEvent):void{
            Tweener.removeTweens(this.view.right_bgs);
            this.view.right_bgs.target_y = (this.view.right_bgs.target_y - RIGHT_SCROLL);
            Tweener.addTween(this.view.right_bgs, {
                "y":this.view.right_bgs.target_y,
                "time":0.4,
                "transition":"easeInOutSine",
                "onComplete":function (){
                }
            });
            this.view.up_btn_right.visible = true;
            if (this.view.right_bgs.target_y == (this.right_bgs_start_y - (RIGHT_SCROLL * 2)))
            {
                this.view.down_btn_right.visible = false;
            };
        }
        function show_caption_popup(_arg1:MouseEvent):void{
            var _local2:String;
            var _local3:String;
            if (Main.getInstance().current_section == Constants.SECTION_RUNWAY)
            {
                _local2 = Pop_Up.PHOTO_CAPTION_RUNWAY;
                _local3 = "Check out this fabulous look in Fashionista Faceoff!";
            } else
            {
                _local2 = Pop_Up.LOOK_PHOTO_CAPTION;
                _local3 = "Vote for my fabulous look in Fashionista FaceOff!";
            };
            var _local4:String = ((_local3 + "  ") + Util.url_with_http(Constants.FACEBOOK_APP_PAGE));
            Pop_Up.getInstance().display_popup(_local2, _local4, this.save_photo);
        }
        function save_photo(caption:String):void{
            SoundEffectManager.getInstance().play_sound(Constants.RUNWAY_SOUND_FX, Constants.RUNWAY_SOUND_FX_VOLUME);
            var bd:BitmapData = new BitmapData(this.view.photo_mask.width, this.view.photo_mask.height, true, 0);
            bd.draw(this.view.photo_container);
            Tracer.out("SnapshotController > generated photo bitmapdata");
            FacebookConnector.post_look_photo(bd, caption, this.is_user_look);
            this.view.photo_container.flash.alpha = 1;
            Tweener.addTween(this.view.photo_container.flash, {
                "alpha":0,
                "time":0.5,
                "transition":"linear",
                "onComplete":function (){
                }
            });
        }
        public function photo_posted(_arg1:String):void{
            if (Main.getInstance().current_section == "dressing_room")
            {
                if (AvatarController.getInstance().get_avatar_item_ids() == "")
                {
                    this.view.confirm_mc.enter_btn.visible = false;
                    this.view.confirm_mc.more_btn.x = MORE_MIDDLE_X;
                } else
                {
                    this.view.confirm_mc.enter_btn.visible = true;
                    this.view.confirm_mc.more_btn.x = MORE_LEFT_X;
                };
                this.view.confirm_mc.visible = true;
            } else
            {
                Notification.getInstance().small_notice((("Your photo was saved to your " + Album.nameForType(Album.TYPE_LOOKS)) + " Album"));
            };
        }
        function enter_contest(_arg1:MouseEvent):void{
            this.close(_arg1);
            dispatchEvent(new Event(ENTER_LOOK));
        }
        function close_confirm(_arg1:MouseEvent):void{
            this.view.confirm_mc.visible = false;
        }

    }
}//package com.viroxoty.fashionista.ui

