// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.UserBoutiqueModel

package com.viroxoty.fashionista.data{
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.*;
    import __AS3__.vec.*;

    public class UserBoutiqueModel extends TransformableObject {

        public static const DEFAULT_X:int = 250;
        public static const DEFAULT_Y:int = 250;

        public var id:int;
        public var floor:int;
        public var placed:Boolean = true;
        public var timestamp:int;
        public var items:Vector.<Item>;
        public var pet:Item;
        private var _styles:String = "1,1,1,1,25,1,1,1,1,1";
        public var style_obj:Styles;

        public function UserBoutiqueModel(){
            x_pos = 175;
            y_pos = 250;
            z_pos = 0;
            this.style_obj = Styles.parse_style_string(this._styles);
            this.items = DressingRoom.get_default_clothing();
        }
        public static function parseServerData(_arg1:Object):UserBoutiqueModel{
            var _local2:String;
            var _local3:Array;
            var _local4:int;
            var _local5:int;
            var _local6:Item;
            var _local7:UserBoutiqueModel = new (UserBoutiqueModel)();
            for (_local2 in _arg1)
            {
                if (_local2 == "scale")
                {
                    _local7[_local2] = (((_arg1[_local2])==null) ? 1 : _arg1[_local2]);
                } else
                {
                    if (_local2 == "items")
                    {
                        _local7.items = new Vector.<Item>();
                        if ((((_arg1[_local2] == null)) || ((_arg1[_local2] == "null"))))
                        {
                            _local7.items = DressingRoom.get_default_clothing();
                            continue;
                        };
                        _local3 = _arg1[_local2];
                        _local4 = _local3.length;
                        while (_local5 < _local4)
                        {
                            _local6 = Item.parseUserBoutiqueModelItem(_local3[_local5]);
                            _local7.items.push(_local6);
                            _local5++;
                        };
                    } else
                    {
                        if (_local2 == "styles")
                        {
                            if (_arg1[_local2] != null)
                            {
                                _local7._styles = _arg1[_local2];
                            };
                            _local7.style_obj = Styles.parse_style_string(_local7._styles);
                        } else
                        {
                            if (_local2 == "placed")
                            {
                                _local7.placed = (_arg1[_local2] == "1");
                            } else
                            {
                                if (_local2 == "timestamp")
                                {
                                    _local7.timestamp = int(_arg1[_local2]);
                                } else
                                {
                                    _local7[_local2] = _arg1[_local2];
                                };
                            };
                        };
                    };
                };
            };
            if (_local7.items.length == 0)
            {
                _local7.reset_items();
            };
            return (_local7);
        }

        public function initAsSecondModel(){
            scale = -1;
            x_pos = 550;
            z_pos = 1;
        }
        public function get styles():String{
            return (this.style_obj.style_string);
        }
        public function get item_ids():String{
            var _local3:int;
            var _local1:* = "";
            var _local2:int = this.items.length;
            while (_local3 < _local2)
            {
                if (this.items[_local3].id == 0)
                {
                    return ("");
                };
                if (_local3 > 0)
                {
                    _local1 = (_local1 + ",");
                };
                _local1 = (_local1 + String(this.items[_local3].id));
                _local3++;
            };
            return (_local1);
        }
        public function toString():String{
            return (((((((((((((((this.id + ":") + this.floor) + ":") + this.item_ids) + ":") + this.styles) + ":") + x_pos) + ":") + y_pos) + ":") + z_pos) + ":") + scale));
        }
        public function reset_items():void{
            this.items = DressingRoom.get_default_clothing();
        }

    }
}//package com.viroxoty.fashionista.data

