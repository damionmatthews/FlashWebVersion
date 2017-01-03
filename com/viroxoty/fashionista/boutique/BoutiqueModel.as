// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.BoutiqueModel

package com.viroxoty.fashionista.boutique{
    import flash.events.EventDispatcher;
    import flash.display.MovieClip;
    import flash.display.Loader;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.events.Event;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.util.*;

    public class BoutiqueModel extends EventDispatcher {

        private var avatar_mc:MovieClip;
        private var item_counter:int;
        private var total_items:int;
        private var hair_style_num:int = 1;
        private var hair_color_num:int = 1;
        private var lip_style_num:int = 1;
        private var lip_color_num:int = 1;
        private var eye_style_num:int = 1;
        private var eye_color_num:int = 1;
        private var skin_tone_num:int = 1;
        private var eye_shade_num:int = 1;
        private var eye_brows_num:int = 1;
        private var blush_num:int = 1;
        private var container_dict:Object;
        var item_loader:Loader;
        var item_container:MovieClip;
        var requester:Object;
        var model:BoutiqueModelDataObject;

        public function BoutiqueModel(){
            Tracer.out("new BoutiqueModel");
            this.container_dict = AvatarConstants.container_dict;
        }
        public function init():void{
            this.item_counter = 0;
        }
        public function get_boutique_model_for(_arg1:Object, _arg2:BoutiqueModelDataObject):void{
            Tracer.out(("get_boutique_model_for " + _arg1));
            this.requester = _arg1;
            this.model = _arg2;
            var _local3:AssetDataObject = new AssetDataObject();
            _local3.parseURL((Constants.SERVER_SWF + Constants.AVATAR_SWF));
            AssetManager.getInstance().getAssetFor(_local3, this);
        }
        public function assetLoaded(_arg1:MovieClip, _arg2:String):void{
            Tracer.out("BoutiqueModel > loaded avatar");
            this.avatar_mc = _arg1;
            this.requester.set_boutique_model(this.avatar_mc, this.model, this);
        }
        public function set_styles(_arg1:Object){
            var _local2:String;
            Tracer.out("BoutiqueModel > set_styles");
            for (_local2 in _arg1)
            {
                Tracer.out(((("   " + _local2) + " = ") + _arg1[_local2]));
            };
            this.set_avatar_hairstyle(_arg1.hair);
            this.set_avatar_haircolor(_arg1.hair_color);
            this.set_avatar_eyestyle(_arg1.eyes);
            this.set_avatar_eyecolor(_arg1.eye_color);
            this.set_avatar_lipstyle(_arg1.lips);
            this.set_avatar_lipcolor(_arg1.lip_color);
            this.set_avatar_skintone(_arg1.skin);
            this.set_avatar_eyeshade(_arg1.eye_shade);
            this.set_avatar_eyebrows(_arg1.eyebrows);
            this.set_avatar_blushcolor(_arg1.blush);
        }
        public function reset_item_counter():void{
            this.item_counter = 0;
        }
        function item_loaded(_arg1:Event){
            Tracer.out("display_contestant_item > item_loaded");
            this.item_counter++;
            if (this.item_counter == this.total_items)
            {
                this.avatar_mc.alpha = 0;
                this.avatar_mc.visible = true;
                this.avatar_mc.addEventListener(Event.ENTER_FRAME, this.fade_in_avatar);
            };
        }
        public function display_item(_arg1:String, _arg2:String, _arg3:int):void{
            this.total_items = _arg3;
            this.item_container = (this.avatar_mc.getChildByName(this.container_dict[_arg1]) as MovieClip);
            this.item_loader = new Loader();
            this.item_container.addChild(this.item_loader);
            Tracer.out(("display_item > requesting " + _arg2));
            var _local4:* = new URLRequest(_arg2);
            this.item_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.item_loaded);
            this.item_loader.load(_local4);
        }
        function fade_in_avatar(_arg1:Event):void{
            _arg1.currentTarget.alpha = (_arg1.currentTarget.alpha + 0.6);
            if (_arg1.currentTarget.alpha >= 1)
            {
                _arg1.currentTarget.alpha = 1;
                _arg1.currentTarget.removeEventListener(Event.ENTER_FRAME, this.fade_in_avatar);
                dispatchEvent(new Event("model_ready"));
            };
        }
        public function set_avatar_hairstyle(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("hair_mc");
            _local2.gotoAndStop(_arg1);
            this.hair_style_num = _arg1;
            this.set_avatar_haircolor(this.hair_color_num);
        }
        public function set_avatar_eyestyle(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyes_mc");
            _local2.gotoAndStop(_arg1);
            this.eye_style_num = _arg1;
            this.set_avatar_eyecolor(this.eye_color_num);
        }
        public function set_avatar_lipstyle(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("lips_mc");
            _local2.gotoAndStop(_arg1);
            this.lip_style_num = _arg1;
            this.set_avatar_lipcolor(this.lip_color_num);
        }
        public function set_avatar_eyebrows(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyebrow_mc");
            _local2.gotoAndStop(_arg1);
            this.eye_brows_num = _arg1;
        }
        public function set_avatar_skintone(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("skin_mc");
            _local2.gotoAndStop(_arg1);
            this.skin_tone_num = _arg1;
        }
        public function set_avatar_haircolor(num:int):void{
            var hair_style:* = undefined;
            var hair_color:Function;
            hair_style = undefined;
            this.hair_color_num = num;
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
                        MovieClip(hair_style.getChildAt(0)).gotoAndStop(hair_color_num);
                    };
                };
                hair_style.addEventListener(Event.ENTER_FRAME, hair_color);
            };
        }
        public function set_avatar_eyecolor(num:int):void{
            var eye_style:* = undefined;
            var eye_color:Function;
            eye_style = undefined;
            this.eye_color_num = num;
            eye_style = this.avatar_mc.getChildByName("eyes_mc");
            if (eye_style.getChildAt(0))
            {
                MovieClip(eye_style.getChildAt(0)).gotoAndStop(this.eye_color_num);
            } else
            {
                eye_color = function (_arg1:Event):void{
                    if (eye_style.getChildAt(0) != null)
                    {
                        eye_style.removeEventListener(Event.ENTER_FRAME, eye_color);
                        MovieClip(eye_style.getChildAt(0)).gotoAndStop(eye_color_num);
                    };
                };
                eye_style.addEventListener(Event.ENTER_FRAME, eye_color);
            };
        }
        public function set_avatar_lipcolor(num:int):void{
            var lip_style:MovieClip;
            var lip_color:Function;
            this.lip_color_num = num;
            lip_style = (this.avatar_mc.getChildByName("lips_mc") as MovieClip);
            if (lip_style.getChildAt(0))
            {
                MovieClip(lip_style.getChildAt(0)).gotoAndStop(this.lip_color_num);
            } else
            {
                lip_color = function (_arg1:Event):void{
                    if (lip_style.getChildAt(0) != null)
                    {
                        lip_style.removeEventListener(Event.ENTER_FRAME, lip_color);
                        MovieClip(lip_style.getChildAt(0)).gotoAndStop(lip_color_num);
                    };
                };
                lip_style.addEventListener(Event.ENTER_FRAME, lip_color);
            };
        }
        public function set_avatar_eyeshade(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("eyeshades_mc");
            _local2.gotoAndStop(_arg1);
            this.eye_shade_num = _arg1;
        }
        public function set_avatar_blushcolor(_arg1:int):void{
            var _local2:* = this.avatar_mc.getChildByName("blush_mc");
            _local2.gotoAndStop(_arg1);
            this.blush_num = _arg1;
        }

    }
}//package com.viroxoty.fashionista.boutique

