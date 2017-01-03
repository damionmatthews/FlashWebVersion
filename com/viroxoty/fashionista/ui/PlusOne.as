// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.PlusOne

package com.viroxoty.fashionista.ui{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.sound.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.main.*;

    public class PlusOne extends Sprite {

        static const OUT_TIME:Number = 1;

        public function PlusOne(){
            var _local1:MovieClip = (MainViewController.getInstance().get_game_asset("plus_one") as MovieClip);
            addChild(_local1);
            addEventListener(Event.ADDED_TO_STAGE, this.tween_out, false, 0, true);
        }
        function tween_out(_arg1=null){
            Tweener.addTween(this, {
                "y":(y - 20),
                "time":OUT_TIME,
                "transition":"linear"
            });
            Tweener.addTween(this, {
                "alpha":0,
                "time":OUT_TIME,
                "transition":"easeInExpo",
                "onComplete":this.destroy
            });
            SoundEffectManager.getInstance().play_coin_drop();
        }
        public function destroy():void{
            parent.removeChild(this);
        }

    }
}//package com.viroxoty.fashionista.ui

