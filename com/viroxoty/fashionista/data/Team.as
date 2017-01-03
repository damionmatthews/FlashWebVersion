// Decompiled by AS3 Sorcerer 1.78
// http://www.as3sorcerer.com/

//com.viroxoty.fashionista.data.Team

package com.viroxoty.fashionista.data{
    import com.viroxoty.fashionista.util.*;

    public class Team {

        public static var icon_path:String;
        public static var large_path:String;

        public var id:int;
        public var name:String;
        public var icon_url:String;
        public var large_url:String;
        public var members:int;
        public var leader:String;
        public var leader_id:String;
        public var votes:int;

        public function parseServerTeam(_arg1:Object):Boolean{
            this.id = int(_arg1.id);
            this.name = _arg1.name;
            this.icon_url = (icon_path + _arg1.image);
            this.large_url = (large_path + _arg1.image);
            this.members = int(_arg1.members);
            this.leader = _arg1.leader;
            this.leader_id = _arg1.leader_id;
            this.votes = int(_arg1.votes);
            return (true);
        }
        public function toString():String{
            return (((((((((((((this.id + " : ") + this.name) + " : ") + this.icon_url) + " : ") + this.large_url) + " : ") + this.members) + " : ") + this.leader) + " : ") + this.votes));
        }

    }
}//package com.viroxoty.fashionista.data

