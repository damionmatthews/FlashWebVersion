// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.LightScroller

package com.viroxoty.fashionista.ui{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.*;
    import flash.display.*;

    public class LightScroller extends Sprite {

        public static const TARGET_CHANGED:String = "targetChanged";
        public static const SCROLLED:String = "scrolled";
        public static const SCROLLER_WIDTH:Number = 10;
        public static const COLOR:uint = 0x333333;

        var clip:MovieClip;
        var clipStartY:Number;
        var dispatcher:Object;
        var bgLine:Sprite;
        var scroller:Sprite;
        var startY:Number;
        var scrollerStartY:Number;
        var h:Number;

        public function LightScroller(_arg1:MovieClip, _arg2:Object){
            this.clip = _arg1;
            this.clipStartY = this.clip.y;
            this.h = this.clip.mask.height;
            this.dispatcher = _arg2;
            this.dispatcher.addEventListener(TARGET_CHANGED, this.targetChanged, false, 0, true);
            this.bgLine = new Sprite();
            this.bgLine.graphics.lineStyle(1, COLOR, 1, false, "normal", "none");
            this.bgLine.graphics.moveTo(0, 0);
            this.bgLine.graphics.lineTo(0, this.h);
            addChild(this.bgLine);
            this.scroller = new Sprite();
            this.scroller.graphics.beginFill(COLOR, 1);
            this.scroller.graphics.drawRect((-(SCROLLER_WIDTH) / 2), 0, SCROLLER_WIDTH, this.h);
            this.scroller.addEventListener(MouseEvent.MOUSE_DOWN, this.startScroll, false, 0, true);
            this.scroller.buttonMode = true;
            addChild(this.scroller);
            this.drawScroller();
        }
        function drawScroller(){
            if (this.clip.mask.height >= this.clip.height)
            {
                visible = false;
                return;
            };
            visible = true;
            this.scroller.height = ((this.h * this.clip.mask.height) / this.clip.height);
            this.scroller.y = (((this.h - this.scroller.height) * (this.clipStartY - this.clip.y)) / (this.clip.height - this.clip.mask.height));
        }
        function targetChanged(_arg1:Event):void{
            this.drawScroller();
        }
        function startScroll(_arg1:MouseEvent):void{
            this.startY = this.mouseY;
            this.scrollerStartY = this.scroller.y;
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.scroll, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_UP, this.stopScroll, false, 0, true);
        }
        function scroll(_arg1:MouseEvent):void{
            var _local2:* = (this.scrollerStartY + (this.mouseY - this.startY));
            _local2 = Math.min((this.h - this.scroller.height), _local2);
            _local2 = Math.max(_local2, 0);
            this.scroller.y = _local2;
            this.clip.y = (this.clipStartY - (((this.clip.height - this.clip.mask.height) * this.scroller.y) / (this.h - this.scroller.height)));
            dispatchEvent(new Event(SCROLLED));
            _arg1.updateAfterEvent();
        }
        function stopScroll(_arg1:MouseEvent):void{
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.scroll);
            stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopScroll);
        }

    }
}//package com.viroxoty.fashionista.ui

