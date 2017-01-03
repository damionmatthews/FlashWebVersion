// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.adobe.utils.IntUtil

package com.adobe.utils{
    public class IntUtil {

        private static var hexChars:String = "0123456789abcdef";

        public static function rol(_arg1:int, _arg2:int):int{
            return (((_arg1 << _arg2) | (_arg1 >>> (32 - _arg2))));
        }
        public static function ror(_arg1:int, _arg2:int):uint{
            var _local3:int = (32 - _arg2);
            return (((_arg1 << _local3) | (_arg1 >>> (32 - _local3))));
        }
        public static function toHex(_arg1:int, _arg2:Boolean=false):String{
            var _local3:int;
            var _local4:int;
            var _local5:* = "";
            if (_arg2)
            {
                _local3 = 0;
                while (_local3 < 4)
                {
                    _local5 = (_local5 + (hexChars.charAt(((_arg1 >> (((3 - _local3) * 8) + 4)) & 15)) + hexChars.charAt(((_arg1 >> ((3 - _local3) * 8)) & 15))));
                    _local3++;
                };
            } else
            {
                _local4 = 0;
                while (_local4 < 4)
                {
                    _local5 = (_local5 + (hexChars.charAt(((_arg1 >> ((_local4 * 8) + 4)) & 15)) + hexChars.charAt(((_arg1 >> (_local4 * 8)) & 15))));
                    _local4++;
                };
            };
            return (_local5);
        }

    }
}//package com.adobe.utils

