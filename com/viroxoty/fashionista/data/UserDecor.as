// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.UserDecor

package com.viroxoty.fashionista.data{
    public dynamic class UserDecor extends TransformableObject {

        public var id:int;
        public var decor:Decor;
        public var floor:int;

        public static function parseServerData(_arg1:Object):UserDecor{
            var _local2:String;
            var _local3:UserDecor = new (UserDecor)();
            for (_local2 in _arg1)
            {
                if (_local2 == "userDecorId")
                {
                    _local3.id = _arg1.userDecorId;
                } else
                {
                    if (!(((((((((((((((((_local2 == "decorId")) || ((_local2 == "filename")))) || ((_local2 == "subcategoryName")))) || ((_local2 == "categoryName")))) || ((_local2 == "name")))) || ((_local2 == "description")))) || ((_local2 == "cost_fcash")))) || ((_local2 == "cost_fbcredits")))) || ((_local2 == "level"))))
                    {
                        if (_local2 == "scale")
                        {
                            _local3[_local2] = (((_arg1[_local2])==null) ? 1 : _arg1[_local2]);
                        } else
                        {
                            _local3[_local2] = _arg1[_local2];
                        };
                    };
                };
            };
            return (_local3);
        }

    }
}//package com.viroxoty.fashionista.data

