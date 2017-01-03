// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.PelletController

package com.viroxoty.fashionista.ui{
    import flash.display.MovieClip;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import caurina.transitions.*;

    public class PelletController {

        static const EXPIRE_TIME:int = 8;
        static const OUT_TIME:Number = 1;
        public static const EXPIRE:String = "EXPIRE";

        var pellet:MovieClip;
        var expired:Boolean = false;

        public function PelletController(aPellet:MovieClip, expire_time:int){
            super();
            this.pellet = aPellet;
            this.pellet.scaleX = 0.2;
            this.pellet.scaleY = 0.2;
            Tweener.addTween(this.pellet, {
                "scaleX":1,
                "time":OUT_TIME,
                "transition":"easeOutExpo",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.pellet, {
                "scaleY":1,
                "time":OUT_TIME,
                "transition":"easeOutExpo",
                "onComplete":function (){
                }
            });
            var x_offset:Number = ((Math.random() * 100) - 50);
            Tweener.addTween(this.pellet, {
                "x":(this.pellet.x + x_offset),
                "time":OUT_TIME,
                "transition":"easeOutSine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.pellet, {
                "y":(this.pellet.y - 25),
                "time":(OUT_TIME / 3),
                "transition":"easeOutExpo",
                "onComplete":this.bounceDown
            });
            GameTimer.getInstance().registerForSingleEvent(expire_time, this.expire);
        }
        public function bounceDown():void{
            var y_offset:Number = (Math.random() * 25);
            Tweener.addTween(this.pellet, {
                "y":((this.pellet.y + 25) + y_offset),
                "time":((OUT_TIME * 2) / 3),
                "transition":"easeOutBounce",
                "onComplete":function (){
                }
            });
        }
        public function expire():void{
            if (((this.pellet.parent) && ((this.expired == false))))
            {
                this.expired = true;
                this.pellet.dispatchEvent(new Event(EXPIRE));
            };
        }
        public function blink_out(X:int, Y:int):void{
            Tweener.addTween(this.pellet, {
                "alpha":0.3,
                "time":OUT_TIME,
                "transition":"easeOutBounce",
                "onComplete":this.removePellet
            });
            Tweener.addTween(this.pellet, {
                "x":X,
                "time":(OUT_TIME * 0.75),
                "transition":"easeInSine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.pellet, {
                "y":Y,
                "time":(OUT_TIME * 0.75),
                "transition":"easeInSine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.pellet, {
                "scaleX":0.2,
                "time":OUT_TIME,
                "transition":"easeInSine",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this.pellet, {
                "scaleY":0.2,
                "time":OUT_TIME,
                "transition":"easeInSine",
                "onComplete":function (){
                }
            });
        }
        public function removePellet():void{
            if (this.pellet.parent)
            {
                this.pellet.parent.removeChild(this.pellet);
            };
        }

    }
}//package com.viroxoty.fashionista.ui

