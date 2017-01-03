// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.cities.CityParis

package com.viroxoty.fashionista.cities{
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.asset.AssetDataObject;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class CityParis extends AbstractCity {

        private static const ZOOM_FINAL_FRAME:int = 73;
        private static const SCROLL_TIME:int = 2;
        private static const CITY_START_ADJ:int = -400;
        private static const SCROLL_RIGHT_ADJ:Number = -340;
        private static const SCROLL_LEFT_ADJ:Number = 400;
        private static const FIREWORKS_SCROLL_FACTOR:Number = 0.5;
        private static const SKY_SCROLL_FACTOR:Number = 0.25;

        private static var _instance:CityParis;

        private var fireworks:MovieClip;
        private var sky:MovieClip;
        private var city_start_x:Number;
        private var fireworks_start_x:Number;
        private var sky_start_x:Number;
        private var left_btn:MovieClip;
        private var right_btn:MovieClip;
        private var ready:Boolean;
        private var tracked:Boolean;
        private var welcomed:Boolean;

        public function CityParis(){
            id = 2;
            CityManager.getInstance().current_city = id;
            super();
            _instance = this;
            Tracer.out("New CityParis");
        }
        public static function getInstance():CityParis{
            if (_instance == null)
            {
                _instance = new (CityParis)();
            };
            return (_instance);
        }

        public function load_zoom(){
            Main.getInstance().set_section("paris_zoom");
            Tracer.out("loading paris zoom swf");
            var _local1:* = ((Constants.SERVER_SWF + Constants.PARIS_ZOOM_FILENAME) + ".swf");
            var _local2:Object = {"assetLoaded":this.loaded_zoom_swf};
            var _local3:AssetDataObject = new AssetDataObject();
            _local3.parseURL(_local1);
            AssetManager.getInstance().getAssetFor(_local3, _local2);
            BackGroundMusic.getInstance().set_music(city.music);
            this.load_city();
        }
        public function loaded_zoom_swf(_arg1:MovieClip, _arg2:String):void{
            Tracer.out(("CityParis > loaded_zoom_swf: " + _arg2));
            MainViewController.getInstance().add_swf(_arg1);
            MainViewController.getInstance().hide_preloader();
            _arg1.addEventListener("zoom_complete", this.zoom_complete, false, 0, true);
            _arg1.addEventListener(MouseEvent.MOUSE_DOWN, this.zoom_complete, false, 0, true);
        }
        function zoom_complete(_arg1:Event):void{
            Tracer.out("zoom_complete");
            _arg1.currentTarget.removeEventListener("zoom_complete", this.zoom_complete);
            _arg1.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, this.zoom_complete);
            _arg1.currentTarget.gotoAndStop(ZOOM_FINAL_FRAME);
            this.ready = true;
            this.check_swap();
        }
        function check_swap():void{
            if (((mc) && (((!((Main.getInstance().current_section == "paris_zoom"))) || (this.ready)))))
            {
                this.ready = false;
                Main.getInstance().set_section("paris");
                MainViewController.getInstance().swap_swf(mc);
            };
        }
        override public function load(){
            this.ready = true;
            this.load_city();
        }
        function load_city(){
            Tracer.out("loading paris city swf");
            var _local1:* = ((Constants.SERVER_SWF + Constants.PARIS_FILENAME) + ".swf");
            var _local2:Object = {"assetLoaded":this.loaded_paris_swf};
            var _local3:AssetDataObject = new AssetDataObject();
            _local3.parseURL(_local1);
            AssetManager.getInstance().getAssetFor(_local3, _local2);
        }
        public function loaded_paris_swf(_arg1:MovieClip, _arg2:String):void{
            Tracer.out(("CityParis > loaded_paris_swf: " + _arg2));
            mc = _arg1;
            this.check_swap();
        }
        override public function init(){
            super.init();
            Tracer.out("CityParis > init");
            if (((UserData.getInstance().paris_welcome) && (!((this.welcomed == true)))))
            {
                Pop_Up.getInstance().display_popup(Pop_Up.PARIS_WELCOME);
                this.welcomed = true;
            };
            var _local2:* = city_mc.dressing_room_btn;
            var _local2 = _local2;
            with (_local2)
            {
                buttonMode = true;
                addEventListener(MouseEvent.CLICK, open_dressing_room, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OVER, dressing_room_over, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OUT, dressing_room_out, false, 0, true);
            };
            city_mc.dressing_room_mc.startScaleX = city_mc.dressing_room_mc.scaleX;
            city_mc.dressing_room_mc.startScaleY = city_mc.dressing_room_mc.scaleY;
            _local2 = city_mc.my_boutique_btn;
            with (_local2)
            {
                buttonMode = true;
                addEventListener(MouseEvent.CLICK, open_my_boutique, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OVER, my_boutique_over, false, 0, true);
                addEventListener(MouseEvent.MOUSE_OUT, my_boutique_out, false, 0, true);
            };
            city_mc.my_boutique_mc.startScaleX = city_mc.my_boutique_mc.scaleX;
            city_mc.my_boutique_mc.startScaleY = city_mc.my_boutique_mc.scaleY;
            var runway_btn:MovieClip = city_mc.runway_mc;
            _local2 = runway_btn;
            with (_local2)
            {
                buttonMode = true;
                addEventListener(MouseEvent.CLICK, open_runway, false, 0, true);
            };
            Util.create_tooltip("CLICK HERE TO VOTE OR COMPETE!", mc, "left", "bottom", runway_btn);
            this.sky = mc.sky;
            this.fireworks = mc.fireworks;
            this.city_start_x = (city_mc.x + CITY_START_ADJ);
            city_mc.x = this.city_start_x;
            this.fireworks_start_x = (this.fireworks.x + CITY_START_ADJ);
            this.fireworks.x = this.fireworks_start_x;
            this.sky_start_x = (this.sky.x + CITY_START_ADJ);
            this.sky.x = this.sky_start_x;
            Tracer.out(((((("city.x = " + city.x) + ", fireworks.x  = ") + this.fireworks.x) + ", sky.x = ") + this.sky.x));
            this.add_button_events();
            setup_boutiques();
        }
        public function track_visit():void{
            if (((UserData.getInstance().paris_welcome) && (!((this.tracked == true)))))
            {
                this.tracked = true;
                DataManager.getInstance().track_game_event("visit", "paris");
            };
        }
        private function add_button_events():void{
            this.left_btn = (MainViewController.getInstance().get_game_asset("arrow_left_blinking") as MovieClip);
            this.left_btn.buttonMode = true;
            this.left_btn.addEventListener(MouseEvent.CLICK, this.scroll_left, false, 0, true);
            this.left_btn.x = 60;
            this.left_btn.y = 10;
            mc.addChild(this.left_btn);
            Util.create_tooltip("NEW BOUTIQUES!", this.left_btn, "left", "top");
            this.right_btn = (MainViewController.getInstance().get_game_asset("arrow_right_blinking") as MovieClip);
            this.right_btn.buttonMode = true;
            this.right_btn.addEventListener(MouseEvent.CLICK, this.scroll_right, false, 0, true);
            this.right_btn.x = 700;
            this.right_btn.y = 10;
            mc.addChild(this.right_btn);
            Util.create_tooltip("MORE BOUTIQUES!", this.right_btn, "right", "top");
        }
        private function scroll_left(e:MouseEvent):void{
            var newCX:Number;
            var newFX:Number;
            var newSX:Number;
            Tweener.removeTweens(city_mc);
            Tweener.removeTweens(this.fireworks);
            Tweener.removeTweens(this.sky);
            if (city_mc.x >= this.city_start_x)
            {
                newCX = (this.city_start_x + SCROLL_LEFT_ADJ);
                newFX = (this.fireworks_start_x + (SCROLL_LEFT_ADJ * FIREWORKS_SCROLL_FACTOR));
                newSX = (this.sky_start_x + (SCROLL_LEFT_ADJ * SKY_SCROLL_FACTOR));
                this.left_btn.visible = false;
            } else
            {
                newCX = this.city_start_x;
                newFX = this.fireworks_start_x;
                newSX = this.sky_start_x;
            };
            Tweener.addTween(city_mc, {
                "x":newCX,
                "time":SCROLL_TIME,
                "transition":"easeoutsine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.fireworks, {
                "x":newFX,
                "time":SCROLL_TIME,
                "transition":"easeoutsine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.sky, {
                "x":newSX,
                "time":SCROLL_TIME,
                "transition":"easeoutsine",
                "onComplete":function (){
                }
            });
            this.right_btn.visible = true;
        }
        private function scroll_right(e:MouseEvent):void{
            var newCX:Number;
            var newFX:Number;
            var newSX:Number;
            Tweener.removeTweens(city_mc);
            Tweener.removeTweens(this.fireworks);
            Tweener.removeTweens(this.sky);
            if (city_mc.x <= this.city_start_x)
            {
                newCX = (this.city_start_x + SCROLL_RIGHT_ADJ);
                newFX = (this.fireworks_start_x + (SCROLL_RIGHT_ADJ * FIREWORKS_SCROLL_FACTOR));
                newSX = (this.sky_start_x + (SCROLL_RIGHT_ADJ * SKY_SCROLL_FACTOR));
                this.right_btn.visible = false;
            } else
            {
                newCX = this.city_start_x;
                newFX = this.fireworks_start_x;
                newSX = this.sky_start_x;
            };
            Tweener.addTween(city_mc, {
                "x":newCX,
                "time":SCROLL_TIME,
                "transition":"easeoutsine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.fireworks, {
                "x":newFX,
                "time":SCROLL_TIME,
                "transition":"easeoutsine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.sky, {
                "x":newSX,
                "time":SCROLL_TIME,
                "transition":"easeoutsine",
                "onComplete":function (){
                }
            });
            this.left_btn.visible = true;
        }
        private function dressing_room_over(e:MouseEvent):void{
            var clip:MovieClip = city_mc.dressing_room_mc;
            var _local3:* = clip;
            var _local3 = _local3;
            with (_local3)
            {
                filters = [glow_effect];
                scaleX = (clip.startScaleX * 1.05);
                scaleY = (clip.startScaleY * 1.05);
            };
        }
        private function dressing_room_out(e:MouseEvent):void{
            var clip:MovieClip = city_mc.dressing_room_mc;
            var _local3:* = clip;
            var _local3 = _local3;
            with (_local3)
            {
                filters = [];
                scaleX = clip.startScaleX;
                scaleY = clip.startScaleY;
            };
        }
        private function my_boutique_over(e:MouseEvent):void{
            var clip:MovieClip = city_mc.my_boutique_mc;
            var _local3:* = clip;
            var _local3 = _local3;
            with (_local3)
            {
                filters = [glow_effect];
                scaleX = (clip.startScaleX * 1.05);
                scaleY = (clip.startScaleY * 1.05);
            };
        }
        private function my_boutique_out(e:MouseEvent):void{
            var clip:MovieClip = city_mc.my_boutique_mc;
            var _local3:* = clip;
            var _local3 = _local3;
            with (_local3)
            {
                filters = [];
                scaleX = clip.startScaleX;
                scaleY = clip.startScaleY;
            };
        }

    }
}//package com.viroxoty.fashionista.cities

