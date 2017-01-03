// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.CleanupController

package com.viroxoty.fashionista.ui{
    import flash.system.ApplicationDomain;
    import com.viroxoty.fashionista.data.UserBoutique;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.text.TextFormat;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.display.*;
    import com.viroxoty.fashionista.sound.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class CleanupController {

        static const NUM_JEWELS:int = 3;
        static const SOUNDS:Array = ["magical_sweep_01.mp3", "magical_sweep_02.mp3", "magical_sweep_03.mp3"];

        public static var total_jewels:int = (Constants.TOTAL_DAILY_CLEANUP_REWARD / Constants.CLEANUP_REWARD);//21
        static var jewels:Array = [];
        static var sound_index:int = 0;
        static var assets_domain:ApplicationDomain;
        static var pending:Function;
        static var cur_boutique:UserBoutique;
        static var boutiques:Array = [];

        public static function check_cleanup(_arg1:UserBoutique):Boolean{
            return ((((total_jewels > 0)) && ((boutiques.indexOf(_arg1.id) == -1))));
        }
        public static function create_mess(_arg1:UserBoutique){
            Tracer.out("CleanupController > create_mess");
            if (total_jewels == 0)
            {
                return;
            };
            if (boutiques.indexOf(_arg1.id) > -1)
            {
                return;
            };
            boutiques.push(_arg1.id);
            cur_boutique = _arg1;
            if (assets_domain)
            {
                make_mess();
                return;
            };
            pending = make_mess;
            load_swf();
        }
        public static function remove_mess(){
            if (jewels.length > 0)
            {
                jewels.forEach(remove_jewel);
                jewels = [];
            };
            cur_boutique = null;
        }
        public static function get_asset(_arg1:String):Object{
            var _local2:Class;
            var _local3:Object;
            if (assets_domain)
            {
                _local2 = Class(assets_domain.getDefinition(_arg1));
                _local3 = new (_local2)();
                return (_local3);
            };
            return (null);
        }
        static function make_mess(){
            var _local1:MovieClip;
            Pop_Up.getInstance().add_popup_clip(setup_welcome());
            var _local2:int = Math.min(NUM_JEWELS, total_jewels);
            while (_local2 > 0)
            {
                _local1 = JewelFactory.make_jewel();
                jewels.push(_local1);
                Util.simpleButton(_local1, click_jewel);
                _local2--;
            };
        }
        static function click_jewel(_arg1:Event):void{
            play_sound();
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            get_reward(_local2);
            _local2.removeEventListener(MouseEvent.CLICK, click_jewel);
            remove_jewel(_local2);
            Util.remove(jewels, _local2);
        }
        static function play_sound(){
            SoundEffectManager.getInstance().play_sound(SOUNDS[(sound_index++ % SOUNDS.length)], 0.75);
        }
        static function remove_jewel(_arg1:MovieClip, _arg2:int=0, _arg3:Array=null){
            _arg1.parent.removeChild(_arg1);
            _arg1 = null;
        }
        static function get_reward(_arg1:MovieClip):void{
            total_jewels--;
            Tracer.out(("CleanupController > total_jewels left: " + total_jewels));
            DataManager.getInstance().credit_user(Constants.REASON_CLEANUP_REWARD, Constants.CLEANUP_REWARD);
            var _local2:FloatingText = new FloatingText((("+" + Constants.CLEANUP_REWARD) + " FashionCash"), _arg1.x, _arg1.y);
            MainViewController.getInstance().add_game_element(_local2);
        }
        static function load_swf(){
            var set_app_domain:Function;
            set_app_domain = function (_arg1:ApplicationDomain){
                Tracer.out("CleanupController > set_app_domain");
                assets_domain = _arg1;
                if (pending != null)
                {
                    pending.call();
                    pending = null;
                };
            };
            Util.get_app_domain(((Constants.SERVER_SWF + Constants.CLEANUP_FILENAME) + ".swf"), set_app_domain);
        }
        static function setup_welcome():MovieClip{
            var _local1:MovieClip = (get_asset("welcome") as MovieClip);
            var _local2:TextFormat = new TextFormat();
            _local2.bold = true;
            _local1.name_txt.defaultTextFormat = _local2;
            _local1.name_txt.text = (cur_boutique.username + "'s");
            var _local3:ImageLoader = new ImageLoader(Constants.fb_pic_for_id(String(cur_boutique.user_id)), _local1.pic, 60, 60);
            return (_local1);
        }

    }
}//package com.viroxoty.fashionista.ui

