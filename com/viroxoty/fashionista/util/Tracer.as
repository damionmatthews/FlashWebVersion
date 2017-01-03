// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.util.Tracer

package com.viroxoty.fashionista.util{
    import flash.text.TextField;

    public class Tracer {

        private static var output:TextField;
        private static var text:String = "";

        public static function setOutput(_arg1:TextField):void{
            output = _arg1;
        }
        public static function out(_arg1:String, _arg2:Boolean=true):void{
            if (_arg2)
            {
                if (Constants.DEV_VERBOSE_OUTPUT == false)
                {
                    return;
                };
            };
            text = (text + ("\n" + _arg1));
            if (Constants.DEBUG != true)
            {
                return;
            };
            trace(_arg1);
        }
        public static function getOutput():String{
            return (text);
        }
        public static function trace(_arg1:String):void{
            if (output)
            {
                output.appendText(("\n" + _arg1));
                output.scrollV = output.maxScrollV;
            };
        }

    }
}//package com.viroxoty.fashionista.util

