// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.PelletFactory

package com.viroxoty.fashionista.ui{
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.main.MainViewController;
    import flash.events.Event;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.boutique.*;
    import flash.display.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class PelletFactory {

        static const POINTS_EXPIRE_TIME:int = 10;
        static const COINS_EXPIRE_TIME:int = 9;

        public static function make_cash_pellet(_arg1:int, _arg2:Number=1){
            var _local3:MovieClip;
            var _local4:MainViewController = MainViewController.getInstance();
            var _local5:MovieClip = (_local4.get_game_asset("pellet_fcash") as MovieClip);
            if (_arg2 == 1)
            {
                _local3 = _local5;
            } else
            {
                _local3 = new MovieClip();
                _local5.scaleX = _arg2;
                _local5.scaleY = _arg2;
                _local3.addChild(_local5);
            };
            set_location(_local3);
            _local3.buttonMode = true;
            _local3.addEventListener(MouseEvent.CLICK, click_cash, false, 0, true);
            var _local6:PelletController = new PelletController(_local3, COINS_EXPIRE_TIME);
            _local3.controller = _local6;
            _local3.addEventListener(PelletController.EXPIRE, get_cash, false, 0, true);
            _local3.cash_gain = _arg1;
            _local4.add_game_element(_local3);
        }
        public static function make_points_pellet(_arg1:int):void{
            var _local2:MainViewController = MainViewController.getInstance();
            var _local3:MovieClip = (_local2.get_game_asset("pellet_xp") as MovieClip);
            _local3.buttonMode = true;
            set_location(_local3);
            _local3.addEventListener(MouseEvent.CLICK, click_xp, false, 0, true);
            var _local4:PelletController = new PelletController(_local3, POINTS_EXPIRE_TIME);
            _local3.controller = _local4;
            _local3.addEventListener(PelletController.EXPIRE, get_xp, false, 0, true);
            _local3.points_gain = _arg1;
            _local2.add_game_element(_local3);
        }
        static function click_xp(_arg1:Event):void{
            SoundEffectManager.getInstance().play_sound("Chime.mp3", 0.75);
            get_xp(_arg1);
        }
        static function click_cash(_arg1:Event):void{
            SoundEffectManager.getInstance().play_sound("Coin.mp3", 0.75);
            get_cash(_arg1);
        }
        static function get_xp(_arg1:Event):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            UserData.getInstance().add_points(_local2.points_gain);
            var _local3:FloatingText = new FloatingText((("+" + _local2.points_gain) + " Points"), _local2.x, _local2.y);
            MainViewController.getInstance().add_game_element(_local3);
            _local2.removeEventListener(MouseEvent.CLICK, get_xp);
            _local2.removeEventListener(PelletController.EXPIRE, get_xp);
            _local2.controller.blink_out(325, -50);
        }
        static function get_cash(_arg1:Event):void{
            var _local2:MovieClip = (_arg1.currentTarget as MovieClip);
            UserData.getInstance().add_cash(_local2.cash_gain);
            var _local3:FloatingText = new FloatingText((("+" + _local2.cash_gain) + " FashionCash"), _local2.x, _local2.y);
            MainViewController.getInstance().add_game_element(_local3);
            _local2.removeEventListener(MouseEvent.CLICK, get_cash);
            _local2.removeEventListener(PelletController.EXPIRE, get_cash);
            _local2.controller.blink_out(460, -50);
        }
        static function set_location(_arg1:MovieClip):void{
            var _local2:*;
            var _local3:int;
            var _local4:int;
            if (MainViewController.getInstance().inMessageCenter())
            {
                _local4 = MessageCenter.getInstance().mode;
                if (_local4 == MessageCenter.WELCOME)
                {
                    _local2 = 550;
                    _local3 = 100;
                } else
                {
                    _local2 = 380;
                    _local3 = 400;
                };
            } else
            {
                switch (Main.getInstance().current_section)
                {
                    case "boutique":
                        if (BoutiqueManager.getInstance().is_themed() == false)
                        {
                            _local2 = 650;
                            _local3 = 30;
                            break;
                        };
                    case "city":
                    case "dressing_room":
                        _local2 = 380;
                        _local3 = 400;
                        break;
                    case "runway":
                        if (Runway.getInstance().mode == Runway.FACEOFF)
                        {
                            _local2 = 650;
                            _local3 = 30;
                            break;
                        };
                    default:
                        _local2 = 100;
                        _local3 = 400;
                };
            };
            Tracer.out(((("PelletFactory > set_location: x " + _local2) + ", y ") + _local3));
            _arg1.x = _local2;
            _arg1.y = _local3;
        }

    }
}//package com.viroxoty.fashionista.ui

