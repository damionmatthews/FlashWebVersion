// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.Decor

package com.viroxoty.fashionista.data{
    import com.viroxoty.fashionista.util.*;

    public dynamic class Decor extends PurchasableObject {

        public var png:String;
        public var category:String;
        public var subcategory:String;
        public var decor_category_id:int;
        public var decor_subcategory_id:int;
        public var userDecors:Array;
        public var available:Boolean;

        public function Decor(){
            this.userDecors = [];
            super();
        }
        public static function parseServerData(_arg1:Object):Decor{
            var _local2:String;
            var _local3:String;
            var _local4:Decor = new (Decor)();
            for (_local2 in _arg1)
            {
                if (_local2 == "filename")
                {
                    _local3 = _arg1.filename.toLowerCase();
                    _local4.swf = ((Constants.SERVER_DECOR + _local3) + ".swf");
                    _local4.png = (((Constants.SERVER_IMAGES + "decor/") + _local3) + ".png");
                } else
                {
                    if (_local2 == "categoryName")
                    {
                        _local4.category = _arg1.categoryName;
                    } else
                    {
                        if (_local2 == "subcategoryName")
                        {
                            _local4.subcategory = ((_arg1.subcategoryName) ? _arg1.subcategoryName.split(" ").join("_") : null);
                        } else
                        {
                            if (_local2 == "decorId")
                            {
                                _local4.id = _arg1.decorId;
                            } else
                            {
                                if (!(((((((((_local2 == "userDecorId")) || ((_local2 == "floor")))) || ((_local2 == "x_pos")))) || ((_local2 == "y_pos")))) || ((_local2 == "scale"))))
                                {
                                    if (_local2 == "available")
                                    {
                                        _local4.available = (_arg1.available == "1");
                                    } else
                                    {
                                        if (_local2 == "restrictions")
                                        {
                                            _local4.restrictions = (((_arg1.restrictions)==null) ? null : _arg1.restrictions.split(","));
                                        } else
                                        {
                                            _local4[_local2] = _arg1[_local2];
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            _local4.price = _local4.cost_fcash;
            return (_local4);
        }
        public static function parseMessageItem(_arg1:Object):Decor{
            var _local2:Decor;
            _local2 = new (Decor)();
            _local2.id = _arg1.Item_ID;
            _local2.name = _arg1.Item_Name;
            _local2.cost_fbcredits = _arg1.cost_fbcredits;
            _local2.cost_fcash = _arg1.cost;
            _local2.price = _local2.cost_fcash;
            _local2.description = _local2.Item_Desc;
            return (_local2);
        }
        public static function getDefaultWall():Decor{
            var _local1:Decor;
            _local1 = new (Decor)();
            _local1.id = 48;
            var _local2:* = "wall01";
            _local1.swf = ((Constants.SERVER_DECOR + _local2) + ".swf");
            _local1.png = (((Constants.SERVER_IMAGES + "decor/") + _local2) + ".png");
            _local1.category = "walls";
            return (_local1);
        }
        public static function getDefaultFloor():Decor{
            var _local2:*;
            var _local1:Decor = new (Decor)();
            _local1.id = 33;
            _local2 = "floor08";
            _local1.swf = ((Constants.SERVER_DECOR + _local2) + ".swf");
            _local1.png = (((Constants.SERVER_IMAGES + "decor/") + _local2) + ".png");
            _local1.category = "floors";
            return (_local1);
        }

        public function addInstance(_arg1:UserDecor){
            this.userDecors.push(_arg1);
            _arg1.decor = this;
        }
        public function get owned():Boolean{
            return (((this.userDecors) && ((this.userDecors.length > 0))));
        }
        public function get decorsPlaced():int{
            var _local2:int;
            var _local3:int;
            var _local1:int = this.userDecors.length;
            while (_local3 < _local1)
            {
                if (UserDecor(this.userDecors[_local3]).floor > 0)
                {
                    _local2++;
                };
                _local3++;
            };
            return (_local2);
        }
        public function get decorsAvailable():int{
            return ((this.userDecors.length - this.decorsPlaced));
        }
        public function get isWallFloor():Boolean{
            return ((((this.category == DecorCategories.WALLS)) || ((this.category == DecorCategories.FLOORS))));
        }
        public function getAvailableUserDecor():UserDecor{
            var _local2:int;
            var _local1:int = this.userDecors.length;
            while (_local2 < _local1)
            {
                if (UserDecor(this.userDecors[_local2]).floor == 0)
                {
                    return (this.userDecors[_local2]);
                };
                _local2++;
            };
            return (null);
        }
        public function newInstance():UserDecor{
            var _local1:UserDecor = new UserDecor();
            _local1.decor = this;
            return (_local1);
        }
        public function addAcceptGiftParams(_arg1:Object){
            this.category = _arg1.categoryName;
            var _local2:String = _arg1.filename.toLowerCase();
            swf = ((Constants.SERVER_DECOR + _local2) + ".swf");
            this.png = (((Constants.SERVER_IMAGES + "decor/") + _local2) + ".png");
        }
        public function addPurchaseData(_arg1:Decor){
            name = _arg1.name;
            cost_fbcredits = _arg1.cost_fbcredits;
            cost_fcash = _arg1.cost_fcash;
            price = _arg1.cost_fcash;
            description = _arg1.description;
            level = _arg1.level;
        }
        public function toString():String{
            return (((((((((((((((((((id + ":") + name) + ":") + price) + ":") + level) + ":") + description) + ":") + swf) + ":") + this.png) + ":") + this.category) + ":") + this.subcategory) + ":numUserDecors=") + this.userDecors.length));
        }

    }
}//package com.viroxoty.fashionista.data

