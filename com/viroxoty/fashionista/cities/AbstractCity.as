// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.cities.AbstractCity

package com.viroxoty.fashionista.cities{
    import com.viroxoty.fashionista.cities.CityDataObject;
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.Pop_Up;
    import flash.filters.GlowFilter;
    import com.viroxoty.fashionista.boutique.BoutiqueDataObject;
    import flash.events.MouseEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.display.*;
    import com.viroxoty.fashionista.asset.*;
    import com.viroxoty.fashionista.cities.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.filters.*;

    class AbstractCity {

        protected static var id:int;

        protected var city:CityDataObject;
        protected var mc:MovieClip;
        protected var city_mc:MovieClip;
        protected var pop_obj:Pop_Up;
        protected var music_url:String;
        protected var music_duration:Number;
        public var boutique_list:Array;
        protected var glow_effect:GlowFilter;
        protected var glow_effect2:GlowFilter;

        public function AbstractCity(){
            Tracer.out("New AbstractCity");
            this.city = CityManager.getInstance().cities[id];
            this.boutique_list = this.city.boutiques;
            this.pop_obj = Pop_Up.getInstance();
            this.glow_effect = new GlowFilter();
            this.glow_effect.inner = true;
            this.glow_effect.color = 0xFFFFFF;
            this.glow_effect.blurX = 20;
            this.glow_effect.blurY = 20;
        }
        public function load(){
        }
        public function assetLoaded(_arg1:MovieClip, _arg2:String):void{
            Tracer.out(("AbstractCity > assetLoaded: " + _arg2));
            this.mc = _arg1;
            MainViewController.getInstance().add_swf(this.mc);
        }
        public function init(){
            Tracer.out("AbstractCity > init");
            this.city_mc = this.mc.city;
            BackGroundMusic.getInstance().set_music(this.city.music);
        }
        public function destroy(){
        }
        protected function setup_boutiques():void{
            var bdo:BoutiqueDataObject;
            var clip:MovieClip;
            var i:int;
            var _local2:* = undefined;
            var l:int = this.boutique_list.length;
            while (i < l)
            {
                bdo = this.boutique_list[i];
                Tracer.out(("AbstractCity > setup_boutiques : " + bdo.short_name));
                clip = this.city_mc[bdo.short_name];
                if (clip == null)
                {
                    Tracer.out(("AbstractCity > ERROR: no clip found named " + bdo.short_name));
                } else
                {
                    _local2 = clip;
                    var _local2 = _local2;
                    with (_local2)
                    {
                        if (bdo.isOpen)
                        {
                            buttonMode = true;
                            addEventListener(MouseEvent.MOUSE_OVER, store_over, false, 0, true);
                            addEventListener(MouseEvent.MOUSE_OUT, store_out, false, 0, true);
                            if (bdo.short_name == "dressing_room")
                            {
                                addEventListener(MouseEvent.CLICK, open_dressing_room, false, 0, true);
                            } else
                            {
                                if (bdo.short_name == "my_boutique")
                                {
                                    addEventListener(MouseEvent.CLICK, open_my_boutique, false, 0, true);
                                } else
                                {
                                    addEventListener(MouseEvent.CLICK, open_store, false, 0, true);
                                };
                            };
                        } else
                        {
                            Util.create_tooltip("COMING SOON!", mc, "left", "bottom", clip);
                        };
                    };
                    clip.startScaleX = clip.scaleX;
                    clip.startScaleY = clip.scaleY;
                    clip.boutique = bdo;
                };
                i = (i + 1);
            };
        }
        protected function store_over(e:MouseEvent):void{
            var clip:MovieClip = (e.currentTarget as MovieClip);
            var _local3:* = clip;
            var _local3 = _local3;
            with (_local3)
            {
                scaleX = (clip.startScaleX * 1.05);
                scaleY = (clip.startScaleY * 1.05);
                filters = [glow_effect];
            };
            Tracer.out(("store_over > filters = " + clip.filters));
        }
        protected function store_out(e:MouseEvent):void{
            var clip:MovieClip = (e.currentTarget as MovieClip);
            var _local3:* = clip;
            var _local3 = _local3;
            with (_local3)
            {
                filters = [];
                scaleX = clip.startScaleX;
                scaleY = clip.startScaleY;
            };
        }
        protected function open_store(_arg1:MouseEvent):void{
            var _local2:BoutiqueDataObject = _arg1.currentTarget.boutique;
            BoutiqueManager.getInstance().setup_boutique(_local2);
        }
        protected function open_dressing_room(_arg1:MouseEvent):void{
            _arg1.currentTarget.buttonMode = false;
            DressingRoom.getNewInstance().load();
        }
        protected function open_my_boutique(_arg1:MouseEvent):void{
            _arg1.currentTarget.buttonMode = false;
            MyBoutique.getInstance().load();
        }
        protected function open_runway(_arg1:MouseEvent):void{
            _arg1.currentTarget.buttonMode = false;
            Runway.getInstance().load(Runway.SHOW_WELCOME);
        }

    }
}//package com.viroxoty.fashionista.cities

