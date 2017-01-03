// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.adobe.utils.AccurateTimer

package com.adobe.utils{
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.*;

    public class AccurateTimer extends Timer {

        private var m_delay:Number = 0;
        private var m_lastTime:Date;
        private var m_accuracy:uint = 10;
        private var m_nCount:uint;
        private var m_nCurrentCount:uint;

        public function AccurateTimer(_arg1:Number, _arg2:uint){
            this.m_delay = _arg1;
            this.m_nCount = _arg2;
            addEventListener(TimerEvent.TIMER, this.ontmrTick, false, 0, true);
            super(this.m_accuracy, 0);
        }
        override public function get delay():Number{
            return (this.m_delay);
        }
        override public function set delay(_arg1:Number):void{
            this.m_delay = _arg1;
        }
        override public function get currentCount():int{
            return (this.m_nCurrentCount);
        }
        override public function get repeatCount():int{
            return (this.m_nCount);
        }
        override public function set repeatCount(_arg1:int):void{
            this.m_nCount = _arg1;
        }
        public function get accuracy():uint{
            return (this.m_accuracy);
        }
        public function set accuracy(_arg1:uint):void{
            this.m_accuracy = _arg1;
        }
        override public function start():void{
            this.m_lastTime = new Date();
            this.m_lastTime.time = (new Date().time + this.m_delay);
            super.start();
        }
        override public function stop():void{
            super.stop();
        }
        override public function reset():void{
            this.m_nCount = 0;
            this.m_nCurrentCount = 0;
            super.reset();
        }
        private function ontmrTick(_arg1:TimerEvent):void{
            var _local2:Date = new Date();
            if ((((((_local2.time > this.m_lastTime.time)) || (((this.m_lastTime.time - _local2.time) < (this.m_accuracy / 2))))) || ((_local2.time == this.m_lastTime.time))))
            {
                this.m_lastTime.time = (this.m_lastTime.time + this.m_delay);
                if (0 < this.m_nCount)
                {
                    this.m_nCurrentCount = (this.m_nCurrentCount + 1);
                    if (this.m_nCount == this.m_nCurrentCount)
                    {
                        dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
                        this.reset();
                        _arg1.stopImmediatePropagation();
                    };
                };
            } else
            {
                _arg1.stopImmediatePropagation();
            };
        }

    }
}//package com.adobe.utils

