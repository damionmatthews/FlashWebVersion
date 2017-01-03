// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.boutique.BoutiqueDataObject

package com.viroxoty.fashionista.boutique{
    import flash.geom.Point;
    import flash.geom.*;
    import com.viroxoty.fashionista.util.*;

    public dynamic class BoutiqueDataObject {

        public static const BG_PNG:int = 0;
        public static const BG_SWF:int = 1;

        public var name:String;
        public var short_name:String;
        public var id:int;
        public var level:int;
        public var mini_level:int;
        public var type:int;
        public var categories:Array;
        public var dress_types:Array;
        public var isOpen:Boolean;
        public var background_url:String;
        public var background_type:int;
        public var music:String;
        public var city_id:int;
        public var models:Array;

        public function get avatar_scale():Number{
            return (this.models[0].scale);
        }
        public function get avatar_position():Point{
            return (this.models[0].position);
        }
        public function set background_is_swf(_arg1:int):void{
            this.background_type = _arg1;
            if (_arg1)
            {
                this.background_url = (((Constants.SERVER_SWF + "boutiques/") + this.short_name) + ".swf");
            } else
            {
                this.background_url = (((Constants.SERVER_IMAGES + "boutiques/") + this.short_name) + ".png");
            };
        }
        public function set_models(_arg1:Array):void{
            var _local2:Object;
            var _local3:BoutiqueModelDataObject;
            var _local4:Array;
            var _local5:Array;
            var _local6:Array;
            var _local8:int;
            this.models = [];
            var _local7:int = _arg1.length;
            while (_local8 < _local7)
            {
                _local2 = _arg1[_local8];
                _local3 = new BoutiqueModelDataObject();
                _local4 = _local2.position.split(",");
                _local3.position = new Point(_local4[0], _local4[1]);
                _local3.scale = _local2.scale;
                _local3.parseItemData(_local2.itemData);
                _local5 = _local2.styles.split(",");
                _local6 = _local2.colors.split(",");
                _local3.style = {
                    "hair":_local5[0],
                    "eyes":_local5[1],
                    "lips":_local5[2],
                    "hair_color":_local6[0],
                    "eye_color":_local6[1],
                    "lip_color":_local6[2],
                    "skin":_local2.skintone,
                    "eye_shade":_local2.eyeshade,
                    "eyebrows":_local2.eyebrows,
                    "blush":_local2.blush
                };
                this.models.push(_local3);
                _local8++;
            };
        }

    }
}//package com.viroxoty.fashionista.boutique

