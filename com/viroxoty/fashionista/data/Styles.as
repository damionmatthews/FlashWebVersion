// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.Styles

package com.viroxoty.fashionista.data{
    import com.adobe.serialization.json.*;

    public class Styles {

        public static var MAX_HAIR:int = 58;
        public static var MAX_EYES:int = 20;
        public static var MAX_LIPS:int = 29;
        public static var MAX_HAIR_COLOR:int = 9;
        public static var MAX_EYE_COLOR:int = 16;
        public static var MAX_LIP_COLOR:int = 20;
        public static var MAX_SKIN:int = 9;
        public static var MAX_EYE_SHADE:int = 47;
        public static var MAX_EYEBROWS:int = 24;
        public static var MAX_BLUSH:int = 6;

        public var hair:int = 1;
        public var eyes:int = 1;
        public var lips:int = 25;
        public var _hair_color:int = 1;
        public var eye_color:int = 1;
        public var lip_color:int = 1;
        public var _skin:int = 1;
        public var eye_shade:int = 1;
        public var _eyebrows:int = 1;
        public var blush:int = 1;

        public static function parse_style_string(_arg1:String):Styles{
            var _local2:Styles = new (Styles)();
            var _local3:Array = _arg1.split(",");
            _local2.hair = _local3[0];
            _local2.eyes = _local3[1];
            _local2.lips = _local3[2];
            _local2.hair_color = _local3[3];
            _local2.eye_color = _local3[4];
            _local2.lip_color = _local3[5];
            _local2.skin = _local3[6];
            _local2.eye_shade = _local3[7];
            _local2.eyebrows = _local3[8];
            _local2.blush = _local3[9];
            return (_local2);
        }
        public static function from_style_object(_arg1:Object):Styles{
            var _local2:String;
            var _local3:Styles = new (Styles)();
            for (_local2 in _arg1)
            {
                _local3[_local2] = _arg1[_local2];
            };
            return (_local3);
        }

        public function process_json(_arg1:Object):void{
            var _local2:Array = String(_arg1.styles).split(",");
            this.hair = _local2[0];
            this.eyes = _local2[1];
            this.lips = _local2[2];
            var _local3:Array = String(_arg1.colors).split(",");
            this.hair_color = _local3[0];
            this.eye_color = _local3[1];
            this.lip_color = _local3[2];
            this.skin = _arg1.skintone;
            this.eye_shade = _arg1.eyeshade;
            this.eyebrows = _arg1.eyebrows;
            this.blush = _arg1.blush;
        }
        public function get_copy():Styles{
            var _local1:Styles = Styles.parse_style_string(this.style_string);
            return (_local1);
        }
        public function get style_string():String{
            return (((((((((((((((((((this.hair + ",") + this.eyes) + ",") + this.lips) + ",") + this.hair_color) + ",") + this.eye_color) + ",") + this.lip_color) + ",") + this.skin) + ",") + this.eye_shade) + ",") + this.eyebrows) + ",") + this.blush));
        }
        public function toString():String{
            return (Json.encode(this));
        }
        public function get skin():int{
            if (this._skin > MAX_SKIN)
            {
                this._skin = MAX_SKIN;
            };
            return (this._skin);
        }
        public function set skin(_arg1:int):void{
            this._skin = Math.min(MAX_SKIN, _arg1);
        }
        public function get eyebrows():int{
            if (this._eyebrows > MAX_EYEBROWS)
            {
                this._eyebrows = MAX_EYEBROWS;
            };
            return (this._eyebrows);
        }
        public function set eyebrows(_arg1:int):void{
            this._eyebrows = Math.min(MAX_EYEBROWS, _arg1);
        }
        public function get hair_color():int{
            if (this._hair_color > MAX_HAIR_COLOR)
            {
                this._hair_color = MAX_HAIR_COLOR;
            };
            return (this._hair_color);
        }
        public function set hair_color(_arg1:int):void{
            this._hair_color = Math.min(MAX_HAIR_COLOR, _arg1);
        }

    }
}//package com.viroxoty.fashionista.data

