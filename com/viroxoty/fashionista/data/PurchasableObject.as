// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.PurchasableObject

package com.viroxoty.fashionista.data{
    import com.viroxoty.fashionista.util.*;

    public dynamic class PurchasableObject {

        public var id:int;
        public var name:String;
        public var price:int;
        public var swf:String;
        public var cost_fcash:int;
        public var cost_fbcredits:int;
        public var fb_credits:Boolean;
        public var level:int;
        public var description:String;
        public var restrictions:Array;

        public static function from_object(_arg1:Object):PurchasableObject{
            var _local2:String;
            var _local3:PurchasableObject = new (PurchasableObject)();
            for (_local2 in _arg1)
            {
                if (_local3.hasOwnProperty(_local2))
                {
                    _local3[_local2] = _arg1[_local2];
                };
            };
            return (_local3);
        }

        public function hasRestriction(_arg1:String):Boolean{
            return (((this.restrictions) && ((this.restrictions.indexOf(_arg1) > -1))));
        }

    }
}//package com.viroxoty.fashionista.data

