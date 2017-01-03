// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.FloatingText

package com.viroxoty.fashionista.ui{
    import flash.text.TextField;
    import flash.text.Font;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;
    import flash.filters.DropShadowFilter;
    import flash.text.*;
    import caurina.transitions.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;
    import flash.filters.*;

    public class FloatingText extends TextField {

        static const OUT_TIME:int = 3;
        static const RISE:int = 30;

        public function FloatingText(s:String, X:Number, Y:Number){
            super();
            Tracer.out("new FloatingText");
            var f:Font = (MainViewController.getInstance().get_game_asset("frankfurter") as Font);
            var tf:TextFormat = new TextFormat(f.fontName, 18);
            tf.color = 0xFFFFFF;
            defaultTextFormat = tf;
            embedFonts = true;
            autoSize = TextFieldAutoSize.LEFT;
            text = s;
            x = (X - (width / 2));
            y = (Y - (height / 2));
            mouseEnabled = false;
            var gf:GlowFilter = new GlowFilter(0xCC0066, 1, 2, 2, 3, 3);
            var df:DropShadowFilter = new DropShadowFilter(5, 45, 0, 1, 5, 5, 2);
            this.filters = [gf, df];
            Tweener.addTween(this, {
                "y":(y - 40),
                "time":OUT_TIME,
                "transition":"linear",
                "onComplete":function (){
                }
            });
            Tweener.addTween(this, {
                "alpha":0,
                "time":OUT_TIME,
                "transition":"easeInExpo",
                "onComplete":this.destroy
            });
        }
        public function destroy():void{
            parent.removeChild(this);
        }

    }
}//package com.viroxoty.fashionista.ui

