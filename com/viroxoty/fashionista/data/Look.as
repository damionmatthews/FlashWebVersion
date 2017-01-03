// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.Look

package com.viroxoty.fashionista.data{
    import __AS3__.vec.Vector;
    import com.viroxoty.fashionista.UserData;
    import com.viroxoty.fashionista.AvatarController;
    import com.viroxoty.fashionista.*;
    import __AS3__.vec.*;
    import com.adobe.serialization.json.*;
    import com.viroxoty.fashionista.util.*;

    public class Look {

        public var id:int;
        public var user_id:String;
        public var name:String;
        public var team:int;
        public var profile_url:String;
        public var activeBoutique:Boolean;
        public var items:Vector.<Item>;
        public var styles:Styles;

        public static function from_avatar_controller(_arg1:AvatarController):Look{
            var _local2:Look = new (Look)();
            _local2.items = _arg1.get_avatar_items();
            _local2.styles = _arg1.styles;
            var _local3:UserData = UserData.getInstance();
            _local2.name = _local3.user_name;
            if (_local3.team)
            {
                _local2.team = _local3.team.id;
            };
            _local2.user_id = DataManager.user_id;
            _local2.profile_url = (Constants.FB_PROFILE_URL + DataManager.user_id);
            return (_local2);
        }

        public function process_json(_arg1:Object):void{
            var _local2:Item;
            var _local3:Object;
            var _local6:int;
            this.id = _arg1.Avatar_ID;
            this.user_id = _arg1.user_ID;
            this.name = _arg1.name;
            this.team = int(_arg1.team_id);
            this.profile_url = (Constants.FB_PROFILE_URL + this.user_id);
            this.items = new Vector.<Item>();
            var _local4:Array = _arg1.items;
            var _local5:int = _local4.length;
            while (_local6 < _local5)
            {
                _local2 = new Item();
                _local3 = _local4[_local6];
                _local3.closet_category = _local3.Closet_category_ID;
                _local2.parseServerJSON(_local3);
                this.items.push(_local2);
                _local6++;
            };
            this.styles = new Styles();
            this.styles.process_json(_arg1);
            this.activeBoutique = (_arg1.activeBoutique == 1);
        }
        public function toString():String{
            return (Json.encode(this));
        }

    }
}//package com.viroxoty.fashionista.data

