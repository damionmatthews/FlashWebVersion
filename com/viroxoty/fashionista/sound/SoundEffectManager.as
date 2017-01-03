// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.sound.SoundEffectManager

package com.viroxoty.fashionista.sound{
    import flash.media.Sound;
    import flash.media.SoundLoaderContext;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.events.IOErrorEvent;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import flash.net.*;
    import flash.display.*;
    import com.viroxoty.fashionista.util.*;
    import flash.media.*;

    public class SoundEffectManager {

        private static var _instance:SoundEffectManager;

        private var sound_object:Sound;
        var context:SoundLoaderContext;
        private var channels:Object;
        private var sounds:Object;
        private var play_pending:Boolean;

        public function SoundEffectManager(){
            _instance = this;
        }
        public static function getInstance():SoundEffectManager{
            if (_instance == null)
            {
                _instance = new (SoundEffectManager)();
            };
            return (_instance);
        }

        public function init():void{
            Tracer.out("SoundEffectManager > init");
            this.context = new SoundLoaderContext(1000);
            this.channels = {};
            this.sounds = {};
            this.load_sound("Chime.mp3", 0.75);
            this.load_sound("Coin.mp3", 0.75);
            this.load_sound("CoinDrop.mp3", 0.75);
        }
        public function stop_all():void{
            var _local1:String;
            for (_local1 in this.channels)
            {
                this.channels[_local1].stop();
            };
        }
        public function load_sound(file:String, volume:Number):void{
            var url:String = (Constants.SERVER_MUSIC + file);
            if (this.sounds[url] != null)
            {
                Tracer.out((("  Sound " + file) + " was already loaded, doing nothing"));
                return;
            };
            var req:* = new URLRequest(url);
            Tracer.out(("loading sound : " + url));
            try
            {
                this.sound_object = new Sound(req, this.context);
                this.sound_object.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler, false, 0, true);
                this.sounds[url] = this.sound_object;
                if (this.play_pending)
                {
                    this.play_pending = false;
                    this.play_sound(file, volume);
                };
            } catch(err:Error)
            {
                Tracer.out(err.message);
            };
        }
        public function play_pellet_drop():void{
            this.play_sound("Chime.mp3", 0.75);
        }
        public function play_coin_drop():void{
            this.play_sound("CoinDrop.mp3", 1);
        }
        public function play_sound(_arg1:String, _arg2:Number):void{
            var _local3:String = (Constants.SERVER_MUSIC + _arg1);
            if (this.sounds[_local3] == null)
            {
                Tracer.out((("SoundEffectManager > play_sound: ERROR : sound " + _arg1) + " doesn't exist!  loading sound..."));
                this.play_pending = true;
                this.load_sound(_arg1, _arg2);
                return;
            };
            if (BackGroundMusic.isMuted)
            {
                return;
            };
            Tracer.out(("SoundEffectManager > play_sound " + _arg1));
            var _local4:SoundChannel = this.sounds[_local3].play(0, 1);
            this.channels[_local3] = _local4;
            var _local5:SoundTransform = _local4.soundTransform;
            _local5.volume = _arg2;
            _local4.soundTransform = _local5;
        }
        public function stopSound(_arg1:String):void{
            var _local2:String = (Constants.SERVER_MUSIC + _arg1);
            var _local3:SoundChannel = this.channels[_local2];
            if (_local3 == null)
            {
                Tracer.out((("SoundEffectManager > play_sound: ERROR : sound " + _arg1) + " doesn't exist!"));
                return;
            };
            _local3.stop();
        }
        private function errorHandler(_arg1:IOErrorEvent):void{
            Tracer.out(((("The sound at " + _arg1.currentTarget.url) + " could not be loaded: ") + _arg1.text));
            this.sounds[_arg1.currentTarget.url] = null;
        }

    }
}//package com.viroxoty.fashionista.sound

