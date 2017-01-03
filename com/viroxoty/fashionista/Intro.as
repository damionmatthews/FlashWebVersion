// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.Intro

package com.viroxoty.fashionista{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.media.*;

    public class Intro extends Sprite {

        static var gameStarted:Boolean = false;

        private var view:MovieClip;
        private var flag:Boolean;

        public function Intro(){
            Tracer.out("New Intro");
            this.flag = true;
            this.view = MainViewController.getInstance().intro_screen;
            var _local1:* = this.view.play_btn;
            _local1.buttonMode = true;
            _local1.mouseChildren = false;
            _local1.addEventListener(MouseEvent.CLICK, this.start_game);
            var _local2:* = this.view.mute_btn;
            _local2.buttonMode = true;
            _local2.addEventListener(MouseEvent.CLICK, this.mute_audio);
            if (BackGroundMusic.isMuted)
            {
                this.view.mute_btn.gotoAndStop(2);
                this.view.soundTransform = new SoundTransform(0);
            };
        }
        private function start_game(_arg1:MouseEvent):void{
            if (gameStarted)
            {
                return;
            };
            gameStarted = true;
            Tracer.out("Intro > start_game");
            _arg1.currentTarget.removeEventListener(MouseEvent.CLICK, this.start_game);
            _arg1.currentTarget.buttonMode = false;
            _arg1.currentTarget.parent.stop();
            _arg1.currentTarget.parent.vText.stop();
            Tracker.track_first_time(Tracker.PLAY_GAME);
            MainViewController.getInstance().exit_intro();
        }
        private function mute_audio(_arg1:MouseEvent):void{
            Tracer.out("Intro > mute_audio");
            if (BackGroundMusic.isMuted)
            {
                _arg1.currentTarget.gotoAndStop(1);
                BackGroundMusic.isMuted = false;
                this.view.soundTransform = new SoundTransform(1);
            } else
            {
                _arg1.currentTarget.gotoAndStop(2);
                BackGroundMusic.isMuted = true;
                this.view.soundTransform = new SoundTransform(0);
            };
        }

    }
}//package com.viroxoty.fashionista

