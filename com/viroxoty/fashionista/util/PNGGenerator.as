// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.util.PNGGenerator

package com.viroxoty.fashionista.util{
    import com.viroxoty.fashionista.AvatarController;
    import flash.utils.ByteArray;
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.*;

    public class PNGGenerator {

        static const LOOK_PNG_WIDTH:int = 200;
        static const LOOK_PNG_HEIGHT:int = 400;

        public static function generate_look_png(_arg1:AvatarController):ByteArray{
            return (PNGEncoder.encode(generate_look_bitmap(_arg1)));
        }
        public static function generate_look_bitmap(_arg1:AvatarController):BitmapData{
            var _local2:MovieClip;
            var _local3:BitmapData;
            _local2 = _arg1.get_avatar_mc();
            _local2.defaultMask = _local2.mask;
            _local2.mask = null;
            _local2.parent_clip = _local2.parent;
            _local2.index = _local2.parent.getChildIndex(_local2);
            _local2.currentScaleX = _local2.scaleX;
            _local2.currentScaleY = _local2.scaleY;
            _local2.current_x = _local2.x;
            _local2.current_y = _local2.y;
            _local2.scaleX = 1;
            _local2.scaleY = 1;
            _local2.x = ((LOOK_PNG_WIDTH - 200) / 2);
            _local2.y = ((LOOK_PNG_HEIGHT - 400) / 2);
            var _local4:Sprite = new Sprite();
            _local4.addChild(_local2);
            _local3 = new BitmapData(LOOK_PNG_WIDTH, LOOK_PNG_HEIGHT, true, 0);
            _local3.draw(_local4);
            _local2.scaleX = _local2.currentScaleX;
            _local2.scaleY = _local2.currentScaleY;
            _local2.x = _local2.current_x;
            _local2.y = _local2.current_y;
            _local2.parent_clip.addChildAt(_local2, _local2.index);
            _local2.mask = _local2.defaultMask;
            return (_local3);
        }
        public static function generate_png(_arg1:MovieClip, _arg2:int, _arg3:int):ByteArray{
            var _local4:BitmapData = new BitmapData(_arg2, _arg3, true, 0);
            _local4.draw(_arg1);
            var _local5:ByteArray = PNGEncoder.encode(_local4);
            return (_local5);
        }

    }
}//package com.viroxoty.fashionista.util

