// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.MiniLevelController

package com.viroxoty.fashionista.ui{
    import com.viroxoty.fashionista.main.MainViewController;
    import flash.events.Event;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class MiniLevelController {

        private static var _instance:MiniLevelController;

        var mini_level_ups:int = 0;
        var points_gain:int = 0;
        var pending:Boolean = false;

        public static function getInstance():MiniLevelController{
            if (_instance == null)
            {
                _instance = new (MiniLevelController)();
            };
            return (_instance);
        }

        public function set_reward(_arg1:int, _arg2:int){
            Tracer.out(((("MiniLevelController > mini_level_ups: " + _arg1) + ", points_gain: ") + _arg2));
            this.mini_level_ups = (this.mini_level_ups + _arg1);
            this.points_gain = (this.points_gain + _arg2);
            var _local3:MainViewController = MainViewController.getInstance();
            if (_local3.in_popup())
            {
                this.pending = true;
                _local3.addEventListener(MainViewController.CLOSED_POPUP, this.checkPending);
            } else
            {
                this.show_pellets();
            };
        }
        public function checkPending(_arg1:Event):void{
            var _local2:MainViewController;
            if (this.pending)
            {
                _local2 = MainViewController.getInstance();
                if (_local2.in_popup() == false)
                {
                    this.pending = false;
                    _local2.removeEventListener(MainViewController.CLOSED_POPUP, this.checkPending);
                    this.show_pellets();
                };
            };
        }
        public function show_pellets(){
            Tracer.out("MiniLevelController > showPellets");
            if (this.points_gain > 0)
            {
                PelletFactory.make_points_pellet(this.points_gain);
                this.points_gain = 0;
            };
            do 
            {
                this.mini_level_ups--;
                PelletFactory.make_cash_pellet(Constants.MINI_LEVEL_REWARD);
            } while (this.mini_level_ups > 0);
            SoundEffectManager.getInstance().play_sound("Chime.mp3", 0.75);
        }

    }
}//package com.viroxoty.fashionista.ui

