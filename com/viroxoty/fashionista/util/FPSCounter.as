// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.util.FPSCounter

package com.viroxoty.fashionista.util{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.events.*;
    import flash.utils.*;
    import flash.text.*;

    public class FPSCounter extends Sprite {

        private var last:uint;
        private var ticks:uint = 0;
        private var tf:TextField;

        public function FPSCounter(_arg1:int=0, _arg2:int=0, _arg3:uint=0xFFFFFF, _arg4:Boolean=false, _arg5:uint=0){
            this.last = getTimer();
            super();
            x = _arg1;
            y = _arg2;
            this.tf = new TextField();
            this.tf.textColor = _arg3;
            this.tf.text = "----- fps";
            this.tf.selectable = false;
            this.tf.background = _arg4;
            this.tf.backgroundColor = _arg5;
            this.tf.autoSize = TextFieldAutoSize.LEFT;
            addChild(this.tf);
            width = this.tf.textWidth;
            height = this.tf.textHeight;
            addEventListener(Event.ENTER_FRAME, this.tick);
        }
        public function tick(_arg1:Event):void{
            var _local2:Number;
            this.ticks++;
            var _local3:uint = getTimer();
            var _local4:uint = (_local3 - this.last);
            if (_local4 >= 1000)
            {
                _local2 = ((this.ticks / _local4) * 1000);
                this.tf.text = (_local2.toFixed(1) + " fps");
                this.ticks = 0;
                this.last = _local3;
            };
        }

    }
}//package com.viroxoty.fashionista.util

