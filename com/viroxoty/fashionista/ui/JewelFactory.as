// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.ui.JewelFactory

package com.viroxoty.fashionista.ui{
    import flash.display.MovieClip;
    import flash.events.*;
    import flash.display.*;
    import com.viroxoty.fashionista.main.*;
    import com.viroxoty.fashionista.util.*;

    public class JewelFactory {

        static const X_RANGE:Array = [150, (Constants.SCREEN_WIDTH - 50)];
        static const Y_RANGE:Array = [20, (Constants.GAME_SCREEN_HEIGHT - 40)];
        static const SCALE:Number = 0.25;

        public static function make_jewel(_arg1:Number=0.25):MovieClip{
            var _local2:MovieClip;
            var _local3:String = ("gem_" + Math.ceil((Math.random() * 12)));
            var _local4:MovieClip = (CleanupController.get_asset(_local3) as MovieClip);
            if (_arg1 == 1)
            {
                _local2 = _local4;
            } else
            {
                _local2 = new MovieClip();
                _local4.scaleX = _arg1;
                _local4.scaleY = _arg1;
                _local2.addChild(_local4);
            };
            _local2.rotation = int((Math.random() * 360));
            set_location(_local2);
            MainViewController.getInstance().add_cleanup_element(_local2);
            return (_local2);
        }
        static function set_location(_arg1:MovieClip):void{
            _arg1.x = Util.random_between(X_RANGE[0], X_RANGE[1]);
            _arg1.y = Util.random_between(Y_RANGE[0], Y_RANGE[1]);
        }

    }
}//package com.viroxoty.fashionista.ui

