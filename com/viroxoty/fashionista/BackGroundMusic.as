// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.BackGroundMusic

package com.viroxoty.fashionista{
    import com.viroxoty.fashionista.sound.SoundEffectManager;
    import flash.media.Sound;
    import flash.media.SoundLoaderContext;
    import flash.media.SoundChannel;
    import flash.display.MovieClip;
    import com.adobe.utils.AccurateTimer;
    import flash.utils.Timer;
    import flash.media.SoundTransform;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;
    import flash.display.*;
    import flash.system.*;
    import com.viroxoty.fashionista.sound.*;
    import com.viroxoty.fashionista.util.*;
    import flash.media.*;
    import com.adobe.utils.*;

    public class BackGroundMusic {

        public static const GOOD_LOOP_OFFSET:int = 50;
        private static const ANTICIPATION:int = 200;
        private static const TOLERANCE:int = 50;

        private static var _instance:BackGroundMusic;
        public static var isMuted:Boolean = false;

        private var soundEffectManager:SoundEffectManager;
        private var sound_object:Sound;
        private var sound_object2:Sound;
        private var next_sound:Sound;
        var context:SoundLoaderContext;
        var context2:SoundLoaderContext;
        private var music_channel:SoundChannel;
        private var music_position:Number = 0;
        private var speakerMC:MovieClip;
        private var music_url:String;
        private var duration:int;
        var sound_timer:AccurateTimer;
        var switch_track_timer:AccurateTimer;
        var check_end_timer:Timer;
        var fade_out_timer:Timer;
        var fade_out_transform:SoundTransform;
        var fade_out_channel:SoundChannel;
        var fade_in_timer:Timer;
        var fade_in_transform:SoundTransform;
        var is_win:Boolean;

        public function BackGroundMusic(){
            var _local4:int;
            super();
            _instance = this;
            var _local1:String = Capabilities.os.substr(0, 3);
            this.is_win = true;
            this.soundEffectManager = SoundEffectManager.getInstance();
            var _local2:Array = Constants.MUTE_IDS;
            var _local3:int = _local2.length;
            while (_local4 < _local3)
            {
                if (DataManager.user_id == _local2[_local4])
                {
                    isMuted = true;
                    break;
                };
                _local4++;
            };
            Tracer.out("New BackGroundMusic");
        }
        public static function getInstance():BackGroundMusic{
            if (_instance == null)
            {
                _instance = new (BackGroundMusic)();
            };
            return (_instance);
        }

        public function init():void{
            Tracer.out("BackGroundMusic > init");
            this.context = new SoundLoaderContext(1000);
            this.fade_out_timer = new Timer(50, 0);
            this.fade_out_timer.addEventListener(TimerEvent.TIMER, this.fade_out, false, 0, true);
            this.fade_out_transform = new SoundTransform(1, 0);
            this.fade_in_timer = new Timer(50, 0);
            this.fade_in_timer.addEventListener(TimerEvent.TIMER, this.fade_in, false, 0, true);
            this.fade_in_transform = new SoundTransform(0, 0);
            if (this.is_win == false)
            {
                this.context2 = new SoundLoaderContext(1000);
                this.check_end_timer = new Timer(5, 0);
                this.check_end_timer.addEventListener(TimerEvent.TIMER, this.check_end, false, 0, true);
            };
            this.soundEffectManager.init();
        }
        public function set_music(file:String, dur:int=0):void{
            var url:String = (Constants.SERVER_MUSIC + file);
            if (url == this.music_url)
            {
                Tracer.out(" Same music, doing nothing");
                return;
            };
            this.soundEffectManager.stop_all();
            this.duration = dur;
            this.music_url = url;
            var req:* = new URLRequest(this.music_url);
            Tracer.out(("set_music : " + this.music_url));
            if (this.sound_object)
            {
                Tracer.out("  fading out old music");
                this.fade_out_channel = this.music_channel;
                if (this.fade_out_channel)
                {
                    this.fade_out_transform.volume = this.music_channel.soundTransform.volume;
                    this.fade_out_channel.soundTransform = this.fade_out_transform;
                    this.fade_out_timer.start();
                };
                if (this.is_win == false)
                {
                    this.sound_timer.stop();
                    this.sound_timer.removeEventListener(TimerEvent.TIMER, this.sound_complete);
                    if (this.switch_track_timer)
                    {
                        this.switch_track_timer.stop();
                    };
                    this.check_end_timer.stop();
                };
            };
            try
            {
                Tracer.out("about to load sound");
                this.sound_object = new Sound(req, this.context);
                this.sound_object.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler, false, 0, true);
                if (this.is_win == false)
                {
                    this.sound_object2 = new Sound(req, this.context2);
                    this.sound_object2.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler, false, 0, true);
                };
                if (isMuted == false)
                {
                    this.startMusic();
                };
            } catch(err:Error)
            {
                Tracer.out(err.message);
            };
        }
        private function errorHandler(_arg1:IOErrorEvent):void{
            Tracer.out(("The sound could not be loaded: " + _arg1.text));
        }
        private function fade_out(_arg1:Event):void{
            this.fade_out_transform.volume = (this.fade_out_transform.volume - 0.1);
            if (this.fade_out_transform.volume <= 0)
            {
                this.fade_out_channel.soundTransform.volume = 0;
                this.fade_out_timer.stop();
                this.fade_out_channel.stop();
                if (this.fade_out_channel != this.music_channel)
                {
                    this.fade_out_channel = null;
                };
                return;
            };
            this.fade_out_channel.soundTransform = this.fade_out_transform;
        }
        private function fade_in(_arg1:Event):void{
            this.fade_in_transform.volume = (this.fade_in_transform.volume + 0.075);
            if (this.fade_in_transform.volume >= 1)
            {
                this.music_channel.soundTransform.volume = 1;
                this.fade_in_timer.stop();
                return;
            };
            this.music_channel.soundTransform = this.fade_in_transform;
        }
        public function startMusic():void{
            Tracer.out("BackGroundMusic > startMusic");
            if (this.is_win)
            {
                this.music_channel = this.sound_object.play(GOOD_LOOP_OFFSET, 999999);
            } else
            {
                this.music_channel = this.sound_object.play(0, 1);
                this.next_sound = this.sound_object2;
                this.sound_timer = new AccurateTimer((this.duration - ANTICIPATION), 1);
                this.sound_timer.start();
                this.sound_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.sound_complete, false, 0, true);
            };
            this.fade_in_transform.volume = 0;
            this.music_channel.soundTransform = this.fade_in_transform;
            this.fade_in_timer.start();
        }
        public function stopMusic():void{
            Tracer.out("BackGroundMusic > stopMusic");
            this.music_position = this.music_channel.position;
            this.fade_in_timer.stop();
            if (((!((this.fade_out_channel == this.music_channel))) && (!((this.fade_out_channel == null)))))
            {
                this.fade_out_channel.stop();
            };
            this.fade_out_channel = this.music_channel;
            this.fade_out_transform.volume = this.music_channel.soundTransform.volume;
            this.fade_out_channel.soundTransform = this.fade_out_transform;
            this.fade_out_timer.start();
            if (this.is_win == false)
            {
                this.sound_timer.stop();
                if (this.switch_track_timer)
                {
                    this.switch_track_timer.stop();
                };
                this.check_end_timer.stop();
            };
            this.soundEffectManager.stop_all();
        }
        private function sound_complete(_arg1:Event):void{
            this.music_position = this.music_channel.position;
            if ((this.music_channel.position + TOLERANCE) >= this.duration)
            {
                this.switch_track();
            } else
            {
                this.switch_track_timer = new AccurateTimer((this.duration - this.music_channel.position), 1);
                this.switch_track_timer.addEventListener(TimerEvent.TIMER, this.switch_track, false, 0, true);
                this.switch_track_timer.start();
                this.check_end_timer.start();
            };
        }
        private function check_end(_arg1:Event):void{
            if ((this.music_channel.position + TOLERANCE) >= this.duration)
            {
                this.check_end_timer.stop();
                this.switch_track();
                return;
            };
        }
        private function switch_track(_arg1:Event=null):void{
            this.switch_track_timer.stop();
            this.music_channel = this.next_sound.play(0, 1);
            this.next_sound = (((this.next_sound)==this.sound_object) ? this.sound_object2 : this.sound_object);
            this.sound_timer = new AccurateTimer((this.duration - ANTICIPATION), 1);
            this.sound_timer.start();
            this.sound_timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.sound_complete, false, 0, true);
        }

    }
}//package com.viroxoty.fashionista

