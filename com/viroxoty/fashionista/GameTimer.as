// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.GameTimer

package com.viroxoty.fashionista{
    import flash.events.EventDispatcher;
    import com.adobe.utils.AccurateTimer;
    import flash.events.TimerEvent;
    import flash.events.*;
    import com.viroxoty.fashionista.util.*;
    import com.adobe.utils.*;

    public class GameTimer extends EventDispatcher {

        private static const timer_interval:Number = 1000;

        private static var _instance;

        private var timer:AccurateTimer;
        private var observers:Array;
        private var time_left:int;
        private var current_day:int;
        var week_expiry:int;
        var day_expiry:int;
        var local_offset:int;

        public function GameTimer(){
            Tracer.out("new GameTimer");
            this.timer = new AccurateTimer(timer_interval, 0);
            this.timer.addEventListener("timer", this.timer_handler);
            this.timer.start();
            this.observers = [];
        }
        public static function getInstance():GameTimer{
            if (_instance == null)
            {
                _instance = new (GameTimer)();
            };
            return (_instance);
        }

        public function registerForRepeatEvent(_arg1:int, _arg2:Function):void{
            this.observers.push({
                "callback":_arg2,
                "countdown":_arg1,
                "repeatCount":_arg1
            });
        }
        public function registerForSingleEvent(_arg1:int, _arg2:Function):void{
            this.observers.push({
                "callback":_arg2,
                "countdown":_arg1
            });
        }
        public function unregisterCallback(_arg1:Function):void{
            var _local2:int = this.observers.length;
            var _local3:int = (_local2 - 1);
            while (_local3 >= 0)
            {
                if (this.observers[_local3].callback == _arg1)
                {
                    this.observers.splice(_local3, 1);
                    return;
                };
                _local3--;
            };
        }
        public function timer_handler(_arg1:TimerEvent):void{
            var _local2:Object;
            var _local3:int = this.observers.length;
            var _local4:int = (_local3 - 1);
            while (_local4 >= 0)
            {
                _local2 = this.observers[_local4];
                _local2.countdown--;
                if (_local2.countdown == 0)
                {
                    _local2.callback.call();
                    if (_local2.repeatCount)
                    {
                        _local2.countdown = _local2.repeatCount;
                    } else
                    {
                        Tracer.out("GameTimer > timer_handler : removing single-event observer");
                        this.observers.splice(_local4, 1);
                    };
                };
                _local4--;
            };
        }
        public function setExpiry(_arg1:int, _arg2:int, _arg3:int){
            this.week_expiry = _arg1;
            this.day_expiry = _arg2;
            var _local4:Date = new Date();
            Tracer.out(("   week_expiry is " + this.week_expiry));
            Tracer.out(("   day_expiry is " + this.day_expiry));
            this.local_offset = Math.floor((_arg3 - (_local4.time / 1000)));
            Tracer.out((("   local_offset is " + this.local_offset) + " secs"));
            this.time_left = (this.week_expiry - int(((_local4.time / 1000) + this.local_offset)));
            Tracer.out(("   display_time : time_left in seconds = " + this.time_left));
            this.current_day = Math.floor((this.time_left / ((60 * 60) * 24)));
            this.display_time();
            this.registerForRepeatEvent(1, this.set_time);
        }
        private function display_time():void{
            var _local1:int = Math.floor((this.time_left / ((60 * 60) * 24)));
            var _local2:String = String(_local1);
            if (this.current_day != _local1)
            {
                this.update_day(_local1);
            };
            var _local3:int = (this.time_left - (((_local1 * 60) * 60) * 24));
            var _local4:int = Math.floor((_local3 / (60 * 60)));
            var _local5:String = (((_local4)<10) ? ("0" + _local4) : String(_local4));
            var _local6:int = (_local3 - ((_local4 * 60) * 60));
            var _local7:int = Math.floor((_local6 / 60));
            var _local8:String = (((_local7)<10) ? ("0" + _local7) : String(_local7));
            var _local9:int = (_local6 - (_local7 * 60));
            var _local10:String = (((_local9)<10) ? ("0" + _local9) : String(_local9));
            var _local11:String = ((((((_local2 + ":") + _local5) + ":") + _local8) + ":") + _local10);
            TopMenu.getInstance().display_time(_local11, this.time_left);
        }
        public function set_time(_arg1:TimerEvent=null):void{
            this.time_left--;
            this.display_time();
            dispatchEvent(new Event("timer"));
            if (this.time_left == 0)
            {
                this.challenge_expired();
            };
        }
        function challenge_expired():void{
            Tracer.out("### WEEKLY CHALLENGE EXPIRED ###");
            this.unregisterCallback(this.set_time);
            var _local1:Main = Main.getInstance();
            if (_local1.current_section != Constants.SECTION_CITY)
            {
                _local1.set_section(Constants.SECTION_CITY);
            };
            TopMenu.getInstance().reload_challenge();
        }
        function update_day(_arg1:int):void{
            Tracer.out("update day");
            this.current_day = _arg1;
            UserData.getInstance().refresh_daily_vars();
        }

    }
}//package com.viroxoty.fashionista

