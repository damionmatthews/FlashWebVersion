// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.Friend

package com.viroxoty.fashionista.data{
    import flash.events.EventDispatcher;
    import com.viroxoty.fashionista.*;
    import flash.events.*;
    import com.viroxoty.fashionista.util.*;

    public class Friend extends EventDispatcher {

        public static const FIRST_NAME_READY:String = "FIRST_NAME_READY";

        public var user_id:String;
        public var name:String;
        public var first_name:String;
        public var points:int;
        public var profile_url:String;
        public var pic_url:String;
        public var fb_friend:Boolean;
        public var a_list:Boolean;
        public var activeBoutique:Boolean;
        public var votes:int;
        public var looks:int;

        public static function parseAListObj(o:Object):Friend{
            var f:Friend;
            f = new (Friend)();
            f.user_id = o.user_ID;
            f.name = o.name;
            f.points = int(o.points);
            f.profile_url = o.fb_profile_url;
            f.pic_url = o.fb_pic_url;
            f.activeBoutique = (o.activeBoutique == "1");
            f.a_list = true;
            f.first_name = o.first_name;
            if (f.first_name == "")
            {
                try
                {
                    f.first_name = f.name.match(/^\w+/)[0];
                } catch(e:Error)
                {
                    Tracer.out(("didn't get a first name from " + f.name));
                };
            };
            return (f);
        }
        public static function parseFBFriendObj(_arg1:Object):Friend{
            var _local2:Friend = new (Friend)();
            _local2.name = _arg1.name;
            _local2.user_id = _arg1.id;
            _local2.pic_url = Constants.fb_pic_for_id(_local2.user_id);
            _local2.fb_friend = true;
            _local2.first_name = ((_arg1.first_name) || (""));
            return (_local2);
        }
        public static function parseObj(_arg1:Object):Friend{
            var _local2:String;
            var _local3:Friend = new (Friend)();
            for (_local2 in _arg1)
            {
                _local3[_local2] = _arg1[_local2];
            };
            return (_local3);
        }
        public static function getJoel():Friend{
            var _local1:Friend = new (Friend)();
            _local1.user_id = "100001708686352";
            _local1.name = "Joel Goodrich";
            _local1.first_name = "Joel";
            _local1.activeBoutique = true;
            _local1.a_list = true;
            return (_local1);
        }

        public function get pic():String{
            return (Constants.fb_pic_for_id(this.user_id));
        }
        public function fetch_first_name():void{
            FacebookConnector.get_friend_data(this);
        }
        public function update_fb_data(_arg1:Object){
            this.first_name = _arg1.first_name;
            dispatchEvent(new Event(FIRST_NAME_READY));
        }
        override public function toString():String{
            return (((((this.user_id + ":") + this.name) + ":") + this.votes));
        }

    }
}//package com.viroxoty.fashionista.data

